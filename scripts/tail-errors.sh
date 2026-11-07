#!/usr/bin/env bash
# Filter and stream error lines from node.log in real time.
set -euo pipefail

LOG_FILE="${1:-data/node.log}"
PATTERN="ERROR|CRITICAL|Exception|Traceback|failed"

if [ ! -f "$LOG_FILE" ]; then
  echo "Log file '$LOG_FILE' not found." >&2
  exit 1
fi

echo "Filtering '$LOG_FILE' for errors (pattern: $PATTERN)..."
grep -Ei --color=auto "$PATTERN" "$LOG_FILE" | tail -n 50 || echo "No errors found."
