#!/usr/bin/env bash
# Inspect and format host system uptime.
set -euo pipefail

if [ -f /proc/uptime ]; then
  read -r UP_SEC _ < /proc/uptime
  UP_INT=${UP_SEC%.*}
  DAYS=$(( UP_INT / 86400 ))
  HOURS=$(( (UP_INT % 86400) / 3600 ))
  MINS=$(( (UP_INT % 3600) / 60 ))
  echo "Host System Uptime: ${DAYS}d ${HOURS}h ${MINS}m (${UP_INT} seconds)"
else
  uptime
fi
