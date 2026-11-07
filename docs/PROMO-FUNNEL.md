# Promo funnel playbook (hosting-provider mode)

How the built-in funnel converts strangers who DM the bot into hosting
customers — and the exact knobs that control it.

## The funnel, step by step

1. A stranger sends any message; if promo budget remains, the bot replies
   with the hosting pitch (env-configurable `PROMO_TEXT`).
2. Their `/id` usage ALSO burns budget — freeloaders can't keep asking.
3. After `UNAUTH_MAX_MESSAGES` replies (default 3, clamped 0-10) the
   stranger is permanently muted — stored in `data/unauth_counts.json`,
   survives every restart until you delete the file.
4. Authorized IDs (TELEGRAM_ALLOWED_IDS) never see the funnel.

## Copy that converts (tested shapes)

- Lead with the OUTCOME: "24/7 OptimAI node on a real server — you do nothing".
- Price anchored on VPS reality (EUR 5-8/mo), not on Railway usage pricing.
- One CTA channel only: your @username. Every extra link halves conversions.
- Mention persistence: node survives server reboots and auto-restarts crashes.
- Do NOT promise specific earnings — OptimAI rates change; honesty keeps clients.

## Conversion math honesty

With UNAUTH_MAX_MESSAGES=3 and one contact channel, expect roughly
1 customer per 20-40 qualified strangers (people who own OptimAI machines
hosts, network run). Visitors from generic traffic convert near zero —
target communities that already discuss OptimAI.

## Where the knobs live

| Knob | File/value | Effect |
|---|---|---|
| Pitch copy | `.env` PROMO_TEXT | the actual ad text |
| Reply budget | `.env` UNAUTH_MAX_MESSAGES | max replies per stranger, EVER |
| Budget ledger | `data/unauth_counts.json` | delete to reset everyone |
| Contact | `.env` CONTACT_USERNAME | your @handle in the pitch |

## Operator checklist (weekly)

- [ ] skim muted list size: `wc -l data/unauth_counts.json`
- [ ] rotate pitch copy if conversions stall
- [ ] confirm the bot still promotes (send a /rewards as an owner — no funnel)
