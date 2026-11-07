# Cost comparison (EUR/USD estimates)

## TLD R: settings that earn

| Layout | Monthly | Can earn? | Effort |
|---|---|---|---|
| VPS (2vCPU/4GB) + docker + this bot | EUR 5-8 | YES (container workload) | `setup-vps.sh` → 4 commands |
| Hetzner-class + swap handled | EUR 4-6 | YES | same |
| Railway worker | ~USD 10-20 (usage-based) | NO (no docker.sock) | dashboard only, volume required |

## Decision procedure

1. Want PASSIVE EARNING? → VPS only. Railway literally cannot host the node.
2. Just testing THE BOT? → Railway worker is fine for /login /rewards /status.
3. MULTI-CLIENT hosting? → one hardened VPS per client is the clean pattern;
   per-node smaller boxes are cheaper than one big shared box + less noisy.

## Hidden-cost honesty

- swap: max quietly buy +2GB RAM instead (faster than swap; swap is a floor, not optimization)
- disk: node.log rotation stops growth (10MB cap locally) — notice rely on /logs
- Railway auto-restarts stop silently at plan limits: check usage thresholds if you use it as bot-only.
