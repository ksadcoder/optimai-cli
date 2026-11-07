# Deployment Architecture Comparison

How the **Dockerized OptimAI Telegram Node** compares against traditional approaches like naked CLI runs inside `tmux` or system-level `systemd` service units.

## Comparison Matrix

| Feature | OptimAI Telegram Node (Docker) | Naked CLI in `tmux` / `screen` | Raw `systemd` Service |
|---|---|---|---|
| **Remote Control** | ✅ Telegram commands (`/start_node`, `/stop_node`, `/status`) | ❌ Requires SSH login into VPS | ❌ Requires SSH + `systemctl` |
| **Mobile Access** | ✅ Native iOS/Android via Telegram app | ❌ Mobile SSH client required | ❌ Mobile SSH client required |
| **Crash Alerting** | ✅ Real-time push alert with log tail to Telegram | ❌ None (silent failure) | ❌ Needs third-party alerting (Prometheus/Grafana) |
| **Headless Login Flow** | ✅ Full copy/paste OAuth code flow via Telegram bot | ⚠️ Manual SSH and terminal paste | ❌ Interactive stdin not supported by systemd |
| **Backoff & Breaker** | ✅ 5-tier backoff (5s/15s/60s/300s) + circuit breaker | ❌ None (or naive while-true crashloop) | ⚠️ Restart=always loops on bad credentials |
| **Monetization Funnel** | ✅ Built-in rate limiter + hosting promo pitch | ❌ None | ❌ None |
| **Docker Isolation** | ✅ Containerized Python bot + volume mounts | ❌ Naked host execution | ❌ Naked host execution |
| **State Persistence** | ✅ Isolated `/data` volume for credentials and logs | ⚠️ Host filesystem (`~/.optimai`) | ⚠️ Host filesystem (`~/.optimai`) |

## When to Use Which?

1. **Use OptimAI Telegram Node (Recommended)**:
   - When managing nodes 24/7 on remote VPS without wanting to open an SSH terminal daily.
   - When running a node hosting service for clients where unauthorized strangers need rate limiting.
   - When instant Telegram push notifications on crashes are critical.

2. **Use Naked CLI in `tmux`**:
   - For quick one-off testing on local developer workstations during manual debugging.

3. **Use Raw `systemd` Unit**:
   - For headless servers where enterprise syslog monitoring and auditd integration are strictly enforced by company policy.
