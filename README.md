<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=700&size=28&pause=1000&color=00D4FF&center=true&vCenter=true&width=700&lines=DFX+Cloud+Bot+%E2%9A%A1;Discord+VPS+Management+Bot;Powered+by+Docker+%F0%9F%90%B3;SSH+%7C+SSHx+%7C+Snapshots+%7C+Plans" alt="Typing SVG" />
</p>

<p align="center">
  <a href="https://github.com/CodeXOwnz/DFXBOT-V1">
    <img src="https://img.shields.io/badge/GitHub-DFXBOT--V1-181717?style=for-the-badge&logo=github&logoColor=white" />
  </a>
  <img src="https://img.shields.io/badge/Python-3.12-3776AB?style=for-the-badge&logo=python&logoColor=white" />
  <img src="https://img.shields.io/badge/Discord.py-Latest-5865F2?style=for-the-badge&logo=discord&logoColor=white" />
  <img src="https://img.shields.io/badge/Docker-Powered-2496ED?style=for-the-badge&logo=docker&logoColor=white" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Made%20by-DFX%20CLOUD%20TECHNOLOGIES-00D4FF?style=flat-square&logoColor=white" />
  &nbsp;
  <img src="https://img.shields.io/badge/Powered%20by-WarriorXwiN%20%28OG%20BEGAMING%29-FF6B35?style=flat-square" />
</p>

---

<p align="center">

```
██████╗ ███████╗██╗  ██╗     ██████╗██╗      ██████╗ ██╗   ██╗██████╗
██╔══██╗██╔════╝╚██╗██╔╝    ██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗
██║  ██║█████╗   ╚███╔╝     ██║     ██║     ██║   ██║██║   ██║██║  ██║
██║  ██║██╔══╝   ██╔██╗     ██║     ██║     ██║   ██║██║   ██║██║  ██║
██████╔╝██║     ██╔╝ ██╗    ╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝
╚═════╝ ╚═╝     ╚═╝  ╚═╝     ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝

         DISCORD VPS MANAGEMENT BOT  ·  DOCKER EDITION  ⚡
```

</p>

---

## 📖 About

**DFX Cloud Bot** is a powerful Discord bot that lets server admins and users **deploy, manage, and SSH into real Linux VPS containers** — all from inside Discord. No panel, no browser, just commands and buttons.

Every VPS is a real Docker container. Users get **tmate SSH**, **SSHx web terminal**, live **resource stats**, **snapshots**, **port forwarding**, and a full **coins/plans economy** — managed entirely through Discord.

