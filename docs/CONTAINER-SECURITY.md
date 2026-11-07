# Container Security and Socket Hardening

Securing the host Docker socket while providing full supervisor control is critical.

---

## Security Principles

1. **Docker Socket Proxy**: For ultra-hardened environments, use `tecnativa/docker-socket-proxy`
   to restrict allowed Docker API calls (allowing only container creation/listing).
2. **Minimal Image Footprint**: Python 3.12-slim base with pinned package versions.
3. **No Inbound Attack Surface**: Polling architecture eliminates open listening ports.
