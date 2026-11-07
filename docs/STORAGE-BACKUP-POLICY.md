# Persistent Storage Backup Policy

Guidelines for protecting persistent node credentials and state:

1. **Daily Incremental**: Run `scripts/backup-data.sh` at 02:00 UTC.
2. **Weekly Full**: Store weekly archive off-host (e.g. S3 or cold storage).
3. **Retention**: Keep 7 daily backups and 4 weekly snapshots.
4. **Encryption**: Encrypt off-host archives using GPG or age.
