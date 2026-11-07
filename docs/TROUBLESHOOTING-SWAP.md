# Swap Space and OOM Killer Mitigation

Low-spec VPS instances (1 GB to 2 GB RAM) may trigger Linux Out-Of-Memory (OOM) kills
if Docker builds or node processes consume spike memory.

---

## 1. Verifying Swap

```bash
swapon --show
free -h
```

If swap is 0B or missing, configure a 2GB swapfile:

```bash
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

---

## 2. Tuning Swappiness

Recommended swappiness for persistent node hosting:

```bash
sudo sysctl vm.swappiness=10
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
```
