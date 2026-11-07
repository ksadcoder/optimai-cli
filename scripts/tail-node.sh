#!/usr/bin/env bash
# Live-tail the OptimAI node output with timestamps.
set -euo pipefail

LOG_FILE="${1:-data/node.log}"
LINES="${2:-50}"

if [ ! -f "$LOG_FILE" ]; then
  echo "Log file $LOG_FILE not found." >&2
  exit 1
fi

echo "Tailing last $LINES lines of $LOG_FILE (Ctrl+C to stop)..."
tail -n "$LINES" -f "$LOG_FILE"
