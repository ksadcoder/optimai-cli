#!/usr/bin/env bash
# Monitor available system entropy for cryptographic operations.
set -euo pipefail

if [ -f /proc/sys/kernel/random/entropy_avail ]; then
  ENTROPY=$(cat /proc/sys/kernel/random/entropy_avail)
  echo "Available system entropy: $ENTROPY"
  if [ "$ENTROPY" -lt 200 ]; then
    echo "[WARN] Entropy pool is low (<200)!"
  else
    echo "[OK] Entropy pool is healthy."
  fi
else
  echo "[INFO] entropy_avail not supported on this kernel."
fi
