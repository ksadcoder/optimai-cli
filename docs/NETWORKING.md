# Networking model

## Traffic direction

| Flow | Direction | Destination |
|---|---|---|
| Telegram long polling (PTB run_polling) | OUTBOUND | Telegram DCs (149.154.167.200/27 range) |
| optimai CLI → node.works API | OUTBOUND | api host |
| Docker client → docker.sock | local unix socket | /var/run/docker.sock |
| health port (optional) | INBOUND but loopback-only sitcom | ENABLE_HEALTH_PORT value |

## Firewall guidance

Default answer: NO inbound ports. A fully closed firewall (ufw deny incoming)
works. The optional health port only matters for KPI scrapers on the same
machine (Railway keeps the worker private by default).

## Socket permission model

The compose mount exposes the HOST docker socket inside the container (default
user root inside the image). Tightening:

- create a docker group on the host and `user:` the container to it
- or run rootless docker (upstream CLI must run as that user too)

## No proxy caveats

If the VPS routes through VPN/proxy: keep the connection always-on; the bot
survives reconnects (long polling retries) but login sessions may drop mid-flow.
