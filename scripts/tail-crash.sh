#!/usr/bin/env bash
# Extract the 20 lines preceding the last crash event in node.log.
set -euo pipefail

LOG_FILE="${1:-data/node.log}"
if [ ! -f "$LOG_FILE" ]; then
  echo "Log file $LOG_FILE not found." >&2
  exit 1
fi

echo "Inspecting last 20 lines of $LOG_FILE for crash context:"
tail -n 20 "$LOG_FILE"
