# Gatekeeper Rate-Limiting and Visitor Quotas

To protect against spam and Telegram DM flooding, the bot enforces a strict
message quota for unauthenticated users.

---

## Quota Enforcement

1. **State Persistence**: Tracked per Telegram user ID in `data/gatekeeper.json`.
2. **Quota Cap**: Configured via `UNAUTH_MAX_MESSAGES` (clamped between 0 and 10).
3. **Mute State**: When exhausted, all further messages from the stranger are ignored silently.
4. **Admin Exemption**: Users in `TELEGRAM_ALLOWED_IDS` bypass the gatekeeper completely.
