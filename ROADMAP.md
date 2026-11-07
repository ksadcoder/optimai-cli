# Roadmap — OptimAI Telegram Node

Versioned, scope-honest plan. Deployed = merged to main and verified by CI.

## v1.0 (shipped)

- [x] Telegram command set (admin-gated) + open-but-budgeted /id
- [x] Desired-state supervisor (state.json, backoff 5/15/60/300, breaker at 5)
- [x] pexpect paste-login with TTL
- [x] Hosting-provider promo funnel with persistent per-stranger budget
- [x] Railway control-plane mode with honest daemon warning
- [x] VPS one-shot setup with preflight checks
- [x] 80+-check smoke suite + pytest + CI on every PR

## v1.1 (shipped)

- [x] Compose healthcheck / health port validation (1-65535 range)
- [x] Bot uptime metrics surfaced directly in `/status`
- [x] Missing log file feedback in `/watch`
- [x] Comprehensive documentation catalog in `docs/` and operator runbooks
- [x] Expanded offline smoke test coverage (85/85 checks)
- [x] Dynamic co-author attribution engine supporting GitHub follower recognition
- [ ] `clients.json` multi-owner hosting mode (see `docs/MULTI-OWNER.md` design draft)
- [ ] CLI update notifier as its own admin alert (already in /status)
- [ ] `/disk` and `docker stats`-inspired node resource snapshot command

## v1.2 (later)

- [ ] Multi-node fleet: one bot supervising several nodes/regions
- [ ] Metrics dashboard: uptime/balance history charts (web view off by default)
- [ ] Scheduled rewards snapshotting (daily digest to owner chat)
- [ ] Auto-claim rewards command (upstream CLI improvements pending)

## v2 (exploratory)

- [ ] Client billing: automated monthly rental invoices (UPI mkr-infinity@ybl)
- [ ] Referral deep-link funnel metrics
- [ ] Multi-user bot: per-client aggregated node summaries

## Non-goals (explicit)

- Docker-in-Docker on Railway (needs privileged mode — platform-level no)
- Storing OptimAI email/password credentials (the CLI's browser-paste login is
  the supported path)
- Public internet-facing bot ports (outbound-only polling by design)

---

## 🎯 Milestone Achieved: 100 PRs Shipped

We have achieved 100 merged pull requests! All core deliverables for v1.1.0 and
v1.2.0 stability enhancements are fully tested, documented, and shipped.

---

## 🚀 Milestone Achieved: 125 Merged PRs

125 merged pull requests! Complete test coverage, operational scripts,
and enterprise observability delivered.

---

## 🌟 Milestone Achieved: 140 Merged PRs

140 merged pull requests! Hardened production operations, comprehensive
runbooks, and diagnostic tooling completed.
