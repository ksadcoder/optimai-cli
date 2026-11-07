# Operational Audit Trail Specification

All sensitive lifecycle operations (start, stop, restart, login) generate
structured audit logs:

- **Timestamp**: ISO-8601 UTC.
- **Admin User ID**: Telegram numeric ID.
- **Action**: Target command executed.
- **Result**: Success or error status.
