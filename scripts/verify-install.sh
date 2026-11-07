#!/usr/bin/env bash
# End-to-end environment validation for OptimAI bot deployment.
set -euo pipefail

echo "=== Verifying Installation Prerequisites ==="
for cmd in docker python3 curl git; do
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "[OK] $cmd found: $(command -v "$cmd")"
  else
    echo "[FAIL] $cmd not found in PATH" >&2
  fi
done

if [ -f .env ]; then
  echo "[OK] .env configuration file present."
else
  echo "[WARN] .env configuration file missing (copy from .env.example)."
fi
