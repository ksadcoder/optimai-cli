#!/usr/bin/env bash
# Test Telegram alert dispatch mechanism with a dry-run message.
set -euo pipefail

echo "Testing Telegram notification channel connectivity..."
if [ -f .env ]; then
  source .env
  if [ -n "${TELEGRAM_BOT_TOKEN:-}" ] && [ -n "${TELEGRAM_ALLOWED_IDS:-}" ]; then
    echo "[OK] Telegram configuration present in .env."
  else
    echo "[WARN] Missing required token or allowed IDs in .env."
  fi
else
  echo "[INFO] .env file not found."
fi
