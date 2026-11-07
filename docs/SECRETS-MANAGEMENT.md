# Enterprise Secrets Management Guide

For production teams managing multiple node deployments:

- **Doppler**: Inject environment secrets dynamically: `doppler run -- docker compose up -d`.
- **HashiCorp Vault**: Read bot tokens via Vault Agent sidecar.
- **1Password CLI**: Inject secrets at runtime with `op run -- docker compose up -d`.
