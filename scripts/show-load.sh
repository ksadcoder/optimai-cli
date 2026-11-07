#!/usr/bin/env bash
# Display CPU load average of the host.
set -euo pipefail

if [ -f /proc/loadavg ]; then
  read -r l1 l5 l15 _ < /proc/loadavg
  echo "Host load average: 1m=${l1}, 5m=${l5}, 15m=${l15}"
else
  uptime | awk -F'load average:' '{ print "Host load average:" $2 }'
fi
