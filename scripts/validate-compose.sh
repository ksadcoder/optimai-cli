#!/usr/bin/env bash
# Validate docker compose syntax using dummy credentials.
set -euo pipefail

echo "Validating docker compose syntax..."
if command -v docker >/dev/null 2>&1; then
  cp -n .env.example .env.validate.tmp 2>/dev/null || true
  sed -i 's/^TELEGRAM_BOT_TOKEN=$/TELEGRAM_BOT_TOKEN=dummy:test/' .env.validate.tmp 2>/dev/null || true
  sed -i 's/^TELEGRAM_ALLOWED_IDS=$/TELEGRAM_ALLOWED_IDS=123/' .env.validate.tmp 2>/dev/null || true
  docker compose --env-file .env.validate.tmp config >/dev/null
  rm -f .env.validate.tmp
  echo "[OK] docker compose configuration is valid."
else
  echo "[INFO] docker binary not available, skipping compose validation."
fi
