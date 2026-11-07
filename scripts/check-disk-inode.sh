#!/usr/bin/env bash
# Verify filesystem inode utilization.
set -euo pipefail

echo "Checking filesystem inode usage..."
df -i .
