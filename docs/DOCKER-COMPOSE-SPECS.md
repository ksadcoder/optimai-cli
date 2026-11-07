# Docker Compose Specification Reference

The `docker-compose.yml` orchestrates the bot container with host integration.

---

## Volume Mounts

- `./data:/data`: Persistent state directory.
- `/var/run/docker.sock:/var/run/docker.sock`: Socket for controlling node containers.

## Restart Policy

- `restart: unless-stopped`: Ensures automatic revival after host reboot.
