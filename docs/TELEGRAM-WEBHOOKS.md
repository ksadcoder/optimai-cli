# Architectural Rationale: Long-Polling vs Webhooks

The OptimAI Telegram bot uses outbound long-polling (`getUpdates`) by design.

---

## Why Long-Polling Beats Webhooks for Node Operators

1. **Zero Open Ports**: No public IP, DNS domain, or TLS certificate needed.
2. **NAT / Firewall Traversal**: Works seamlessly behind residential routers and CGNAT.
3. **Simplicity**: No reverse proxy (Nginx / Caddy) required.
4. **Security**: Immune to external inbound port scans or DDoS attacks.
