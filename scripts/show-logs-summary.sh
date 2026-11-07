#!/usr/bin/env bash
# Count errors and warnings in node.log.
set -euo pipefail

LOG_FILE="${1:-data/node.log}"
if [ ! -f "$LOG_FILE" ]; then
  echo "Log file $LOG_FILE not found." >&2
  exit 1
fi

ERRORS=$(grep -Eci "error|exception|critical" "$LOG_FILE" || echo 0)
WARNINGS=$(grep -Eci "warn|warning" "$LOG_FILE" || echo 0)

echo "=== Log Diagnostics Summary ($LOG_FILE) ==="
echo "Errors / Exceptions: $ERRORS"
echo "Warnings:            $WARNINGS"
