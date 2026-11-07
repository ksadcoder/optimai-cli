#!/usr/bin/env bash
# Restore OptimAI bot persistent data from a backup archive.
set -euo pipefail

ARCHIVE="${1:-}"
TARGET_DIR="${2:-data}"

if [ -z "$ARCHIVE" ]; then
  echo "Usage: $0 <path-to-archive.tar.gz> [target-dir]" >&2
  exit 1
fi

if [ ! -f "$ARCHIVE" ]; then
  echo "Error: Archive file '$ARCHIVE' not found." >&2
  exit 1
fi

echo "Restoring data from '$ARCHIVE' into '$TARGET_DIR'..."
mkdir -p "$TARGET_DIR"
tar -xzf "$ARCHIVE" -C .
echo "Restore complete: '$TARGET_DIR' restored."
