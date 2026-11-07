#!/usr/bin/env bash
# Generate a consolidated diagnostic summary report.
set -euo pipefail

REPORT_FILE="optimai-diag-$(date +%Y%m%d_%H%M%S).txt"
echo "Generating diagnostic bundle to $REPORT_FILE..."

{
  echo "=== SYSTEM ==="
  uname -a
  echo ""
  echo "=== MEMORY ==="
  free -h 2>/dev/null || free -m 2>/dev/null || true
  echo ""
  echo "=== DISK ==="
  df -h .
  echo ""
  echo "=== DOCKER ==="
  docker ps 2>/dev/null || echo "docker ps failed"
  echo ""
  echo "=== STATE ==="
  cat data/state.json 2>/dev/null || echo "state.json not found"
} > "$REPORT_FILE"

echo "Report generated: $REPORT_FILE ($(du -h "$REPORT_FILE" | cut -f1))"
