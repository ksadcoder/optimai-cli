#!/usr/bin/env bash
# Host diagnostic script for OptimAI Telegram Node deployments.
# Safe read-only checks; returns 0 if all vital checks pass.
set -euo pipefail

echo "=== OptimAI Telegram Node Host Preflight Check ==="

# 1. Docker Daemon Check
if ! command -v docker >/dev/null 2>&1; then
  echo "[-] Docker is not installed on this host."
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "[-] Docker daemon is not reachable. Is the service running?"
  exit 1
fi
echo "[+] Docker daemon is running and reachable."

# 2. Container Status
if docker compose ps --format json 2>/dev/null | grep -q "optimai"; then
  echo "[+] OptimAI container service is registered in docker compose."
else
  echo "[i] Note: No active optimai container detected via compose in current directory."
fi

# 3. Disk Space Check (root partition)
usage=$(df / --output=pcent | tail -1 | tr -dc "0-9")
if [ "$usage" -ge 90 ]; then
  echo "[-] WARNING: Root filesystem is ${usage}% full. Clean up docker caches with: docker system prune -f"
else
  echo "[+] Disk space healthy (${usage}% used)."
fi

# 4. Swap Status Check
swap_total=$(free -m | awk "/Swap:/ {print \$2}")
if [ "$swap_total" -eq 0 ]; then
  echo "[i] Note: No swap configured. Recommended >= 1GB swap for low-memory VPS."
else
  echo "[+] Swap configured (${swap_total} MB)."
fi

echo "=== Check Complete ==="
