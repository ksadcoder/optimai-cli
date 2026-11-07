# High Availability and Redundancy Architecture

Operating OptimAI nodes with zero downtime requires careful redundancy planning.
Because the OptimAI network ties node identity to a single account session, running
active-active nodes simultaneously can cause session conflicts.

---

## Recommended Topology: Warm Standby

1. **Primary VPS**: Runs 24/7 with the Dockerized Telegram bot and OptimAI node.
2. **Secondary Standby VPS**: Configured with identical `.env` and `setup-vps.sh` provisioned,
   but container stopped (`NODE_AUTO_START=false`).
3. **Volume Sync**: Periodic rsync of `./data/state.json` ensures state continuity.

---

## Failover Procedure

If the primary VPS experiences hardware failure or network partition:
1. Verify primary node is stopped.
2. Launch secondary node: `docker compose up -d`.
3. Send `/status` to confirm takeover.
