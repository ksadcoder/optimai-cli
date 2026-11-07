# Hardware & bare-metal requirements

## Official OptimAI CLI runtime (upstream, v0.1.63)

| Resource | Minimum | Recommended |
|---|---|---|
| CPU | 2 cores | 4 cores |
| RAM | 4 GB | 8 GB |
| Disk | 15 GB free | 30 GB |
| OS | Ubuntu 22.04+ | Ubuntu 24.04 LTS |
| Network | active internet | stable low-latency |

## Recommendation for THIS bot's VPS (Deployment A)

The VPS hosts BOTH the bot (trivial: a tiny Python loop) and the CLI node
workload via Docker. Realistic sweet spot:

- **2 vCPU / 4 GB RAM / 30-40 GB NVMe** box in the EUR 5-8/mo range
- 2 GB swap REQUIRED on 4 GB machines (setup-vps.sh creates it)
- Avoid burst-credit boxes for 24/7 mining workloads

## What the bot itself consumes (measured shapes)

- python + PTB event loop: idle ~60-120 MB RSS
- one spawned `optimai-cli node start` process + the Docker workload it manages
- node.log growth: ~ 10 MB rotation point (auto-rotates to .1)

## Railway reality-check

Railway containers DO NOT run the workload at all (no docker.sock), so its
spec discussions are control-plane-only (README Deploy B): spacing tiny,
worker memory < 512 MB, cost ~USD 10-20/mo — versus a VPS that actually earns.
