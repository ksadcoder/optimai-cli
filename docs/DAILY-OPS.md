# Daily Operations & Health Checklist

This checklist is designed for operators running `optimai-cli` (OptimAI Telegram Node) on a Linux VPS or cloud instance. Perform these checks periodically or set up cron monitoring.

## 1. Quick Health Check (from Telegram)

Run `/status` in your Telegram chat with the bot:
- **Node**: Should be `running (Xh Ym, PID Z)`.
- **Desired state**: Should be `running`.
- **Authenticated**: Must show `✅ yes`. If `❌ no`, run `/login`.
- **Docker**: Must show `✅ reachable`.
- **Circuit breaker**: Should be `ok` or `tripped=False`.

## 2. Docker & Process Health (on VPS)

```bash
# Check if container is healthy and running
docker compose ps

# Inspect recent container logs for unexpected restarts
docker compose logs --tail=50 optimai-bot

# Verify host Docker daemon status
systemctl status docker --no-pager
```

## 3. Disk Space & Log Rotation

OptimAI workload containers and bot logs write to disk. Verify space regularly:

```bash
# Check available disk space
df -h /

# Check Docker resource usage
docker system df

# Clean up dangling images and stopped build containers if disk is > 85% full
docker system prune -f
```

## 4. Telegram Rate Limit & Promo Mutes

- Check `data/unauth_counts.json` occasionally to see the volume of blocked unauthorized messages.
- If someone was muted by mistake, remove their Telegram ID from `data/unauth_counts.json` and restart the bot.

## 5. Persistent Volume Backup

The credentials and CLI binary reside in `~/.optimai/` (mapped to `/root/.optimai` inside the container):

```bash
# Quick backup of auth session before host maintenance
tar -czvf ~/optimai-backup-$(date +%Y%m%d).tar.gz ~/.optimai
```
