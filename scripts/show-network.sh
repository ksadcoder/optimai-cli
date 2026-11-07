#!/usr/bin/env bash
# Display host network interfaces and default gateway.
set -euo pipefail

echo "=== Network Interfaces ==="
ip -br addr 2>/dev/null || ifconfig 2>/dev/null || echo "Network inspection tools unavailable"
echo ""

echo "=== Default Gateway ==="
ip route | grep default 2>/dev/null || netstat -rn 2>/dev/null || true
