# FAQ — OptimAI Telegram Node

**Q: I stopped the node and restarted the VPS — why is it still stopped?**
A: By design. `/stop_node` writes `"desired":"stopped"` to `data/state.json`
BEFORE killing the process, so a reboot never resurrects a node you killed.
Send `/start_node` to resume.

**Q: The bot says "Docker daemon not reachable" — is it broken?**
A: It is honest, not broken. That environment has no docker.sock (Railway).
Node workloads cannot run there; the bot tells you instead of failing
mysteriously. Run the node on the VPS (README, Deployment A).

**Q: Why does `/login` open a URL and then want me to paste something back?**
A: Headless servers have no browser. The CLI prints a login URL
(`auth login --no-open --paste`), you sign in on ANY device, and the final
redirect URL is pasted back — the bot feeds it into the CLI for you.

**Q: A stranger messaged my bot and got an ad — can they keep spamming?**
A: No. Each unauthorized account gets `UNAUTH_MAX_MESSAGES` replies EVER
(default 3, clamped 0-10), persisted in `unauth_counts.json`. After that they
are muted across restarts until you delete the file. Strangers' `/id` usage
also burns budget.

**Q: What happens if the node crashes at 3 AM?**
A: The supervisor detects it within ~5 s, DMs you the last 15 log lines, and
restarts with backoff 5s → 15s → 60s → 300s. Five consecutive crashes open the
circuit breaker (one alert, auto-restart stops) — fix the cause, then send
/restart_node.

**Q: How do I update the optimai CLI?**
A: The bot surfaces the upstream "Important OptimAI CLI update available"
warning in /status. Reinstall the CLI on the VPS host per the upstream README
(the binary is a bootstrap; the core is under /data/home/.optimai).

**Q: Is the Telegram inbox-port open on the VPS?**
A: No inbound ports, ever. Telegram uses outbound long polling, so a default
firewall stays closed.

**Q: Where do my login credentials live?**
A: `$HOME/.optimai` inside the container = `./data/home/.optimai` on the host
volume. Rebuild the image freely; login survives. The volume is the only
thing you must not wipe.

**Q: Can two people use one bot?**
A: Yes — comma-separated IDs in `TELEGRAM_ALLOWED_IDS`. Every ID can
stop/start the earning node, so keep the list minimal.
