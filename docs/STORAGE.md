# Storage and Volume Persistence Specification

The OptimAI Telegram bot persists all critical node state on the host filesystem under `./data`.

---

## Directory Layout

```
data/
├── state.json          # Desired state, circuit breaker status, crash metrics
├── node.log            # Stderr and stdout output from optimai-cli node
├── node.log.1          # Rotated archive of previous log output
└── gatekeeper.json     # Unauthenticated visitor message budget tracking
```

---

## Durability Invariants

1. **Atomic Write**: State mutations write to temporary files before atomic rename to avoid corruption.
2. **Reboot Survival**: `state.json` survives host power cycles and container restarts.
3. **Log Rotation**: Built-in rotation preserves `.1` backup before truncation when size exceeds threshold.
