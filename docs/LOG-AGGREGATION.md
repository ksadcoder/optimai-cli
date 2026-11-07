# Centralized Log Aggregation Guide

Operators managing multiple OptimAI nodes can stream logs to Grafana Loki or Vector.

---

## Log Ingestion with Promtail

Add the following scrape configuration to `/etc/promtail/config.yml`:

```yaml
scrape_configs:
  - job_name: optimai-node
    static_configs:
      - targets: [localhost]
        labels:
          job: optimai
          host: vps-prod-1
          __path__: /opt/optimai-cli/data/node.log
```

---

## Key Log Filtering Patterns

- `Node started`: Service startup events
- `rewards`: Balance scrape updates
- `ERROR|CRITICAL`: Crash notifications and stack traces
