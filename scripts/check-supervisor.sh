#!/usr/bin/env bash
# Verify bot supervisor process is active.
set -euo pipefail

if pgrep -f "bot.main" >/dev/null 2>&1; then
  echo "[OK] Bot supervisor process is running."
else
  echo "[WARN] Bot supervisor process not found in host process table (may be running in Docker container)."
fi
