# Scheduled Maintenance Automation via Cron

Automate daily backups, log truncation, and Docker pruning via crontab:

```bash
# Open crontab editor
crontab -e
```

Recommended cron schedule:

```cron
# Daily backup at 02:00 AM
0 2 * * * /opt/optimai-cli/scripts/backup-data.sh >> /var/log/optimai-backup.log 2>&1

# Daily log maintenance at 03:00 AM
0 3 * * * /opt/optimai-cli/scripts/clean-logs.sh >> /var/log/optimai-clean.log 2>&1

# Weekly Docker image pruning on Sundays at 04:00 AM
0 4 * * 0 /opt/optimai-cli/scripts/clean-docker.sh >> /var/log/optimai-prune.log 2>&1
```
