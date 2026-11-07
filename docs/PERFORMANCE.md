# Performance & Resource Benchmarks

This document details the resource utilization, memory limits, and performance characteristics of `optimai-cli` running on Linux host environments.

## Component Resource Footprint

Measurements taken under steady-state operation on Ubuntu 24.04 LTS (x86_64, 1 vCPU, 2 GB RAM):

| Component | Resident Memory (RSS) | Idle CPU | Active / Poll CPU | Disk Footprint |
|---|---|---|---|---|
| **Python Bot Container** (`optimai-bot`) | ~35 MB – 45 MB | < 0.2% | ~1.5% (polling CLI) | ~140 MB image |
| **OptimAI CLI Process** (`optimai-cli`) | ~55 MB – 70 MB | < 0.5% | ~2.0% (heartbeats) | ~45 MB binary |
| **Docker Workload Container** | Variable by task | ~1.0% | Dynamic | ~300 MB images |

## Recommended VPS Sizing

1. **Minimum Spec**:
   - 1 vCPU, 1 GB RAM, 10 GB SSD.
   - *Requirement*: A 1 GB swapfile must be configured to prevent out-of-memory (OOM) kills during Docker image pulls.
2. **Recommended Spec**:
   - 1-2 vCPU, 2 GB RAM, 20 GB SSD.
   - Comfortably hosts both the bot control-plane, the CLI node, and workload containers without paging.

## Memory Tuning & Swap Setup

For 1 GB VPS instances, set up a swapfile using:

```bash
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile none swap sw 0 0" >> /etc/fstab
```

## Docker Log Rotation

To prevent unconstrained container logs from filling your disk, configure log rotation in `docker-compose.yml` or `/etc/docker/daemon.json`:

```yaml
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```
