#!/usr/bin/env bash
# Prune rotated log files older than N days.
set -euo pipefail

LOG_DIR="${1:-data}"
DAYS="${2:-7}"

echo "Pruning rotated logs in '$LOG_DIR' older than $DAYS days..."
if [ -d "$LOG_DIR" ]; then
  find "$LOG_DIR" -type f -name "*.log.*" -mtime +"$DAYS" -exec rm -f {} +
  echo "Pruning complete."
else
  echo "Directory $LOG_DIR not found, skipping."
fi
