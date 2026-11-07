# Production Security Hardening Checklist

Use this checklist when deploying the bot in production environments:

- [ ] **Token Protection**: `TELEGRAM_BOT_TOKEN` is defined only in `.env` and never checked into Git.
- [ ] **Access Control**: `TELEGRAM_ALLOWED_IDS` contains only verified numeric IDs of authorized admins.
- [ ] **Docker Socket**: Docker socket permissions are restricted to the container executing the supervisor.
- [ ] **Unauthenticated Gatekeeper**: `UNAUTH_MAX_MESSAGES` is set to clamp replies to strangers.
- [ ] **Firewall**: Inbound ports are blocked except optional SSH with public key authentication.
- [ ] **Log Retention**: Automated log rotation (`scripts/clean-logs.sh`) prevents disk exhaustion.
- [ ] **Backup**: Regular backups via `scripts/backup-data.sh` stored in secure remote storage.
