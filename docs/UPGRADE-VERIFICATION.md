# Post-Upgrade Health Verification Procedure

After updating code or rebuilding Docker containers:

1. Send `/status` in Telegram → ensure desired state is `running`.
2. Send `/uptime` → verify process has started cleanly.
3. Send `/version` → verify running version matches expected tag.
4. Check `docker compose logs -f` → ensure zero traceback exceptions.
5. Send `/rewards` → confirm API credentials remain authenticated.
