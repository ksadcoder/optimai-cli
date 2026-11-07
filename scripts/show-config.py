#!/usr/bin/env python3
"""Inspect active configuration with sensitive values masked."""
from __future__ import annotations

import sys
import os

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from bot.config import Config


def mask_token(token: str) -> str:
    if not token or len(token) < 8:
        return "(empty/short)"
    parts = token.split(":")
    if len(parts) == 2:
        return f"{parts[0]}:***{parts[1][-4:]}"
    return f"{token[:4]}***{token[-4:]}"


def main() -> None:
    try:
        cfg = Config.load()
    except Exception as exc:
        print(f"Error loading configuration: {exc}", file=sys.stderr)
        sys.exit(1)

    print("=== OptimAI Bot Active Configuration ===")
    print(f"TELEGRAM_BOT_TOKEN:    {mask_token(cfg.bot_token)}")
    print(f"TELEGRAM_ALLOWED_IDS:  {sorted(cfg.allowed_ids)}")
    print(f"DATA_DIR:              {cfg.data_dir}")
    print(f"OPTIMAI_HOME:          {cfg.optimai_home}")
    print(f"NODE_AUTO_START:       {cfg.node_auto_start}")
    print(f"LOGIN_TTL_MINUTES:     {cfg.login_ttl_minutes}")
    print(f"ENABLE_HEALTH_PORT:    {cfg.enable_health_port or '(disabled)'}")
    print(f"UNAUTH_MAX_MESSAGES:   {cfg.unauth_max_messages}")


if __name__ == "__main__":
    main()
