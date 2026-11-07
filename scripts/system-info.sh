#!/usr/bin/env bash
# Diagnostics summary for the host VPS running OptimAI bot.
set -euo pipefail

echo "=== System Architecture ==="
uname -a
echo ""

echo "=== Memory Usage ==="
free -h 2>/dev/null || free -m 2>/dev/null || echo "free command not available"
echo ""

echo "=== Storage Usage ==="
df -h .
echo ""

echo "=== Docker Status ==="
if command -v docker >/dev/null 2>&1; then
  docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}" 2>/dev/null || echo "Docker daemon inaccessible or not running"
else
  echo "Docker binary not found"
fi
