# Docker Resource Limits Reference

Prevent memory exhaustion by capping container limits in `docker-compose.yml`:

```yaml
services:
  bot:
    deploy:
      resources:
        limits:
          cpus: '1.5'
          memory: 1024M
        reservations:
          cpus: '0.2'
          memory: 256M
```
