<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=700&size=30&pause=1000&color=00D4FF&center=true&vCenter=true&width=750&lines=DFX+Cloud+Bot+%E2%9A%A1;Discord+VPS+Management+Bot;LXC+%2B+Docker+Dual+Backend;Works+on+ANY+VPS+Host" alt="Typing SVG" />
</p>

<p align="center">
  <a href="https://github.com/CodeXOwnz/DFXBOT-V1">
    <img src="https://img.shields.io/badge/GitHub-DFXBOT--V1-181717?style=for-the-badge&logo=github&logoColor=white" />
  </a>
  <img src="https://img.shields.io/badge/Python-3.11%2B-3776AB?style=for-the-badge&logo=python&logoColor=white" />
  <img src="https://img.shields.io/badge/discord.py-2.3%2B-5865F2?style=for-the-badge&logo=discord&logoColor=white" />
  <img src="https://img.shields.io/badge/Backend-LXC%20%7C%20Docker-E95420?style=for-the-badge&logo=linux&logoColor=white" />
  <img src="https://img.shields.io/badge/Status-Active-brightgreen?style=for-the-badge" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Made%20by-WarriorXwiN%20(OG%20BEGAMING)-FF6B35?style=flat-square" />
  &nbsp;
  <img src="https://img.shields.io/badge/Powered%20by-DFX%20CLOUD%20TECHNOLOGIES-00D4FF?style=flat-square" />
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

        DISCORD VPS MANAGEMENT BOT  ·  LXC + DOCKER EDITION  ⚡
