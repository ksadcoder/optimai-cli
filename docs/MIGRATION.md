# Migration checklist: Railway → VPS (moving the bot to earn)

You ran the bot on Railway (Deployment B) and now have a real VPS.
Move correctly in one session — ~30 minutes.

## Before touching Railway

- [ ] `/login` state lives on Railway's volume — you must /login again on
      the VPS later (session files are not portable between mounts);
      nothing else needs carrying.
- [ ] Copy `.env` values somewhere private (bot token, ALLOWED_IDS, funnel knobs).

## On the VPS

1. Ship + prepare per README Deployment A (or docs/DEPLOY-VPS.md).
2. `cp .env.example .env` → paste your values → `docker compose up -d`.
3. Bootstrap or reuse IDs: `/id` → fill TELEGRAM_ALLOWED_IDS → `up -d` again.
4. `/login` → paste redirect → "Login successful".
5. `/start_node` → `/status` shows: Node running | Auth yes | Docker ok.

## Cutover

- [ ] VPS node confirmed running for at least an hour (crash would appear in DM alert).
- [ ] Railway: `railway down` (or delete project) — the SAME bot token CANNOT
      be polled by two processes: if both run, Telegram gives one of them
      409s and commands land unpredictably. Env says: never run two bots
      on one token.

## After cutover

- [ ] First crash drill: `/stop_node` && `/start_node` — check alert wiring.
- [ ] Enable swap + SSH hardening if not done (docs/SSH-PRACTICES.md).
- [ ] Set `data/` backup tarball on a weekly reminder (docs/DISASTER-RECOVERY.md).
