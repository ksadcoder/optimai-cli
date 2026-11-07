# Docker Daemon Log Rotation Tuning

Prevent JSON log files from consuming container disk space:

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "20m",
    "max-file": "3"
  }
}
```

Save to `/etc/docker/daemon.json` and reload:
```bash
sudo systemctl reload docker
```
