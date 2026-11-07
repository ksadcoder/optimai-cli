# Time Synchronization and NTP Guide

Telegram API request signatures and OAuth timestamps require synchronized clocks.

---

## Configuring systemd-timesyncd

```bash
sudo systemctl enable --now systemd-timesyncd
timedatectl set-ntp true
timedatectl status
```
