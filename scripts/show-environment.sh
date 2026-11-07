#!/usr/bin/env bash
# Display safe, non-sensitive environment variables.
set -euo pipefail

echo "=== System Execution Environment ==="
echo "USER:               ${USER:-unknown}"
echo "SHELL:              ${SHELL:-unknown}"
echo "PATH:               $PATH"
echo "PYTHONUNBUFFERED:   ${PYTHONUNBUFFERED:-unset}"
echo "DATA_DIR:           ${DATA_DIR:-data}"
