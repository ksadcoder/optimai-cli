# Supervisor state machine (one-diagram reference)

```
                /start_node                  desired stopped (persisted FIRST)
 user ──┬── STOPPER ──→ [STOPPED] ←── STOPPER ─┐
        │ request_start         ↑ request_stop │ (reboots KEEP it by design)
        ▼                        │              │
     [RUNNING] ── crash (5s tick detects) ──→ [CRASHED]
        ↑                         │backoff 5/15/60/300
        │                         ▼
        └── _delayed_restart ──→ spawn again
                (guard _restart_scheduled = exactly one timer)
  5 consecutive crashes → BREAKER OPEN: no auto-restart, ONE alert,
  closes on /start_node or /restart_node.
```

## Invariants (never break these again)

1. desired-state write happens BEFORE every kill/spawn.
2. Booleans: SIGINT first (group), SIGKILL only after 10 s.
3. `_restart_scheduled` prevents the backoff timer + tick-loop double-spawn.
4. Consecutive-crash counter resets after 120 s of healthy uptime.
5. `stop_loop()` cancels WATCH ONLY — bot shutdown is not a node stop.
