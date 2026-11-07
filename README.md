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

## 3. Quickstart — VPS Setup

Deploy to Ubuntu 22.04+ in under 5 minutes:

1. **Clone repository to VPS**:
   ```bash
   git clone https://github.com/mkr-infinity/optimai-cli.git && cd optimai-cli
   ```
2. **Run host provisioning**:
   ```bash
   bash setup-vps.sh
   ```
   *(Installs Docker, configures 2GB swap, sets up data directory permissions)*
3. **Configure environment**:
   ```bash
   cp .env.example .env
   # Set TELEGRAM_BOT_TOKEN and TELEGRAM_ALLOWED_IDS
   ```
4. **Launch container**:
   ```bash
   docker compose up -d --build
   ```
5. **Verify**:
   Send `/status` to your bot in Telegram to verify the node is running.

> 📖 **Full Guide**: See [docs/DEPLOY-VPS.md](docs/DEPLOY-VPS.md) for step-by-step VPS walkthroughs and [docs/DEPLOY-RAILWAY.md](docs/DEPLOY-RAILWAY.md) for Railway control-plane deployment.

## 4. Configuration

The bot is configured via `.env`. Key variables:

| Variable | Required | Default | Purpose |
|---|---|---|---|
| `TELEGRAM_BOT_TOKEN` | Yes | — | Bot token from [@BotFather](https://t.me/BotFather) |
| `TELEGRAM_ALLOWED_IDS` | Yes | — | Comma-separated admin Telegram user IDs |
| `ENABLE_HEALTH_PORT` | No | `""` | TCP port for HTTP health checks (e.g. `8080`) |
| `NODE_AUTO_START` | No | `true` | Auto-start node process on boot |

For the complete dictionary of all options (timeouts, promo limits, paths), see **[docs/ENV-VARS.md](docs/ENV-VARS.md)**.

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
| `/version` | admin | bot + CLI versions |
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

Quick diagnostics for everyday operational incidents:

- **Authentication lost**: Run `/login` to paste a fresh login session.
- **Bot unresponsive**: Verify `TELEGRAM_BOT_TOKEN` in `.env` and inspect `docker compose logs -f`.
- **Node crash-looping**: The supervisor opens the circuit breaker after 5 consecutive crashes. Inspect the tail via `/logs`, fix the root cause, and run `/restart_node`.
- **Docker socket permission**: Ensure the socket `/var/run/docker.sock` is mounted and readable.
- **CLI update notice**: When `/status` reports an upstream update, update the binary on the host VPS.

> 📖 **Deep Dive**: For comprehensive triage and operational recovery steps, see [docs/RUNBOOK.md](docs/RUNBOOK.md) and [docs/ERROR-CATALOG.md](docs/ERROR-CATALOG.md).

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
- All code changes pass automated smoke suites and pair co-author verification before merge.


## 12. Documentation Index

The `docs/` directory contains deep-dive references for operators and architects:

| Document | Focus |
|---|---|
| [ARCHITECTURE.md](docs/ARCHITECTURE.md) | Component diagrams, lifecycle, IPC and process isolation |
| [MAINTENANCE.md](docs/MAINTENANCE.md) | Routine maintenance, volume pruning, and troubleshooting runbook |
| [DAILY-OPS.md](docs/DAILY-OPS.md) | Daily health verification and status monitoring checklist |
| [PERFORMANCE.md](docs/PERFORMANCE.md) | CPU/RAM footprints, swap configuration, and VPS sizing |
| [MULTI-OWNER.md](docs/MULTI-OWNER.md) | Architecture design for multi-tenant and multi-node hosting |
| [HOSTING-PACKAGES.md](docs/HOSTING-PACKAGES.md) | Commercial packaging and pricing model for VPS node hosting |
| [PROMO-FUNNEL.md](docs/PROMO-FUNNEL.md) | Mechanics of the unauth rate limiter and conversion funnel |
| [MIGRATION.md](docs/MIGRATION.md) | Step-by-step checklist for migrating from Railway to VPS |
| [RELEASE-POLICY.md](docs/RELEASE-POLICY.md) | Semantic versioning, tagging conventions, and deprecation policy |
| [DISASTER-RECOVERY.md](docs/DISASTER-RECOVERY.md) | Backup, recovery, host replacement, and credential restore |
| [THREAT-MODEL.md](docs/THREAT-MODEL.md) | Threat vectors, trust boundaries, and credential safeguards |
| [COSTS.md](docs/COSTS.md) | Detailed cost-benefit breakdown across VPS providers |
| [SSH-PRACTICES.md](docs/SSH-PRACTICES.md) | Hardening SSH access for non-root production hosts |
| [GLOSSARY.md](docs/GLOSSARY.md) | Definitions of terminology across OptimAI and the bot |
| [FAQ.md](docs/FAQ.md) | Frequently asked operator questions and answers |
| [RUNBOOK.md](docs/RUNBOOK.md) | Incident triage scenarios for crash loops and socket issues |
| [METRICS.md](docs/METRICS.md) | TCP health check endpoints and supervisor metrics dictionary |
| [BACKUP-RESTORE.md](docs/BACKUP-RESTORE.md) | Automated daily cron backup and restore procedure |
| [ENV-VARS.md](docs/ENV-VARS.md) | Complete catalog of environment variables and defaults |
| [UPGRADING.md](docs/UPGRADING.md) | Zero data-loss upgrade runbook and rollback steps |
| [OBSERVABILITY.md](docs/OBSERVABILITY.md) | Telemetry, logging, and health port reference |
| [SYSTEMD.md](docs/SYSTEMD.md) | Alternative systemd native service deployment |
| [STORAGE.md](docs/STORAGE.md) | Volume persistence and filesystem state specs |
| [SECURITY-CHECKLIST.md](docs/SECURITY-CHECKLIST.md) | Production security hardening checklist |
| [API.md](docs/API.md) | Internal HTTP healthcheck endpoint specs |
| [COMPARISON.md](docs/COMPARISON.md) | Comparison matrix against tmux and systemd deployments |
| [TESTING.md](docs/TESTING.md) | Test harness design and smoke test execution guide |


---

### Attribution

**OptimAI Telegram Node v1.0.0** — built by **Mohammad Kaif Raja (mkr-infinity)**
[Telegram @mkr_infinity](https://t.me/mkr_infinity) · [Support](https://buymeacoffee.com/mkr_infinity) ·
UPI `mkr-infinity@ybl`. Unauthorized modification, redistribution, or commercial sale is prohibited
without prior written permission. Personal use permitted.
