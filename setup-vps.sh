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

# Optional host optimai-cli binary (container has its own copy)
if command -v optimai-cli >/dev/null 2>&1; then
  warn "optimai-cli already installed: $(optimai-cli --version 2>/dev/null || echo 'present')"
else
  curl -fsSL https://cli-node.optimai.network/optimai_cli_ubuntu -o /usr/local/bin/optimai-cli && chmod +x /usr/local/bin/optimai-cli || warn "optimai-cli host download skipped (image bundles it)"
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

printf "\n${C_GREEN}VPS preparation done.${C_OFF} Preflight checks:\n"
problems=0

if systemctl is-active --quiet docker; then
  printf "  ${C_GREEN}[ok]${C_OFF} docker service is active\n"
else
  printf "  ${C_RED}[!!]${C_OFF} docker service NOT active -> run: systemctl start docker\n"
  problems=$((problems + 1))
fi

if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  printf "  ${C_GREEN}[ok]${C_OFF} compose plugin present: %s\n" "$(docker compose version --short 2>/dev/null)"
else
  printf "  ${C_RED}[!!]${C_OFF} compose plugin MISSING -> docker compose up will fail\n"
  problems=$((problems + 1))
fi

if [ -S /var/run/docker.sock ]; then
  printf "  ${C_GREEN}[ok]${C_OFF} docker socket present (mounted into the container at runtime)\n"
else
  printf "  ${C_YELLOW}[??]${C_OFF} docker socket not found now — if 'docker: not reachable' shows in the bot, check the socket mount in docker-compose.yml\n"
fi

if [ "$(swap_mb)" -ge 2048 ]; then
  printf "  ${C_GREEN}[ok]${C_OFF} swap: %s MB, swappiness=%s\n" "$(swap_mb)" "$(cat /proc/sys/vm/swappiness)"
else
  printf "  ${C_RED}[!!]${C_OFF} swap below 2G (got %s MB) -> re-run this script\n" "$(swap_mb)"
  problems=$((problems + 1))
fi

if [ "$problems" -eq 0 ]; then
  printf "${C_GREEN}All preflight checks passed.${C_OFF} Next steps:\n"
else
  printf "${C_RED}%s check(s) failed${C_OFF}. Fix above, then continue. Next steps:\n" "$problems"
fi
printf "  cd optimai-cli\n"
printf "  cp .env.example .env && nano .env      ${C_YELLOW}# fill the 2 REQUIRED values${C_OFF}\n"
printf "  docker compose up -d --build\n"
printf "  docker compose logs -f                 ${C_YELLOW}# expect the boot banner${C_OFF}\n"
