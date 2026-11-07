#!/usr/bin/env bash
# Query public IP address of the host node.
set -euo pipefail

echo "Detecting host public IP address..."
IP=$(curl -s4 --max-time 5 https://icanhazip.com || curl -s4 --max-time 5 https://ifconfig.me || echo "unknown")
echo "Public IPv4: $IP"
