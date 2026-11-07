#!/usr/bin/env bash
# Maintain node.log size to prevent disk bloat.
set -euo pipefail

LOG_FILE="${1:-data/node.log}"
MAX_SIZE_MB="${2:-50}"

if [ ! -f "$LOG_FILE" ]; then
  echo "Log file $LOG_FILE not found (nothing to clean)."
  exit 0
fi

SIZE_MB=$(du -m "$LOG_FILE" | cut -f1)
echo "Current log file size: ${SIZE_MB}MB (threshold: ${MAX_SIZE_MB}MB)"

if [ "$SIZE_MB" -gt "$MAX_SIZE_MB" ]; then
  echo "Truncating $LOG_FILE keeping latest 10,000 lines..."
  tail -n 10000 "$LOG_FILE" > "${LOG_FILE}.tmp"
  mv "${LOG_FILE}.tmp" "$LOG_FILE"
  echo "Truncation complete. New size: $(du -h "$LOG_FILE" | cut -f1)"
else
  echo "Log file is within acceptable limits."
fi