> 🏢 **Made by:** DFX Cloud Technologies  
> ⚡ **Powered by:** WarriorXwiN (OG BEGAMING)  
> 🔗 **Source:** [github.com/CodeXOwnz/DFXBOT-V1](https://github.com/CodeXOwnz/DFXBOT-V1)

---

## ✨ Features

<table>
<tr><td>🐳 <b>Docker VPS</b></td><td>Each VPS is an isolated Docker container — no VM overhead, instant creation</td></tr>
<tr><td>🔐 <b>tmate SSH</b></td><td>One-click SSH via tmate relay — <code>ssh abc@sfo2.tmate.io</code></td></tr>
<tr><td>🌐 <b>SSHx Web Terminal</b></td><td>Browser-based terminal via sshx.io — no SSH client needed</td></tr>
<tr><td>🐧 <b>10 OS Images</b></td><td>Ubuntu 16.04–24.04 and Debian 8–12, all pre-baked with tmate</td></tr>
<tr><td>📦 <b>Snapshots</b></td><td>Save and restore container state as Docker images</td></tr>
<tr><td>🔌 <b>Port Forwarding</b></td><td>iptables DNAT rules to expose container ports to the internet</td></tr>
<tr><td>💰 <b>Economy System</b></td><td>Coins, daily rewards, work command, plan purchases</td></tr>
<tr><td>🎫 <b>Plans & Coupons</b></td><td>Free / Basic / Standard / Pro / Premium tiers + discount codes</td></tr>
<tr><td>📊 <b>Live Stats</b></td><td>Real-time CPU, RAM, network and disk I/O per container</td></tr>
<tr><td>🛡️ <b>Admin Tools</b></td><td>Full admin control: create, suspend, remove, info for any VPS</td></tr>
<tr><td>🔔 <b>Expiry Alerts</b></td><td>Auto-stop expired VPS + DM notification to owner</td></tr>
<tr><td>🤝 <b>VPS Sharing</b></td><td>Share VPS access with other Discord users</td></tr>
<tr><td>⚡ <b>Resource Monitor</b></td><td>Auto-suspend containers exceeding CPU/RAM thresholds</td></tr>
</table>

---

## 🐧 Supported OS Images

| Distro | Versions |
|--------|----------|
| **Ubuntu** | `16.04` · `18.04` · `20.04` · `22.04` · `24.04` |
| **Debian** | `8` (Jessie) · `9` (Stretch) · `10` (Buster) · `11` (Bullseye) · `12` (Bookworm) |

All images are pre-baked with **tmate** + **OpenSSH** at build time — SSH works instantly with no apt installs inside the container.

---

## 🚀 Installation

### Requirements

- Linux server (Ubuntu 20.04+ or Debian 11+ recommended)
- Root or sudo access
- A Discord Bot Token — [discord.com/developers](https://discord.com/developers/applications)
- Your Discord User ID (for admin access)

---

### ⚡ One-Line Install

```bash
bash <(curl -sSL https://raw.githubusercontent.com/CodeXOwnz/DFXBOT-V1/main/installer.sh)
```

---

### 📋 Step-by-Step Install

```bash
# 1. Download the installer
curl -O https://raw.githubusercontent.com/CodeXOwnz/DFXBOT-V1/main/installer.sh

# 2. Make it executable
chmod +x installer.sh

# 3. Run as root
sudo bash installer.sh
```

### What the Installer Does

```
Step 1 ─ Installs base dependencies (curl, wget, tar, iptables, etc.)
Step 2 ─ Installs Docker + Docker Compose (if not already present)
Step 3 ─ Downloads the latest bot package
Step 4 ─ Prompts for Bot Token + Admin ID → writes to .env
Step 5 ─ Builds the bot Docker image
Step 6 ─ Starts the bot container (docker compose up -d)
Step 7 ─ Builds all 10 VPS base images (Ubuntu + Debian with tmate)
Step 8 ─ Installs the global `dfxbot` CLI command
```

---

## ⚙️ dfxbot CLI Reference

The installer registers a global `dfxbot` command — use it from anywhere on the server:

```bash
dfxbot start          # Start the bot container
dfxbot stop           # Stop the bot container
dfxbot restart        # Restart the bot container
dfxbot status         # Show container status
dfxbot logs           # Stream live logs  (Ctrl+C to exit)
dfxbot update         # Download latest package & rebuild
dfxbot edit-env       # Edit .env with nano
dfxbot build-images   # (Re)build all Ubuntu/Debian VPS base images
dfxbot list-images    # Show which VPS base images are available
dfxbot uninstall      # Stop & remove the bot container
```

---

## 🛠️ Configuration

Edit your `.env` at any time:

```bash
dfxbot edit-env
# Then restart to apply:
dfxbot restart
```

| Variable | Description | Default |
|----------|-------------|---------|
| `DISCORD_TOKEN` | Your Discord bot token | **required** |
| `ADMIN_IDS` | Comma-separated admin user IDs | **required** |
| `BOT_NAME` | Bot display name | `DFX Cloud` |
| `HOST_NAME` | Company/host name shown in embeds | `DFX Cloud Technologies` |
| `POWERED_BY` | Footer credit line | `DFX Cloud Technologies` |
| `SERVER_IP` | Your server's public IP (for port forwards) | `127.0.0.1` |
| `LOG_CHANNEL_ID` | Discord channel ID for action logs | `0` (disabled) |
| `VPS_ROLE_ID` | Role assigned to VPS owners | `0` (disabled) |
| `BOT_PREFIX` | Command prefix | `1` |
| `CPU_THRESHOLD` | Auto-suspend at this CPU % | `90` |
| `RAM_THRESHOLD` | Auto-suspend at this RAM % | `90` |

---

## Important 
```echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -s 172.17.0.0/16 ! -o docker0 -j MASQUERADE
# Make permanent:
apt install iptables-persistent -y && netfilter-persistent save```

## 💬 Bot Commands

> Default prefix: **`1`** — configurable via `BOT_PREFIX` in `.env`

### 👤 User Commands

| Command | Description |
|---------|-------------|
| `1myvps` | List all your VPS containers |
| `1manage [vps#]` | Open the interactive VPS management panel |
| `1vpsinfo [vps#]` | Detailed specs and status |
| `1deploy` | Purchase & deploy a VPS using coins |
| `1renew [vps#]` | Renew your VPS subscription |
| `1snapshot [vps#] [name]` | Save a snapshot of your VPS |
| `1list-snapshots [vps#]` | List available snapshots |
| `1restore-snapshot [vps#] [name]` | Restore from a snapshot |
| `1ports list` | List your active port forwards |
| `1ports add <vps#> <host:container> [tcp\|udp]` | Add a port forward |
| `1ports remove <id>` | Remove a port forward |
| `1coins` | Check your coin balance |
| `1daily` | Claim daily coin reward |
| `1work` | Earn coins |
| `1plans` | View available VPS plans & pricing |
| `1help` | Full command list |

---

### 🖥️ Manage Panel Buttons

Running `1manage` opens a button panel in Discord:

```
Row 1:  🔐 SSH   ▶️ Start   ⏹️ Stop   🔄 Restart
Row 2:  📊 Stats  🔧 Reinstall  🖥️ Neofetch  🌐 SSHx
```

| Button | What it does |
|--------|-------------|
| 🔐 **SSH** | Installs tmate in the container and returns `ssh abc@sfo2.tmate.io` |
| 🌐 **SSHx** | Starts sshx.io session and returns a browser terminal URL |
| ▶️ **Start** | Start the container |
| ⏹️ **Stop** | Stop the container |
| 🔄 **Restart** | Restart the container |
| 📊 **Stats** | Live CPU · RAM · Network · Disk I/O embed |
| 🔧 **Reinstall** | Wipe and reinstall the OS (with confirmation) |
| 🖥️ **Neofetch** | System info printed to embed |

---

### 🔑 Admin Commands

| Command | Description |
|---------|-------------|
| `1admin-create @user <ram> <cpu> <disk> <os> [days]` | Create a VPS for any user |
| `1admin-remove <container_id>` | Permanently delete a VPS |
| `1admin-suspend <container_id> [reason]` | Suspend a VPS |
| `1admin-unsuspend <container_id>` | Unsuspend a VPS |
| `1admin-info <container_id>` | Full info + stats for any VPS |
| `1admin-list` | List all registered containers |
| `1admin-snapshot <container_id> [name]` | Snapshot any VPS |
| `1stop-vps-all` | Force-stop ALL running VPS containers |
| `1ports-add-user <amount> @user` | Give extra port forward slots |
| `1ports-remove-user <amount> @user` | Remove port slots |
| `1ports-revoke <forward_id>` | Force-revoke any port forward |
| `1add-coins @user <amount>` | Add coins to a user |
| `1remove-coins @user <amount>` | Remove coins from a user |
| `1coupon-create <code> <discount%>` | Create a coupon code |
| `1coupon-delete <code>` | Delete a coupon code |

---

## 💰 Plans & Pricing

| Plan | RAM | CPU | Disk | Duration | Cost |
|------|-----|-----|------|----------|------|
| 🆓 **Free** | 1 GB | 1 vCPU | 10 GB | 1 day | Free |
| 🚀 **Basic** | 2 GB | 2 vCPU | 20 GB | 7 days | 3,000 🪙 |
| 🌟 **Standard** | 2 GB | 2 vCPU | 20 GB | 7 days | 3,000 🪙 |
| 🔥 **Pro** | 4 GB | 4 vCPU | 40 GB | 7 days | 5,000 🪙 |
| 💎 **Premium** | 8 GB | 4 vCPU | 80 GB | 30 days | 10,000 🪙 |

**Resource Add-ons** (purchasable on top of any plan):

| Add-on | Bonus | Price |
|--------|-------|-------|
| 🧠 +4GB RAM | +4 GB RAM | 150 🪙 |
| ⚡ +2 CPU | +2 vCPU | 100 🪙 |
| 💾 +50GB Disk | +50 GB storage | 120 🪙 |
| 📦 Small Bundle | +4GB RAM · +2 CPU · +20GB | 300 🪙 |
| 📦 Large Bundle | +8GB RAM · +4 CPU · +50GB | 550 🪙 |

---

## 🏗️ Architecture

```
Discord Users
      │
      ▼
┌─────────────────────────────────────────────────┐
│         dfx-cloud-bot  (Docker container)       │
│         network_mode: host                      │
│         /var/run/docker.sock  ← host socket     │
└───────────────────┬─────────────────────────────┘
                    │  docker run / exec / inspect
                    ▼
         Docker Daemon (host machine)
                    │
       ┌────────────┼────────────┐
       ▼            ▼            ▼
  dfx-xxxx      dfx-yyyy     dfx-zzzz
  Ubuntu 22     Debian 12    Ubuntu 20
  172.17.0.2    172.17.0.3   172.17.0.4
  tmate SSH     SSHx          OpenSSH
```

**Key design decisions:**
- VPS containers run on Docker's **internal bridge** — no host ports exposed by default
- Bot uses `network_mode: host` to reach bridge IPs (e.g. `172.17.0.x`) directly
- Port forwarding is **opt-in** via `1ports add` using iptables DNAT rules
- SQLite DB + snapshots persisted via Docker volume mount (`./data`)

---

## 📦 Stack

| Layer | Technology |
|-------|-----------|
| Language | Python 3.12 |
| Discord Library | discord.py |
| Container Runtime | Docker (docker-out-of-docker via socket) |
| Database | SQLite (WAL mode) |
| SSH (primary) | tmate relay |
| SSH (fallback) | OpenSSH inside container |
| Web Terminal | sshx.io |
| Port Forwarding | iptables DNAT + MASQUERADE |
| Deployment | Docker Compose |

---

## 📁 File Structure

```
discord-bot/
├── bot.py                 ← Core: DB, Docker helpers, bot setup, background tasks
├── docker-compose.yml     ← Bot container definition
├── Dockerfile             ← Bot container image (Python 3.12 + Docker CLI)
├── Dockerfile.vps         ← VPS base image builder (Ubuntu/Debian + tmate)
├── requirements.txt       ← Python dependencies
├── .env.example           ← Configuration template
├── data/                  ← SQLite DB + snapshots (auto-created at runtime)
│   └── snapshots/
└── cogs/
    ├── vps_manage.py      ← Manage panel, myvps, snapshots, sharing
    ├── admin_vps.py       ← Admin commands
    ├── plans.py           ← Plan purchase & VPS deploy
    ├── ports.py           ← Port forwarding (iptables)
    ├── coins.py           ← Economy: coins, daily, work
    ├── admin_coins.py     ← Admin coin management
    ├── coupons.py         ← Coupon codes
    ├── monitoring.py      ← Resource monitor background task
    └── misc.py            ← Help and miscellaneous commands
```

---

## 🔧 Troubleshooting

| Problem | Fix |
|---------|-----|
| Bot doesn't start | Run `dfxbot logs` and check for missing `.env` values |
| `docker: command not found` | Run `dfxbot build-images` to verify Docker is installed, or re-run installer |
| SSH button says "failed" | Container may not have internet — check `docker inspect <cid>` network |
| VPS image missing | Run `dfxbot build-images` to rebuild the OS images |
| Port forward not working | Ensure `iptables` is installed: `apt install iptables` |
| Coins not saving | Check `data/bot.db` exists and is writable by the bot container |
| Bot restarts looping | Check `dfxbot logs` for Python errors — likely a bad `DISCORD_TOKEN` |

---

## 🛡️ Security Notes

- tmate and SSHx links are sent **ephemerally** — only the requesting user can see them
- Admin commands are restricted to Discord IDs listed in `ADMIN_IDS`
- VPS containers use `--privileged` to support full Linux functionality (systemd, etc.)
- No host ports are opened unless the user explicitly runs `1ports add`
- The Docker socket (`/var/run/docker.sock`) grants full Docker access — keep your server secure

---

## 📜 Credits

<p align="center">
  <table>
    <tr>
      <td align="center" width="200">
        <b>🏢 DFX Cloud Technologies</b><br/>
        <sub>Bot Developer & Infrastructure</sub>
      </td>
      <td align="center" width="200">
        <b>⚡ WarriorXwiN</b><br/>
        <sub>Founder · OG BEGAMING · Powered By</sub>
      </td>
    </tr>
  </table>
</p>

---

## 🔗 Links

| | Link |
|-|------|
| 📦 GitHub | [github.com/CodeXOwnz/DFXBOT-V1](https://github.com/CodeXOwnz/DFXBOT-V1) |
| 💬 tmate | [tmate.io](https://tmate.io) |
| 🌐 SSHx | [sshx.io](https://sshx.io) |
| 🐳 Docker | [docs.docker.com](https://docs.docker.com) |

---

<p align="center">
  <b>© DFX Cloud Technologies · Powered by WarriorXwiN (OG BEGAMING)</b>
  <br/><br/>
  <img src="https://img.shields.io/badge/%E2%9A%A1-DFX%20Cloud%20Technologies-00D4FF?style=for-the-badge" />
  &nbsp;
  <img src="https://img.shields.io/badge/OG%20BEGAMING-WarriorXwiN-FF6B35?style=for-the-badge" />
</p>

