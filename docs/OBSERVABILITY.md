# Observability and Telemetry Guide

The OptimAI Telegram Node provides multiple observability layers to ensure operators
have 24/7 visibility into node execution, process health, and crash states.

---

## 1. Subsystem Inspection Commands

Operators can query live telemetry directly from Telegram:

- `/status`: Comprehensive node overview, desired state, consecutive crashes, and auth status.
- `/uptime`: Precise uptime duration, desired run state, and cumulative crash count.
- `/disk`: Host storage utilization for the persistent data volume (`data/`).
- `/system`: Runtime execution environment (Python version, OS architecture, process ID).
- `/healthcheck`: Status verification across Supervisor, Gatekeeper, and storage filesystem.
- `/logs`: Fast inspection of the latest node output.
- `/watch [seconds]`: Real-time log streaming window (10 to 600 seconds).

---

## 2. Optional HTTP Health Port

When `ENABLE_HEALTH_PORT` is configured (e.g. `ENABLE_HEALTH_PORT=8080`), an internal HTTP
microserver exposes:

- `GET /health`: Returns HTTP 200 with JSON payload `{"status": "ok"}` when healthy.
- Returns HTTP 503 with `{"status": "circuit_breaker_open"}` if the node is crash-looping.

---

## 3. Host CLI Utilities

Diagnostic scripts in `scripts/`:

- `scripts/check-health.py`: Inspects `data/state.json` without requiring Telegram interaction.
- `scripts/tail-errors.sh`: Greps error patterns from `data/node.log`.
- `scripts/system-info.sh`: Hardware, RAM, and Docker container summaries.
