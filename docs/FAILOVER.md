# Host Failover and VPS Migration Runbook

Step-by-step procedures to migrate the OptimAI node to a replacement VPS.

---

## 1. Create Final Data Backup

On the source VPS:
```bash
bash scripts/backup-data.sh
```

## 2. Transfer Archive to Target VPS

```bash
scp backups/optimai-data-*.tar.gz root@<new-vps-ip>:~/optimai-cli/
```

## 3. Restore and Start

On the destination VPS:
```bash
bash scripts/restore-data.sh optimai-data-*.tar.gz
docker compose up -d --build
```
