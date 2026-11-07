#!/usr/bin/env bash
# Verify Docker socket accessibility and container runtime status.
set -euo pipefail

SOCKET="${DOCKER_SOCKET:-/var/run/docker.sock}"

echo "Checking Docker socket: $SOCKET..."
if [ ! -S "$SOCKET" ]; then
  echo "[FAIL] Socket $SOCKET does not exist or is not a socket." >&2
  exit 1
fi

if [ ! -r "$SOCKET" ] || [ ! -w "$SOCKET" ]; then
  echo "[FAIL] Socket $SOCKET has insufficient permissions." >&2
  exit 1
fi

echo "[OK] Docker socket is accessible."
if command -v docker >/dev/null 2>&1; then
  docker version --format '{{.Server.Version}}' 2>/dev/null && echo "[OK] Docker engine responding." || echo "[WARN] Docker CLI unable to query engine."
fi
