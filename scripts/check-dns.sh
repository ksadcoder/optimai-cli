#!/usr/bin/env bash
# Measure DNS lookup latency for Telegram and OptimAI API endpoints.
set -euo pipefail

TARGETS=("api.telegram.org" "node.optimai.network")
echo "Testing DNS resolution latency..."

for target in "${TARGETS[@]}"; do
  START=$(date +%s%N)
  if getent hosts "$target" >/dev/null 2>&1; then
    END=$(date +%s%N)
    DIFF_MS=$(( (END - START) / 1000000 ))
    echo "[OK] $target resolved in ${DIFF_MS}ms"
  else
    echo "[FAIL] $target could not be resolved"
  fi
done
