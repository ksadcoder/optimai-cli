# Incident Triage Runbook

Rapid troubleshooting guides for common VPS and node operation incidents.

## 1. Node Crash-Loop & Circuit Breaker Tripped

- **Symptom**: Telegram bot sends alert: `⚠️ Circuit breaker TRIPPED after 5 consecutive crashes`.
- **Root Causes**:
  - Out of memory during workload container execution.
  - Disk full on `/` partition.
  - Stale or corrupted auth tokens in `~/.optimai/`.
- **Triage Steps**:
  1. Inspect container crash logs:
     ```bash
     docker compose logs --tail=100 optimai-bot
     ```
  2. Check host RAM and swap:
     ```bash
     free -m
     ```
  3. If RAM exhausted, verify swapfile is active (`swapon --show`).
  4. Reset circuit breaker and restart node from Telegram: `/restart_node`.

## 2. Docker Daemon Not Reachable

- **Symptom**: Telegram `/status` reports `Docker: ❌ NOT REACHABLE`.
- **Root Causes**:
  - Docker daemon crashed on the VPS host.
  - `/var/run/docker.sock` permissions changed or socket missing from volume mount.
- **Triage Steps**:
  1. Check Docker status on host:
     ```bash
     systemctl status docker
     ```
  2. Restart Docker daemon:
     ```bash
     systemctl restart docker
     ```
  3. Restart the bot container:
     ```bash
     docker compose restart optimai-bot
     ```

## 3. Telegram API Polling Timeouts (Conflict / Network)

- **Symptom**: Bot does not respond to Telegram commands; logs show `NetworkError` or `ConflictError`.
- **Root Causes**:
  - Another instance of the bot is running with the same `TELEGRAM_BOT_TOKEN`.
  - VPS egress traffic to `api.telegram.org` is blocked or packet loss is high.
- **Triage Steps**:
  1. Check for duplicate running containers:
     ```bash
     docker ps -a --filter "name=optimai"
     ```
  2. Verify outgoing connectivity:
     ```bash
     curl -I https://api.telegram.org
     ```
  3. If token leaked or conflict persists, revoke and generate a new token via @BotFather.
