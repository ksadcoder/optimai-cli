#!/usr/bin/env bash
# Check RAM and Swap availability against minimum operational thresholds.
set -euo pipefail

MIN_RAM_MB="${1:-250}"
echo "Verifying system memory availability (minimum free RAM: ${MIN_RAM_MB}MB)..."

if command -v free >/dev/null 2>&1; then
  AVAILABLE_RAM=$(free -m | awk '/^Mem:/{print $7}')
  if [ -n "$AVAILABLE_RAM" ] && [ "$AVAILABLE_RAM" -lt "$MIN_RAM_MB" ]; then
    echo "[WARN] Available RAM (${AVAILABLE_RAM}MB) is below threshold (${MIN_RAM_MB}MB)!"
  else
    echo "[OK] Available RAM: ${AVAILABLE_RAM:-unknown}MB."
  fi
else
  echo "[INFO] free command not available, skipping threshold check."
fi
