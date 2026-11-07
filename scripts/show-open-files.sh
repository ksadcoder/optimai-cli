#!/usr/bin/env bash
# Count open file descriptors allocated by the host system.
set -euo pipefail

if [ -f /proc/sys/fs/file-nr ]; then
  read -r allocated _ max < /proc/sys/fs/file-nr
  echo "Open File Descriptors: $allocated allocated of $max maximum"
else
  echo "File descriptor statistics unavailable"
fi
