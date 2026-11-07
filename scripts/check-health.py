#!/usr/bin/env python3
"""Quick healthcheck probe for OptimAI bot supervisor and data state."""
from __future__ import annotations

import json
import os
import sys

DATA_DIR = os.environ.get("DATA_DIR", "data")
STATE_FILE = os.path.join(DATA_DIR, "state.json")


def main() -> None:
    if not os.path.exists(DATA_DIR):
        print(f"[FAIL] DATA_DIR {DATA_DIR} does not exist", file=sys.stderr)
        sys.exit(1)

    if not os.path.exists(STATE_FILE):
        print(f"[WARN] {STATE_FILE} not found yet (node may not have started)")
        sys.exit(0)

    try:
        with open(STATE_FILE, "r", encoding="utf-8") as fh:
            state = json.load(fh)
    except Exception as exc:
        print(f"[FAIL] Could not parse {STATE_FILE}: {exc}", file=sys.stderr)
        sys.exit(1)

    desired = state.get("desired", "unknown")
    print(f"[OK] state.json readable: desired={desired}")


if __name__ == "__main__":
    main()
