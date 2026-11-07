#!/usr/bin/env bash
# Automated backup script for OptimAI bot persistent data.
set -euo pipefail

DATA_DIR="${DATA_DIR:-data}"
BACKUP_DIR="${BACKUP_DIR:-backups}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
ARCHIVE="${BACKUP_DIR}/optimai-data-${TIMESTAMP}.tar.gz"

if [ ! -d "$DATA_DIR" ]; then
  echo "Error: DATA_DIR '$DATA_DIR' does not exist." >&2
  exit 1
fi

mkdir -p "$BACKUP_DIR"
echo "Creating backup of '$DATA_DIR' to '$ARCHIVE'..."
tar -czf "$ARCHIVE" "$DATA_DIR"
echo "Backup complete: $ARCHIVE ($(du -h "$ARCHIVE" | cut -f1))"
