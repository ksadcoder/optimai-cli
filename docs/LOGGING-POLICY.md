# Logging and Privacy Policy Specification

The OptimAI bot records operational telemetry while preserving privacy.

---

## Logging Guidelines

1. **Token Masking**: Never print raw bot tokens or OAuth secrets in logs.
2. **Log Levels**: INFO for lifecycle events; WARNING for retries; ERROR for unhandled exceptions.
3. **Local Storage**: Logs are restricted to `./data/node.log` on the host volume.
