# Threat model & hardening checklist

## Assets

1. Telegram bot token (full bot control)
2. `$HOME/.optimai` OptimAI login (earning account)
3. Host docker.sock (full host container control)
4. data/state.json (desired state)

## Attackers & vectors

| Vector | Mitigation already in repo |
|---|---|
| leaked bot token (git, gist, screenshot) | .gitignore, SECURITY.md, /revoke guidance |
| stranger floods bot | promo budget (max 3 replies, persisted, restart survivor) |
| neighbor on host tries socket (multi-tenant VPS) | socket is root-owned; container isolation is standard, not privileged |
| command injection via /login paste | paste goes through `sendline` via pexpect ONLY into the CLI's stdin prompt; never into a shell |
| prompt-injection via node.log contents | logs are rendered inside html-escaped <pre> blocks |
| supply chain: hostile core-CLI update | pinned docker CLI ARG; remaining: upstream optimai CLI trust — flag in CREDITS |

## Hardening checklist (operator)

- [ ] restrict shell (key-only SSH, no password auth)
- [ ] keep `TELEGRAM_ALLOWED_IDS` minimal
- [ ] snapshot ./data (contains creds!) only to encrypted storage