```

</p>

---

## 📖 About

**DFX Cloud Bot** is a production-grade Discord bot that lets you **sell, deploy, manage, and monitor real Linux VPS containers** — entirely from Discord.

It runs on **two interchangeable backends**:

| Backend | Best for | Requirements |
|---------|----------|-------------|
| 🖥️ **LXC / LXD** | Bare-metal servers, KVM VPS, dedicated hosts | LXD via snap |
| 🐳 **Docker** | Any VPS including OpenVZ, Virtuozzo, budget hosts | Docker Engine |

The installer **auto-detects** which backend is available on your server and configures everything automatically.

> ⚡ **Made by:** WarriorXwiN (OG BEGAMING)  
> 🏢 **Powered by:** DFX Cloud Technologies  
> 🔗 **Source:** [github.com/CodeXOwnz/DFXBOT-V1](https://github.com/CodeXOwnz/DFXBOT-V1)

---

## 🚀 One-Line Installation

> **Requires:** Ubuntu 20.04+ or Debian 11+ · Root access

```bash
bash <(curl -sL https://raw.githubusercontent.com/CodeXOwnz/DFXBOT-V1/main/installer.sh)
```

> 🔑 **Installer Code:** `dfxcloud2026`

### What the installer does automatically

- ✅ Detects whether LXC/LXD or Docker is available on your host  
- ✅ Installs whichever backend is missing (or lets you choose if both are available)  
- ✅ Installs Python 3.11+ and creates a virtual environment  
- ✅ Downloads and extracts the bot  
- ✅ Prompts for Bot Token, Admin ID, IP, and Flask secret  
- ✅ Sets `BACKEND=lxc` or `BACKEND=docker` in `.env` automatically  
- ✅ Registers a `systemd` service with auto-restart on crash  
- ✅ Installs the global `dfxbot` CLI command  
- ✅ Pre-builds Docker VPS base images (if Docker backend is selected)

---

## 🔄 Dual-Backend Architecture

```
Discord Users
      │
      ▼
DFX Cloud Bot  (bot.py)
      │
      ├─ BACKEND=lxc  ──────►  LXC / LXD
      │                         ├─ Local node  (lxc exec, lxc start, lxc proxy)
      │                         └─ Remote nodes  (REST API  →  lxc on remote host)
      │
      └─ BACKEND=docker ────►  Docker Engine
                                ├─ docker run / exec / start / stop
                                ├─ iptables DNAT  (port forwarding)
                                └─ docker exec ps aux  (anti-miner scan)
```

Switch backend at any time by editing `.env`:
```bash
dfxbot edit-env   # change BACKEND=lxc  →  BACKEND=docker  (or vice-versa)
dfxbot restart
```

---

## ✨ Features

<table>
<tr><td>🖥️ <b>VPS Deploy</b></td><td>Interactive node + OS picker → live deploy wizard with progress steps</td></tr>
<tr><td>🔄 <b>Dual Backend</b></td><td>LXC/LXD <i>and</i> Docker — same commands, same embeds, same economy</td></tr>
<tr><td>🌐 <b>Multi-Node</b></td><td>Unlimited remote LXC nodes via REST API (Docker backend uses local Docker only)</td></tr>
<tr><td>💰 <b>Coin Economy</b></td><td>Daily, work, streaks, achievements, quests, shop, gifting, leaderboard</td></tr>
<tr><td>🔐 <b>tmate SSH</b></td><td>Ephemeral SSH sessions — works on both LXC and Docker containers</td></tr>
<tr><td>🔌 <b>Port Forwarding</b></td><td>LXC proxy devices <i>or</i> iptables DNAT — transparent to the user</td></tr>
<tr><td>🛡️ <b>Anti-Miner</b></td><td>Scans <code>ps aux</code> inside every container every 5 min, auto-suspends</td></tr>
<tr><td>📦 <b>Snapshots</b></td><td>Save and restore container state (LXC snapshots / Docker commit)</td></tr>
<tr><td>🌍 <b>Web Panel</b></td><td>Flask + Socket.IO admin dashboard at <code>http://your-ip:5000</code></td></tr>
<tr><td>📊 <b>Live Stats</b></td><td>CPU, RAM, Disk, uptime — pulled via exec inside the container</td></tr>
<tr><td>🤝 <b>VPS Sharing</b></td><td>Grant or revoke access to your VPS for other Discord users</td></tr>
<tr><td>⏰ <b>Expiry System</b></td><td>Auto-stop on expiry with DM + coin-based renewal</td></tr>
</table>

---

## 🐧 Supported OS Images

<div align="center">

| | Image | Full Name | LXC | Docker |
|:-:|-------|-----------|:---:|:------:|
| 🟠 | `ubuntu:20.04` | Ubuntu 20.04 LTS | ✅ | ✅ |
| 🟠 | `ubuntu:22.04` | Ubuntu 22.04 LTS | ✅ | ✅ |
| 🟠 | `ubuntu:24.04` | Ubuntu 24.04 LTS | ✅ | ✅ |
| 🔴 | `debian:11` / `images:debian/11` | Debian 11 (Bullseye) | ✅ | ✅ |
| 🔴 | `debian:12` / `images:debian/12` | Debian 12 (Bookworm) | ✅ | ✅ |
| 🔴 | `debian:10` / `images:debian/10` | Debian 10 (Buster) | ✅ | ✅ |
| 🟣 | `alpine:3.18` | Alpine Linux 3.18 | ❌ | ✅ |

</div>

---

## 🛠️ dfxbot CLI

```bash
dfxbot start          # ▶  Start the bot
dfxbot stop           # ⏹  Stop the bot
dfxbot restart        # 🔄  Restart the bot
dfxbot status         # 📊  Service status
dfxbot logs           # 📜  Stream live logs  (Ctrl+C to exit)
dfxbot update         # ⬆  Pull latest package and restart
dfxbot edit-env       # ✏️  Edit .env  (change BACKEND here)
dfxbot update-deps    # 📦  Upgrade Python packages
dfxbot backend        # 🖥  Show backend + list running VPS containers
dfxbot build-images   # 🐳  (Docker) Pre-build Ubuntu/Debian VPS images
dfxbot list-images    # 🐳  (Docker) Show which images are pre-built
dfxbot uninstall      # 🗑️  Remove service (files kept)
```

---

## 📋 All Bot Commands

> Default prefix: **`1`** — configurable with `BOT_PREFIX` in `.env`

---

### 👤 General

| Command | Description |
|---------|-------------|
| `1help` | Interactive category help menu |
| `1ping` | Bot latency |
| `1uptime` | Host and bot uptime |
| `1botinfo` | Stats — servers, fleet, nodes, latency |
| `1os-list` | List all supported OS images |

---

### 🖥️ VPS

| Command | Description |
|---------|-------------|
| `1myvps` | List all your VPS instances |
| `1manage [vps#]` | Interactive control panel (Start · Stop · Restart · Stats · SSH) |
| `1vpsinfo [vps#]` | Detailed VPS info — IP, specs, expiry, backend, node |
| `1neofetch [vps#]` | Run neofetch inside your VPS |
| `1profile [@user]` | Full profile — coins, streak, VPS count, achievements |
| `1share-user @user <vps#>` | Grant shared access to another Discord user |
| `1share-ruser @user <vps#>` | Revoke shared access |
| `1manage-shared @owner <vps#>` | Control panel for a VPS shared with you |

---

### 💰 Economy

| Command | Description |
|---------|-------------|
| `1balance [@user]` | Coin balance |
| `1daily` | Claim daily reward — streak bonus stacks up to 7× |
| `1work` | Work for coins (4 h cooldown) |
| `1streak [@user]` | Streak and multiplier |
| `1leaderboard` | Top 10 coin holders |
| `1transactions [page]` | Transaction history |
| `1gift @user <amount>` | Gift coins |
| `1shop [item_id]` | Browse and buy coin boosters |
| `1booster` | Active booster info |
| `1achievements [@user]` | Unlocked achievements |
| `1quests` | Daily and weekly quests |
| `1coinhelp` | How to earn coins guide |

---

### 🚀 Plans & Deployment

| Command | Description |
|---------|-------------|
| `1deploy-plans` | Browse deployment plans |
| `1resource-plans` | Browse resource upgrade packs |
| `1deploy <plan_id>` | Deploy VPS — node picker → OS picker → launch |
| `1deploy-os <plan_id> [os]` | Deploy with explicit OS flag |
| `1upgrade <vps#> <plan_id>` | Add resources from a plan |
| `1add-resources <vps#> <ram> <cpu> <disk>` | Custom resource addition |
| `1renew <vps#> <15\|30>` | Extend VPS expiry with coins |
| `1renewprices` | View renewal pricing |
| `1redeem <code>` | Redeem a coupon code |

---

### 🔌 Port Forwarding

| Command | Description |
|---------|-------------|
| `1ports` | Help + slot quota |
| `1ports add <vps#> <port>` | Forward a container port |
| `1ports list` | View active forwards |
| `1ports remove <id>` | Remove a forward |
| `1ports slots` | Port slot quota |

> **LXC:** Uses LXC proxy devices &nbsp;·&nbsp; **Docker:** Uses iptables DNAT rules

---

### 🔧 Admin — VPS

| Command | Description |
|---------|-------------|
| `1give-vps @user <ram> <cpu> <disk> [os] [days] [node]` | Provision a VPS |
| `1delete-vps @user <vps#>` | Delete a VPS |
| `1suspend-vps <container>` | Suspend a container |
| `1unsuspend-vps <container>` | Unsuspend a container |
| `1whitelist-vps <container> add\|remove` | Anti-miner whitelist |
| `1exec <container> <command>` | Execute inside a container |
| `1vps-stats <container>` | Live resource stats |
| `1snapshot <container>` | Create snapshot |
| `1restore-snapshot <container> <snap>` | Restore snapshot |
| `1clone-vps <container>` | Clone container |
| `1list-all` | All VPS across all users |
| `1broadcast <message>` | DM all VPS holders |
| `1apply-perms <container>` | Reapply security config |
| `1admin-renew <container> [days]` | Extend expiry (free) |
| `1suspension-logs [container]` | Suspension history |

---

### 🌐 Admin — Nodes *(LXC backend only)*

| Command | Description |
|---------|-------------|
| `1add-node <name> <loc> <url> <key> [max]` | Register a remote LXC node |
| `1list-nodes` | List all nodes |
| `1remove-node <id>` | Remove a node |
| `1node-status` | Live capacity overview |

---

### 📊 Admin — Monitoring

| Command | Description |
|---------|-------------|
| `1sysinfo` | Host CPU / RAM / Disk / uptime |
| `1resource-check` | Manual container resource scan |
| `1monitor-config <cpu%> <ram%>` | Set auto-suspend thresholds |
| `1anti-miner` | Trigger manual anti-miner scan |

---

### 💵 Admin — Economy & Plans

| Command | Description |
|---------|-------------|
| `1givecoins @user <amount>` | Give coins |
| `1removecoins @user <amount>` | Remove coins |
| `1setcoins @user <amount>` | Set balance |
| `1userinfo @user` | Full admin profile |
| `1create-coupon <coins> <code>` | Create coupon code |
| `1list-coupons` | List all coupons |
| `1create-plan <id> <name> <ram> <cpu> <disk> [days] [cost]` | Create deploy plan |
| `1delete-plan <id>` | Delete plan |
| `1list-plans` | List all plans |
| `1ports-add-user <slots> @user` | Grant port slots |
| `1ports-revoke <id>` | Force-remove a forward |
| `1list-forwards` | All port forwards |
| `1set-status <text>` | Change bot status |

---

## ⚙️ Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DISCORD_TOKEN` | *(required)* | Bot token |
| `ADMIN_IDS` | *(required)* | Comma-separated admin user IDs |
| `SERVER_IP` | *(required)* | Host public IP |
| **`BACKEND`** | `lxc` | **`lxc` or `docker`** — set by installer automatically |
| `BOT_PREFIX` | `1` | Command prefix |
| `BOT_NAME` | `DFX Cloud` | Bot display name |
| `DEFAULT_STORAGE_POOL` | `default` | LXC storage pool (LXC only) |
| `CPU_THRESHOLD` | `90` | CPU % trigger for auto-suspend |
| `RAM_THRESHOLD` | `90` | RAM % trigger for auto-suspend |
| `DB_PATH` | `data/bot.db` | SQLite database path |
| `FLASK_ENABLED` | `1` | `0` to disable web panel |
| `FLASK_PORT` | `5000` | Web panel port |
| `FLASK_SECRET` | *(required)* | Web panel password |
| `TMATE_WAIT_SECS` | `15` | tmate session wait time |
| `TMATE_RETRIES` | `4` | tmate retry count |

---

## 🔒 Security

| Layer | Detail |
|-------|--------|
| **Admin gate** | All admin commands check caller ID against `ADMIN_IDS` |
| **tmate SSH** | Ephemeral sessions — link only sent to the requesting user |
| **Anti-miner** | Auto-scans all containers every 5 min, suspends on detection |
| **Container isolation** | LXC namespaces / Docker namespaces — full process isolation |
| **Port forwarding** | LXC proxy devices or iptables — no inbound unless user requests it |
| **Flask auth** | Panel refuses to start with the default placeholder secret |
| **Audit trail** | All coin transactions and suspensions logged with timestamps |

---

## 🗂️ Project Structure

```
dfx-cloud-bot/
├── bot.py                  # Core — dual backend, DB, embeds, Flask, anti-miner
├── Dockerfile              # Bot container (optional Docker-compose deployment)
├── Dockerfile.vps          # Pre-built VPS base image (Ubuntu/Debian + tmate)
├── docker-compose.yml      # Run the bot itself in Docker
├── cogs/
│   ├── admin_vps.py        # Admin VPS CRUD + node management
│   ├── vps_manage.py       # User VPS panel — manage, share, neofetch
│   ├── plans.py            # Plans + node/OS picker wizard
│   ├── ports.py            # Port forwarding (proxy or iptables)
│   ├── monitoring.py       # sysinfo, resource-check, anti-miner
│   ├── coins.py            # Economy — daily, work, shop, achievements
│   ├── admin_coins.py      # Admin coin management
│   ├── coupons.py          # Coupon codes
│   └── misc.py             # Help menu, botinfo
├── data/bot.db             # SQLite — auto-created on first run
├── requirements.txt
├── .env.example
├── installer.sh            # Auto-detecting dual-backend installer
└── README.md
```

---

## 📜 Credits

<p align="center">
  <table align="center">
    <tr>
      <td align="center" width="240">
        <b>⚡ WarriorXwiN</b><br/>
        <sub>Creator · OG BEGAMING<br/>Dual-Backend Architecture · Premium UI</sub>
      </td>
      <td align="center" width="240">
        <b>🏢 DFX Cloud Technologies</b><br/>
        <sub>Infrastructure · Economy System<br/>Cog Architecture · Hosting</sub>
      </td>
    </tr>
  </table>
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
```

**© 2025 DFX Cloud Technologies — Made by WarriorXwiN (OG BEGAMING)**

*All rights reserved. Unauthorised redistribution is prohibited.*

<br/>

<img src="https://img.shields.io/badge/%E2%9A%A1-DFX%20CLOUD%20TECHNOLOGIES-00D4FF?style=for-the-badge" />
&nbsp;
<img src="https://img.shields.io/badge/OG%20BEGAMING-WarriorXwiN-FF6B35?style=for-the-badge" />

</p>
