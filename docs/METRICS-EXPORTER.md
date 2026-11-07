# Prometheus Metrics Scraping Guide

Configure Prometheus to scrape the internal HTTP health endpoint:

```yaml
scrape_configs:
  - job_name: optimai_bot
    metrics_path: /health
    static_configs:
      - targets: ['localhost:8080']
```
