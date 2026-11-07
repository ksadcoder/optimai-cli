# Glossary — OptimAI Telegram Node

| Term | Meaning |
|---|---|
| **Desired state** | What you WANT the node to be (`running` or `stopped`), persisted in `data/state.json` before any action is taken so it survives reboots. |
| **Supervisor** | `bot/supervisor.py` watch loop (5 s tick) that compares desired ↔ actual state and repairs the difference. |
| **Backoff** | Crash restart delay schedule: 5s → 15s → 60s → 300s, applied after each consecutive crash. |
| **Circuit breaker** | After 5 consecutive crashes auto-restarts STOP and one alert is sent. Closes via `/start_node` or `/restart_node`. |
| **Paste login** | Headless auth flow: CLI prints a login URL (`auth login --no-open --paste`), you sign in anywhere, paste the redirect back; the bot types it into the CLI via pexpect. |
| **Promo budget** | Total paramo replies an unauthorized stranger can EVER receive (`UNAUTH_MAX_MESSAGES`, default 3, persisted in `unauth_counts.json`; 0 = silent). |
| **Honesty path** | Railway behavior: no docker.sock → node commands return the exact "no Docker daemon here" error instead of a mysterious crash. |
| **Persistent stop** | `/stop_node` result that survives reboots forever until `/start_node`. |
| **docker.sock** | The host's Docker control socket mounted into the container — the ONLY way the node workload can run; absent on Railway. |
| **Deafard state** | — |
| **Sleep debt** | — |
| **node.log** | The node process's stdout+stderr, appended under `/data/data`; rotated at 10 MB into `node.log.1`. |
| **drop_pending_updates** | Telegram polling option that discards messages sent while the bot was offline — stale command floods don't execute. |
| **Pair credit** | GitHub achievement engine: a merged PR whose commits contain `Co-authored-by:` trailers credits every listed co-author. This repo temporarily stamps trailers automatically (SETUP-PAIR.md). |
