#!/usr/bin/env bash
# ============================================================
# optimai-telegram-node — one-shot VPS preparation (Ubuntu 22.04/24.04)
# Run as root:  bash setup-vps.sh
# Idempotent: safe to re-run.
# Docker source: the official convenience script (get.docker.com), which
#   installs the engine AND the compose plugin.
# ============================================================

set -u

C_GREEN='\033[1;32m'; C_YELLOW='\033[1;33m'; C_CYAN='\033[1;36m'; C_RED='\033[1;31m'; C_OFF='\033[0m'
step() { printf "${C_CYAN}==>${C_OFF} ${C_GREEN}%s${C_OFF}\n" "$*"; }
warn() { printf "${C_YELLOW}[skip]${C_OFF} %s\n" "$*"; }

if [ "$(id -u)" -ne 0 ]; then
  printf "${C_RED}ERROR:${C_OFF} run as root: ssh into the VPS, then 'sudo bash setup-vps.sh'\n"
  exit 1
fi

# 1) System update -----------------------------------------------------------
step "1/4 Updating apt packages"
apt-get update -y && apt-get upgrade -y

# 2) Docker Engine + compose plugin -----------------------------------------
step "2/4 Installing Docker Engine + compose plugin (official get.docker.com)"
if command -v docker >/dev/null 2>&1; then
  warn "docker already installed: $(docker --version)"
else
  curl -fsSL https://get.docker.com -o /tmp/get-docker.sh && sh /tmp/get-docker.sh
fi
if ! docker compose version >/dev/null 2>&1; then
  step "Compose plugin missing; installing via apt"
  apt-get install -y docker-compose-plugin
fi

# 3) Enable docker on boot ---------------------------------------------------
step "3/4 Enabling docker service (systemctl enable --now docker)"
systemctl enable --now docker

# 4) 2G swap (small VPS nodes need it for the Docker workload) ---------------
step "4/4 Checking swap (target >= 2G)"
swap_mb() { awk '/SwapTotal/ {printf "%d", $2/1024}' /proc/meminfo; }
if [ "$(swap_mb)" -lt 2048 ]; then
  if [ -f /swapfile ]; then
    if ! swapon --show --noheadings | grep -q '^/swapfile'; then
      chmod 600 /swapfile; mkswap /swapfile >/dev/null; swapon /swapfile
    fi
  else
    step "Creating 2G swapfile"
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile >/dev/null
    swapon /swapfile
  fi
  if ! grep -q '^/swapfile ' /etc/fstab; then
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
  fi
  sysctl -w vm.swappiness=10 >/dev/null
  echo "vm.swappiness=10" > /etc/sysctl.d/99-swappiness.conf
  printf "${C_GREEN}Swap ready:${C_OFF} $(swap_mb) MB total\n"
else
  warn "swap already $(swap_mb) MB (>= 2G) — nothing to do"
fi

printf "\n${C_GREEN}VPS preparation done.${C_OFF} Next steps:\n"
printf "  cd optimai-cli\n"
printf "  cp .env.example .env && nano .env      ${C_YELLOW}# fill the 2 REQUIRED values${C_OFF}\n"
printf "  docker compose up -d --build\n"
printf "  docker compose logs -f                 ${C_YELLOW}# expect the boot banner${C_OFF}\n"
