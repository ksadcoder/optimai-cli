#!/usr/bin/env bash
# Check if configured ports are in use by conflicting processes.
set -euo pipefail

PORT="${1:-8080}"
echo "Checking port $PORT for conflicting processes..."

if command -v ss >/dev/null 2>&1; then
  if ss -tuln | grep -q ":${PORT} "; then
    echo "[WARN] Port $PORT is already in use by another service!"
    exit 1
  else
    echo "[OK] Port $PORT is free."
  fi
else
  echo "[INFO] ss utility not installed, skipping port check."
fi
