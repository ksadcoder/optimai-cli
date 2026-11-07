#!/usr/bin/env bash
# Verify git status is clean before deployment.
set -euo pipefail

if [ -n "$(git status --porcelain)" ]; then
  echo "[WARN] Working directory has uncommitted changes:"
  git status --short
  exit 1
else
  echo "[OK] Git working directory is clean."
fi
