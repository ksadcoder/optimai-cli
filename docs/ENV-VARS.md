# Environment Variables Reference

Complete catalog of all environment configuration variables used by `optimai-cli` (OptimAI Telegram Node).

## 1. Required Variables

| Variable | Type | Example | Description |
|---|---|---|---|
| `TELEGRAM_BOT_TOKEN` | string | `123456789:ABCdef...` | Telegram Bot token created via [@BotFather](https://t.me/BotFather). Live secret; never commit. |
| `TELEGRAM_ALLOWED_IDS` | comma-separated integers | `6602332612,778899001` | Telegram user IDs granted admin command access. Obtain yours by messaging the bot `/id`. |

## 2. Supervisor & Node Behavior

| Variable | Type | Default | Description |
|---|---|---|---|
| `NODE_AUTO_START` | boolean (`true`/`false`) | `true` | When true, attempts to start the node automatically upon container startup if not stopped manually. |
| `LOG_TAIL_LINES` | integer | `40` | Default number of log lines returned by `/logs`. |
| `WATCH_SECONDS` | integer | `120` | Default live watch duration for `/watch` (clamped between 10 and 600s). |
| `LOGIN_TTL_MINUTES` | integer | `15` | Expiration time for pending interactive `/login` OAuth code sessions. |
| `ENABLE_HEALTH_PORT` | integer / empty | `""` (disabled) | TCP port for HTTP health checks (e.g. `8080`). Valid range: 1–65535. |

## 3. Hosting Provider & Promo Funnel

| Variable | Type | Default | Description |
|---|---|---|---|
| `CONTACT_USERNAME` | string | `mkr_infinity` | Telegram handle displayed to unauthorized users for hosting inquiries. |
| `UNAUTHORIZED_MESSAGE` | template string | *(built-in promo)* | Custom text sent to unauthorized users. Supports `{contact}` placeholder. |
| `UNAUTH_MAX_MESSAGES` | integer | `3` | Maximum replies an unauthorized stranger receives before being permanently muted (0–10). |

## 4. Internal Paths & Binary Overrides

| Variable | Type | Default | Description |
|---|---|---|---|
| `OPTIMAI_HOME` | directory path | `/data/home` | Path mounted to persistent volume where OptimAI stores auth tokens and caches. |
| `DATA_DIR` | directory path | `/data/data` | Path storing supervisor `state.json` and gatekeeper `unauth_counts.json`. |
| `OPTIMAI_BIN` | string | `optimai-cli` | Executable path for the OptimAI binary. In test harnesses, pointed to stub script. |
