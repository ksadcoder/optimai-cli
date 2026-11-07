#!/usr/bin/env bash
# Prune dangling Docker images and builder caches to reclaim disk space.
set -euo pipefail

echo "Reclaiming disk space from unused Docker resources..."
if command -v docker >/dev/null 2>&1; then
  docker image prune -f
  docker builder prune -f --keep-storage 1GB 2>/dev/null || true
  echo "Docker pruning complete."
else
  echo "Docker not found, skipping."
fi
