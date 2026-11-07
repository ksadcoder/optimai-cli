# Hosting packages (what you sell as a provider)

Reference sheet for running clients on the same bot stack. Pairs with
docs/PROMO-FUNNEL.md (acquisition) and docs/COSTS.md (your margins).

## Package lineup (copy-adapt freely)

| Package | Hardware | Monthly (you charge) | Your cost | Margin |
|---|---|---|---|---|
| Basic node | 2 vCPU / 4 GB VPS | EUR 15 | 5-8 | ~2x |
| Dedicated box | 4 vCPU / 8 GB VPS | EUR 30 | 10-14 | ~2x |
| BYO server setup | client's own VPS | EUR 10 setup | 0 | one-time |

Rules of thumb:
- Rainy-day rule: charge >= 2x your raw VPS cost so a failed month on
  support doesn't lose money.
- Never undercharge basic: each client = Telegram support + updates + DR.

## Per-client operations

- One hardened VPS per client is the clean pattern (docs/COSTS.md).
  Shared multi-client boxes mix logs, state and blame allocation.
- Each deployment = its own bot token + its own TELEGRAM_ALLOWED_IDS
  containing YOUR id and (optionally) the client's.
- Keep a private spreadsheet: client → VPS IP → expiry date → bot username.

## Boundaries to state up front (in writing)

- You operate the node; you do NOT need the client's OptimAI password
  (paste-login flow only needs the session, see docs/FAQ.md).
- Client gets read-only visibility (their Telegram ID in ALLOWED_IDS),
  you keep the restart authority.
- Cancellation = client keeps the VPS (their login is on their volume);
  recurring access ends.

## What NOT to promise

- Uptime guarantees beyond "best effort, auto-restart on crash".
- Specific OptimAI rewards (upstream rates change without notice).
