# VPS SSH best practices (before running setup-vps.sh)

1. **Key-only authentication:**
```bash
adduser ops --disabled-password  # then add your pubkey to ops
usermod -aG sudo,docker ops
# /etc/ssh/sshd_config: PasswordAuthentication no; PermitRootLogin no
systemctl restart ssh
```
2. **Fail2ban out of the box:** `apt install fail2ban` (default sshd jail is fine):
3. **ufw allow out, deny in (bot needs zero inbound):**
```bash
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp   # or the changed SSH port
ufw enable
```
4. Change SSH port away from 22 (security-through-minor-obscurity but it kills log spam).
5. Login as `ops` from here forward; `sudo` when needed. `docker` group gives socket access.
6. Verify: attempt `ssh root@VPS` afterwards — SHOULD FAIL.

## What NOT to do

- do not disable the firewall because the bot "isn't reachable": it's outbound-only, no port opening required
- do not add the docker group to outside users; it's host-root-equivalent power
