#!/usr/bin/env bash
# Verify host system clock synchronization status.
set -euo pipefail

echo "Checking host system clock and NTP status..."
if command -v timedatectl >/dev/null 2>&1; then
  timedatectl status 2>/dev/null || echo "timedatectl query failed"
else
  date -u
fi
