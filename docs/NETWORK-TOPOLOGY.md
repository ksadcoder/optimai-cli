# Network Topology and Communication Diagram

```
                 Outbound HTTPS (443)
[Bot Container] ───────────────────────► [Telegram API]
       │
       │ Local Unix Socket
       ▼
[/var/run/docker.sock] ────────────────► [OptimAI CLI Node]
```

- **Inbound Connections**: None required.
- **Outbound Connections**: Port 443 TCP to `api.telegram.org` and OptimAI backend.
