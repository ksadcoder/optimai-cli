# Error catalog — what the CLI can say and what the bot does

| CLI surface | Text observed | Bot behavior |
|---|---|---|
| `auth status` (logged out) | `Not authenticated` **with exit code 0** | is_authenticated() = False (substring, never exit-code) |
| any command (logged out) | `Error: Not authenticated` | passthrough + "run /login first" hint in /rewards |
| `node start` without docker.sock | "Cannot connect to the Docker daemon"-style | caught at /status & /start_node, honest no-daemon error |
| CLI update warning line | `Important OptimAI CLI update available` | /status surfaces warning (contains_update_warning) |
| binary path wrong (OPTIMAI_BIN) | FileNotFoundError | supervisor alert: "binary not found; fix OPTIMAI_BIN" |
| CLI runs > 30 s during quick probes | process kill after timeout | (124, "timed out") handled, never blocks loop |
| login paste wrong/garbage | failure words in output | submit() resolves (False, raw text) |

## Rules for extending this table

1. Every new detected condition must map to an ACTION the bot takes (never a silent swallow).
2. Substring matching only on VERIFIED v0.1.63 output.
3. Any new behavior: extend the smoke suite in the SAME PR preventing regressions.
