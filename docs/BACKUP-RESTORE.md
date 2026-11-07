# Backup & Restore Guide

How to configure automated backups and perform disaster restoration for `optimai-cli` (OptimAI Telegram Node).

## 1. Critical State Paths

Only two directories contain state that cannot be recreated from source code:

| Host Directory | Container Mount | Contains | Loss Consequence |
|---|---|---|---|
| `~/.optimai` | `/data/home` | Auth token (`credentials.json`), node binary | Requires manual `/login` flow |
| `./data` | `/data/data` | `state.json`, `unauth_counts.json` | Muted stranger list reset |

All other code, configuration templates, and containers are stateless and re-buildable.

## 2. Automated Daily Cron Backup

Create `/usr/local/bin/backup-optimai.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="/var/backups/optimai"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
TARGET="$BACKUP_DIR/optimai_backup_$TIMESTAMP.tar.gz"

mkdir -p "$BACKUP_DIR"
tar -czf "$TARGET" -C "$HOME" .optimai -C "$HOME/optimai-cli" data

# Retain only last 7 daily archives
find "$BACKUP_DIR" -type f -name "optimai_backup_*.tar.gz" -mtime +7 -delete
```

Add to cron (`crontab -e`):
```cron
0 3 * * * /usr/local/bin/backup-optimai.sh >/dev/null 2>&1
```

## 3. Full Restore Procedure

To restore credentials on a newly provisioned server:

```bash
# 1. Unpack the backup archive
tar -xzf optimai_backup_YYYYMMDD_HHMMSS.tar.gz -C "$HOME"

# 2. Re-launch node container
cd ~/optimai-cli
docker compose up -d

# 3. Verify auth from Telegram
# Send /auth_status to your bot — should reply "Authenticated: ✅ yes"
```
