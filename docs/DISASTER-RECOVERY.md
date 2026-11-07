# Disaster recovery playbook

## Scenario A: VPS wiped (volume gone)

1. Re-provision (README Deployment A, steps 1-4).
2. `TELEGRAM_ALLOWED_IDS` already known — skip /id bootstrapping.
3. Reboot → /login → paste redirect → /start_node.
   Downtime budget: < 15 minutes for data you don't restore.

## Scenario B: data/ intact, image lost

`docker compose up -d --build` — state.json + credentials live on ./data; nothing else matters.

## Scenario C: token leaked/revoked by BotFather

1. Revoke: @BotFather → /revoke (do this FIRST even if it's already leaked).
2. New token in `.env` → `docker compose up -d`.
3. Audit recent bot activity; payload commands the bot executed while hijacked
   are logged — the earning node itself was NOT exposed more than those commands.

## Scenario D: login session invalid (CLI logged out)

/login again. If the OptimAI account itself was compromised → upstream account
recovery (docs.optimai.network), then re-login from the bot.

## Scenario E: bot spamming alerts (breaker loop)

1. /stop_node (persists stopped).
2. Diagnose VPS resources with /logs tail in the last alert.
3. Fix (RAM? disk? docker gone?) → /restart_node.

## Regular backups of data/

```bash
tar -czf backup-opt-data-$(date +%F).tgz data/
# then copy OFF-BOX (recommendation: gpg-encrypt before upload)
```
Keep at most 7 days of local copies; the snapshot contains credentials.
