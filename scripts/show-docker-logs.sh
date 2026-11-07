#!/usr/bin/env bash
# Quick-tail container logs from docker compose.
set -euo pipefail

LINES="${1:-50}"
echo "Tailing last $LINES lines of docker compose logs..."
docker compose logs --tail="$LINES" 2>/dev/null || echo "Docker compose logs unavailable"
