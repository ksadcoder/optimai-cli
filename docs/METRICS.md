# Metrics & Observability Reference

How to monitor `optimai-cli` (OptimAI Telegram Node) in production using standard observability tools.

## 1. TCP Health Endpoint (`ENABLE_HEALTH_PORT`)

When configured in `.env` (e.g. `ENABLE_HEALTH_PORT=8080`), the bot spawns a lightweight `asyncio.start_server` HTTP responder:
- **Port**: Configurable, default `8080` (validated range 1-65535).
- **Response**: `HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nok\n`
- **Use Case**: Target for cloud load-balancer health checks, Railway health checks, Docker healthcheck instructions, and external uptime pingers (e.g. Uptime Kuma).

## 2. Supervisor State Snapshot

The supervisor tracks continuous operational metrics exposed via `/status` and accessible in Python:

| Metric | Type | Meaning |
|---|---|---|
| `running` | boolean | True if the node subprocess PID is alive and actively running |
| `desired` | string | Operator target state (`running` or `stopped`) |
| `pid` | integer | Active Linux OS process ID of `optimai-cli` |
| `uptime` | string | Formatted duration since node process start (e.g. `12h 45m`) |
| `crashes` | integer | Number of consecutive unexpected process terminations |
| `breaker` | boolean | True if 5 consecutive crashes reached; supervisor stops auto-restarting |
| `backoff_level` | integer | Current backoff index (0=5s, 1=15s, 2=60s, 3=300s) |
| `last_exit_code` | integer / None | Exit code from the last process termination |

## 3. Telegram Alert Events

The bot emits high-priority Telegram push messages on:
- **Crash Recovery Attempt**: Sent on consecutive crash counts < 5 with backoff timer notice.
- **Circuit Breaker Tripped**: Sent once when consecutive crashes reach 5, accompanied by the trailing 15 lines of node logs.
- **CLI Update Warning**: Surfaces whenever upstream `optimai-cli` prints upgrade notices.
