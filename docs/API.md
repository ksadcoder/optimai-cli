# Internal HTTP Health API Reference

When `ENABLE_HEALTH_PORT` is specified in `.env`, the bot binds a lightweight HTTP endpoint
for uptime monitoring systems (such as UptimeRobot, Prometheus, or Docker HEALTHCHECK).

---

## Health Endpoint

`GET /health`

### Response 200 OK
Returned when supervisor is operational and circuit breaker is closed.

```json
{
  "status": "ok",
  "desired_state": "running",
  "consecutive_crashes": 0,
  "breaker_open": false
}
```

### Response 503 Service Unavailable
Returned when consecutive crash limit (5) has been exceeded and circuit breaker opened.

```json
{
  "status": "circuit_breaker_open",
  "consecutive_crashes": 5,
  "breaker_open": true
}
```
