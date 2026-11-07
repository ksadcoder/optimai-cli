# OptimAI Telegram Node v1.0.0

![CI](https://github.com/mkr-infinity/optimai-cli/actions/workflows/ci.yml/badge.svg)
![Python](https://img.shields.io/badge/python-3.12-blue)
![License](https://img.shields.io/badge/license-Apache--2.0-green)
![Version](https://img.shields.io/badge/version-1.0.0-orange)
[![Telegram](https://img.shields.io/badge/contact-%40mkr__infinity-blue)](https://t.me/mkr_infinity)

**Your 24/7 OptimAI Network node, controlled entirely from Telegram** — start it, stop it, restart it,
 read live logs, check rewards, even log in, all with simple commands on your phone. If the node
 crashes at 3 AM, the bot restarts it automatically and DMs you.

```
┌──────────┐  long-polling   ┌────────────────────┐  subprocess   ┌──────────────┐  docker.sock  ┌─────────────┐
│ Telegram │ ←──────────────→│  bot container     │←────────────→ │ optimai-cli  │←─────────────→│ host Docker │
│  (you)   │   outbound-only │  (python-telegram) │   wrapping    │ + creds/vol  │   workload    │   engine    │
└──────────┘                 └────────────────────┘               └──────────────┘               └─────────────┘
```

> ⚠️ An unauthorized stranger who messages the bot gets a short, rate-limited promo reply pointing to
 **@mkr_infinity** for paid node hosting — this is a hosting-provider deployment.

---

## 1. What is this

`optimai-telegram-node` is a Dockerized Python Telegram bot that runs the **OptimAI CLI node** 24/7 on
 a VPS and gives the owner full remote control from Telegram: `/start_node`, `/stop_node`,
`/restart_node`, `/status`, `/rewards`, `/logs`, `/watch`, and a browserless `/login` flow. A built-in
 desired-state supervisor (`state.json`) guarantees crash auto-restart with exponential backoff, a
 circuit breaker, and persistent stops. The same repo deploys to **Railway** for testing
 (bot control-plane only — see the honest appendix; the node workload itself needs a VPS with Docker).

## 2. Prerequisites

- **VPS** (recommended): €4-6/month — Hetzner, Contabo, RackNerd — Ubuntu 22.04/24.04, 2 GB+ RAM,
15-20 GB disk, **or** a [Railway](https://railway.com) account for bot-only testing
- A **Telegram account**
- An **OptimAI account** (register at https://node.optimai.network)
- A bot created with **@BotFather** (takes 2 minutes)

## 3. Beginner guide — VPS in 7 steps

**Step 1 — Rent a VPS.** Pick any €4-6/mo Ubuntu 22.04+ box. You get an IP address
 (e.g. `203.0.113.7`) and a root password.

**Step 2 — Get the project onto the VPS.**

```bash
# on YOUR PC (from the folder where this project is):
zip -r optimai-cli.zip . -x "data/*" ".git/*" ".env"
scp optimai-cli.zip root@203.0.113.7:~
ssh root@203.0.113.7
```

**Step 3 — Prepare the VPS (Docker + 2G swap).**

```bash
unzip optimai-cli.zip && cd optimai-cli   # folder name = wherever you unzipped
bash setup-vps.sh
```

**Step 4 — Fill in exactly 2 required values.**

```bash
cp .env.example .env && nano .env
```

| Value | Where it comes from |
|---|---|
| `TELEGRAM_BOT_TOKEN=` | Telegram → open a chat with **@BotFather** → `/newbot` → copy the token |
| `TELEGRAM_ALLOWED_IDS=` | Leave empty for now — see Step 5 |

**Step 5 — Start the stack.**

```bash
docker compose up -d --build
docker compose logs -f          # expect the banner + "Bot online."
```

Open the bot in Telegram and send **/id** → it replies with your numeric ID. Put that ID into
`TELEGRAM_ALLOWED_IDS=123456789` in `.env`, then restart:

```bash
docker compose up -d
```

**Step 6 — Log in (no browser on the server needed).**

Send `/login` in Telegram → a button opens the OptimAI login page on YOUR phone/PC → sign in →
copy the final redirect URL → paste it into the bot chat. Done.

**Step 7 — Start the node and verify.**

```bash
# in Telegram:
/start_node
/status        # node: running (uptime…), Docker: ✅ reachable, Auth: ✅ yes
/rewards       # your balance
```

You're live. Updating later: upload the new code (or `git pull`) and run
`docker compose up -d --build`. Your data (login, state) survives rebuilds — it lives in `./data:/data`.

## 4. Environment variables

| Variable | Required? | Default | Where it comes from |
|---|---|---|---|
| `TELEGRAM_BOT_TOKEN` | ✅ required | — | @BotFather → `/newbot` → copy token |
| `TELEGRAM_ALLOWED_IDS` | ✅ required | — | `/id` command (Step 5) or @userinfobot |
| `NODE_AUTO_START` | optional | `true` | auto-start on boot when authed + desired=running |
| `LOG_TAIL_LINES` | optional | `40` | lines shown by `/logs` |
| `WATCH_SECONDS` | optional | `120` | `/watch` default duration (10-600) |
| `LOGIN_TTL_MINUTES` | optional | `15` | pending login session expiry |
| `ENABLE_HEALTH_PORT` | optional | *(off)* | set e.g. `8080` → `GET /health` returns `200 OK` (platform healthchecks; VPS doesn't need it) |
| `TZ` | optional | `UTC` | log timezone, e.g. `Asia/Kolkata` |
| `CONTACT_USERNAME` | optional | `mkr_infinity` | promo target for unauthorized users (no `@`) |
| `UNAUTHORIZED_MESSAGE` | optional | *(empty)* | full override text; may contain `{contact}` |
| `UNAUTH_MAX_MESSAGES` | optional | `3` | total promo replies per stranger (0-10, `0` = silent) |
| `OPTIMAI_HOME` | internal | `/data/home` | CLI credentials live in `$OPTIMAI_HOME/.optimai` |
| `DATA_DIR` | internal | `/data/data` | `state.json`, `unauth_counts.json`, `node.log` |
| `OPTIMAI_BIN` | internal | `optimai-cli` | CLI binary name/path (tests point it at the stub) |

## 5. Commands

| Command | Who | What it does |
|---|---|---|
| `/help` | admin | list all commands |
| `/status` | admin | running/stopped + uptime, desired state, auth, docker, crashes/backoff/breaker |
| `/start_node` | admin | start the node (errors honestly on Railway) — closes the circuit breaker |
| `/stop_node` | admin | **persistent** stop: stays stopped after reboot until `/start_node` |
| `/restart_node` | admin | stop + start; also closes the circuit breaker |
| `/rewards` | admin | OptimAI rewards balance (raw CLI output) |
| `/logs` | admin | last 40 lines of `node.log` |
| `/watch [seconds]` | admin | LIVE tail of `node.log` for 10-600 s (default 120) |
| `/login` | admin | OptimAI login: open URL → sign in → paste redirect URL back |
| `/auth_status` | admin | CLI auth status text |
| `/me` | admin | your Telegram ID + name, admin yes/no |
| `/cancel` | admin | cancel a pending `/login` session |
| `/id` | **anyone** | your numeric Telegram ID (unauthorized users' `/id` also counts toward their promo budget) |

## 6. How the 24/7 guarantee works

Three stacked layers:

1. **Docker restart policy** — `restart: unless-stopped` restarts the whole container after crashes,
host reboots, and daemon restarts (on Railway: the `ON_FAILURE` policy in `railway.json`).
2. **Supervisor** — a 5 s watch loop tracks the `optimai-cli node start` process. If it dies while
the desired state is `running`, the bot instantly alerts you with the last 15 log lines and restarts
with exponential backoff: **5s → 15s → 60s → 300s**.
3. **Circuit breaker** — after **5 consecutive crashes**, auto-restart STOPS and you get ONE alert
("Fix the issue, then send /restart_node"). This prevents infinite crash-loop noise.

The desired state lives in `data/state.json` (atomic writes), so memory of "running" vs "stopped"
survives container restarts **and VPS reboots**:

- A node you stopped **stays stopped** after a reboot — by design, so an unwanted earning process
never silently resurrects.
- A running node **auto-resumes** on boot (when authenticated and `NODE_AUTO_START=true`).

## 7. Hosting-provider mode (promo funnel)

Unauthorized strangers who message the bot get:

```
⛔️ You are not authorized to use this bot.

To host your own OptimAI node server (paid), contact @mkr_infinity.
```

Configured by `CONTACT_USERNAME`, an optional full-text `UNAUTHORIZED_MESSAGE` override
(`{contact}` placeholder supported), and `UNAUTH_MAX_MESSAGES`.

**Anti-spam guarantee:** each stranger has a total reply budget (default **3 ever**), persisted in
`data/unauth_counts.json` across restarts. After their 3 replies they are muted **forever** until
you delete the file. `0` = fully silent mode. Even a stranger's `/id` counts toward their budget.

## 8. Railway appendix (Deployment B — bot control-plane only)

**Honest reality check.** Railway containers get **no `/var/run/docker.sock`** and no privileged mode.
`optimai-cli node start` launches workload containers through the host Docker daemon — that's exactly
what cannot exist on Railway (Docker-in-Docker needs privileged mode and is a non-goal here). So:

| On Railway | Works? |
|---|---|
| `/login`, `/auth_status`, `/rewards`, `/logs`, `/status`, `/help`, `/me`, `/cancel`, `/id` | ✅ yes |
| Promo gatekeeping, boot message, 24/7 keep-alive (Railway ON_FAILURE policy + supervisor) | ✅ yes |
| `/start_node`, `/stop_node`, `/restart_node`, `/watch` | ❌ **fails by design** — the bot returns the honest error: "no Docker daemon here" |

The bot self-detects the missing daemon at startup and in `/status` (`docker version` against the
absent socket) and warns openly instead of failing mysteriously. **The warning IS the feature.**

**Deploy steps:**

1. Push/connect the repo to Railway (GitHub) — or **no-git path**:
   ```bash
   npm i -g @railway/cli
   railway login
   railway init
   railway up
   ```
   (CLI uploads the local directory; nothing is pushed to git.)
2. Variables tab (dashboard): `TELEGRAM_BOT_TOKEN`, `TELEGRAM_ALLOWED_IDS`, `NODE_AUTO_START=true`,
`TZ=Asia/Kolkata` (optionally `ENABLE_HEALTH_PORT` if you need a web service + healthcheck).
3. **Create a Volume** mounted at `/data` and attach it to the service — without it, login + state
are wiped on every deploy.
4. Use the **Procfile**: deploy as a *Worker* service (`worker: python -m bot.main`) — long polling is
outbound-only, no public port needed. (Web service also works if you set `ENABLE_HEALTH_PORT`.)

**Cost:** Railway is usage-based — a small always-on worker is typically **~USD 10-20/month**, and it
can't even run the node. A flat **~EUR 4-6/month VPS** runs bot AND node. → **Railway is for testing
the bot or separating the control-plane; the VPS is the real solution.**

## 9. Troubleshooting

| Symptom | Fix |
|---|---|
| `/node status` shows `Error: Not authenticated` / bot says auth no | send `/login`, redo the paste flow |
| `docker compose logs` shows Docker permission denied | the socket mount needs the container to be root (default) — if you set `user:`, add the host `docker` group GID instead |
| Bot completely silent | check token + allowed IDs in `.env`; run `docker compose logs -f` |
| Commands sent while bot was down do nothing | by design: `drop_pending_updates=True` discards stale messages during downtime |
| Railway `/status` warns "Docker daemon not reachable" | **expected** — control-plane only, see appendix 8 |
| Node crash-loops | the bot pauses after 5 crashes; read the crash alert tail, fix root cause (RAM? disk?), then `/restart_node` |
| After reboot node did NOT come back | check `state.json` desired state and `NODE_AUTO_START`; if you stopped it manually it stays stopped by design |

## 10. Growth ideas

- **Multi-node fleet** — one bot supervising several nodes/regions with per-owner billing IDs
- **Metrics dashboard** — uptime/balance history charts per client (the `/status` snapshot already
has the data)
- **Auto-claim rewards** — scheduled `rewards balance` scraping with balance-change alerts
- **Client billing** — per-client Telegram IDs + automated monthly rental invoices (UPI:
`mkr-infinity@ybl`)
- **Referral funnel** — the promo reply could carry a tracking link and reply with a trial discount

## 11. Security notes

- **Never commit `.env`** — it's gitignored; the token is a live credential.
- **Rotate the token** if it leaks: @BotFather → `/revoke` → update `.env` → restart.
- **Keep `TELEGRAM_ALLOWED_IDS` minimal** — every ID in it can stop/start your earning node.
- The bot only makes **outbound** connections (Telegram long-polling) — no inbound ports need
opening; the VPS firewall can stay strict.
- State lives on the `./data` volume — treat it like credentials (the login session is in there).
- Nothing is ever pushed to a remote by this repo's workflow; `git remote -v` is empty by design.

---

### Attribution

**OptimAI Telegram Node v1.0.0** — built by **Mohammad Kaif Raja (mkr-infinity)**
[Telegram @mkr_infinity](https://t.me/mkr_infinity) · [Support](https://buymeacoffee.com/mkr_infinity) ·
UPI `mkr-infinity@ybl`. Unauthorized modification, redistribution, or commercial sale is prohibited
without prior written permission. Personal use permitted.
