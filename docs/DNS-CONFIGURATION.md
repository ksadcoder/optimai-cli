# DNS Configuration and Resolver Tuning

Reliable DNS resolution is critical for continuous long-polling to Telegram.

---

## Recommended Resolvers

Add Cloudflare and Google public resolvers to `/etc/resolv.conf` or `systemd-resolved`:

```ini
nameserver 1.1.1.1
nameserver 8.8.8.8
```

## Testing Resolution Latency

Run the DNS latency tester:
```bash
bash scripts/check-dns.sh
```
