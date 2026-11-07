"""Unauthorized-user promo rate limiter (the hosting-provider funnel).

Each Telegram user ID gets a TOTAL budget of promo replies
(`UNAUTH_MAX_MESSAGES`, clamped 0-10). Counts persist in
`DATA_DIR/unauth_counts.json` with atomic writes: a stranger who burned
their replies stays muted FOREVER across restarts until the owner
intervenes (edit or delete the file). `max_messages=0` = fully silent.
"""

from __future__ import annotations

import json
import logging
import os
from typing import Dict

log = logging.getLogger(__name__)


class UnauthorizedGate:
    def __init__(self, path: str, max_messages: int = 3) -> None:
        self.path = path
        self.max_messages = max(0, int(max_messages))
        self._counts: Dict[str, int] = self._load()

    # ------------------------------------------------------------------
    # Public API
    # ------------------------------------------------------------------

    def may_reply(self, user_id: int) -> bool:
        """True while this account has budget left (and max > 0)."""
        if self.max_messages <= 0:
            return False
        return self._counts.get(str(user_id), 0) < self.max_messages

    def record(self, user_id: int) -> int:
        """Increment the usage counter for `user_id` and persist.
        Returns the new count."""
        key = str(user_id)
        # str key; guarantee exactly max_messages recorded total
        self._counts[key] = self._counts.get(key, 0) + 1
        self._save()
        return self._counts[key]

    def reset(self, user_id: int) -> None:
        """Clear one account's counter (tests; owner can also delete the file)."""
        self._counts.pop(str(user_id), None)
        self._save()

    # ------------------------------------------------------------------
    # Persistence
    # ------------------------------------------------------------------

    def _load(self) -> Dict[str, int]:
        try:
            with open(self.path, "r", encoding="utf-8") as fh:
                raw = json.load(fh)
            if isinstance(raw, dict):
                return {
                    str(k): int(v)
                    for k, v in raw.items()
                    if isinstance(v, (int, float))
                }
        except (OSError, ValueError, TypeError):
            pass
        return {}

    def _save(self) -> None:
        """Atomic write: tmp file + os.replace (survives crashes)."""
        tmp = self.path + ".tmp"
        try:
            with open(tmp, "w", encoding="utf-8") as fh:
                json.dump(self._counts, fh, sort_keys=True)
            os.replace(tmp, self.path)
        except OSError as exc:
            log.error("Cannot persist %s: %s", self.path, exc)
