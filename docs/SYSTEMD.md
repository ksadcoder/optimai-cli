# Systemd Service Unit Guide

For operators preferring native Linux process supervision over Docker Compose, the bot
can run as a standard systemd unit.

---

## Service Unit Specification

Create `/etc/systemd/system/optimai-bot.service`:

```ini
[Unit]
Description=OptimAI Telegram Bot Controller
After=network.target docker.service
Wants=docker.service

[Service]
Type=simple
User=root
WorkingDirectory=/opt/optimai-cli
EnvironmentFile=/opt/optimai-cli/.env
ExecStart=/opt/optimai-cli/.venv/bin/python -m bot.main
Restart=always
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
```

---

## Activation

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now optimai-bot
sudo systemctl status optimai-bot
```

To view live service logs:
```bash
journalctl -u optimai-bot -f
```
