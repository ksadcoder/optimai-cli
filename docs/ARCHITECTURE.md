# Architecture — how it all fits (deep dive)

## Diagram

```
┌──────────┐ long-polling (outbound) ┌────────────────────┐ subprocess ┌───────────────┐ docker.sock ┌─────────────┐
│ Telegram │←────────────────────────→│ bot/main.py (PTB)  │───────────→│ bot/optimai.py │────────────→│ host Docker │
│   (you)  │                          │ Application.loop   │  async     │ OptimaiCLI     │  workload   │   engine    │
└──────────┘                          └───────┬────────────┘  wrappers  └───────┬───────┘             └─────────────┘
                                              │ bot_data                        │
                                   ┌──────────┼──────────────┐                  │ HOME=/data/home
                                   ▼          ▼              ▼                  ▼ (.optimai creds)
                            bot/supervisor  bot/login_session  bot/gatekeeper   ./data volume
                            state.json      pexpect session    unauth_counts     node.log
```

## Module responsibilities (strict)

| Module | Owns | Never does |
|---|---|---|
| `bot/config.py` | env parsing/validation, fail-fast missing-vars error | network, Telegram |
| `bot/optimai.py` | async subprocess wrappers (`run`/`run_bin`), auth substring logic, docker probe, log allocators/rotation | process-group control |
| `bot/supervisor.py` | desired state `state.json`, spawn/SIGINT/SIGKILL, watch loop, backoff `5/15/60/300`, breaker at 5 | Telegram API calls directly (uses injected `alert_fn`) |
| `bot/login_session.py` | pexpect paste flow: capture URL, submit result parsing, TTL, single pending session | write files |
| `bot/gatekeeper.py` | promo budget per stranger, atomic JSON persistence | messaging |
| `bot/main.py` | handler wiring order, exact reply texts, lifecycle hooks, health port | Docker daemon management |

## Data layout under `/data`

```
/data
├── home/.optimai/     optimai CLI core binary + login credentials (survives rebuilds)
├── data/state.json    {"desired": "running"|"stopped"}  ← persists across reboot BY DESIGN
├── data/unauth_counts.json   {"<uid>": used_promo_replies}
└── data/node.log      appended stdout/stderr of the node process (rotated at 10 MB → .1)
```

## The three 24/7 layers

1. **Container layer** — `restart: unless-stopped` (compose) / `ON_FAILURE` (Railway `railway.json`).
2. **Supervisor layer** — 5 s tick: died while desired=running → alert + backoff restart; `_restart_scheduled`
   guard prevents the double-spawn race; 5 consecutive crashes → circuit breaker OPEN (one alert), closes on
   /start_node, /restart_node.
3. **Desired-state layer** — user stop is PERSISTENT (state.json written before killing), so reboots never
   resurrect a stopped node; running nodes auto-resume when authenticated + NODE_AUTO_START.

## Why SIGINT to the process GROUP

The CLI (v0.1.63 verified) has no `node stop` subcommand and shuts down gracefully on Ctrl+C. The node is
spawned with `start_new_session=True` → it is its own process-group leader → `os.killpg(SIGINT)` reaches the
whole tree cleanly, escalating to SIGKILL after 10 s.

## Railway honesty path

`docker_server_version()` calls the **docker CLI client directly** (`run_bin`), never `optimai-cli docker`
(which is not a subcommand — a real prior-build bug). No socket → every node command returns the exact
honest "no Docker daemon" error instead of failing mysteriously.
