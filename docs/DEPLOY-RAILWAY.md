# Deployment B — Railway (bot control-plane ONLY)

Honest reality: Railway containers get **no `/var/run/docker.sock`** and no
privileged mode → the optimai node workload CANNOT run there. The bot self-
detects and warns (/status shows the exact warning, /start_node refuses with
the honest error). Use Railway to test the bot or separate the control-plane;
use the VPS for the actual earning node.

## 1. Create the project

Dashboard: New Project → Deploy from GitHub repo (or CLI path below — no git
push needed):

```bash
npm i -g @railway/cli
railway login
railway init
railway up
```

## 2. Variables (dashboard → Variables)

| Variable | Value |
|---|---|
| `TELEGRAM_BOT_TOKEN` | @BotFather token |
| `TELEGRAM_ALLOWED_IDS` | your numeric Telegram ID (from /id) |
| `NODE_AUTO_START` | false recommended here (no daemon anyway) |
| `TZ` | e.g. Asia/Kolkata |

## 3. Volume (REQUIRED)

Service → Volumes → New Volume mounted at `/data`. Without it, login + state
are wiped on EVERY deploy.

## 4. Service type: Worker

The `Procfile` (worker: python -m bot.main) packages already; long polling is
outbound-only → no public port needed. If you deploy as a web service instead,
the bot automatically binds to Railway's `$PORT` (or `ENABLE_HEALTH_PORT`) for
`GET /health -> 200 OK` health checks.

## 5. Verify

- Boot DM: "Bot online. Node desired: stopped | Docker: NOT REACHABLE | Auth: no."
  ← the NOT REACHABLE part is EXPECTED, that's the honest warning feature.
- Works: /login /auth_status /rewards /logs /status /help /me /cancel /version /ping /uptime /disk /system /healthcheck /id
- Fails by design: /start_node /stop_node /restart_node /watch
  (bot replies with the exact "no Docker daemon here" error)

## 6. Cost honesty

Railway is usage-based (~USD 10-20/mo for a small always-on worker) and still
cannot run the node. A flat EUR 4-6/mo VPS runs bot AND node → prefer the VPS
(README, Deployment A); Railway is for testing / control-plane separation.
