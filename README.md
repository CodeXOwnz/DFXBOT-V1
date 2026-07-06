<div align="center">

<div align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://shields.io">
    <img src="https://shields.io" alt="DFX CLOUD Sticker">
  </picture>
</div>
    
# ⚡ DFX Cloud VPS Bot

**Premium Discord VPS Management Bot — Docker · SQLite · Cyber-Neon UI**

[![Python](https://img.shields.io/badge/Python-3.11+-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://python.org)
[![discord.py](https://img.shields.io/badge/discord.py-2.3+-5865F2?style=for-the-badge&logo=discord&logoColor=white)](https://discordpy.readthedocs.io)
[![Docker](https://img.shields.io/badge/Docker-Backend-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://docker.com)
[![SQLite](https://img.shields.io/badge/SQLite-WAL-003B57?style=for-the-badge&logo=sqlite&logoColor=white)](https://sqlite.org)
[![License](https://img.shields.io/badge/License-Private-red?style=for-the-badge)](#)

---

*A fully-featured VPS management bot with coin economy, auto-SSH, port forwarding, resource monitoring, and a stunning Cyber-Neon embed interface — all running on Docker.*

</div>

---

## 📋 Table of Contents

- [✨ Features](#-features)
- [🚀 Installation](#-installation)
- [⚙️ Configuration](#️-configuration)
- [📂 Project Structure](#-project-structure)
- [📖 Command Reference](#-command-reference)
- [🔌 SSH Access](#-ssh-access)
- [💰 Coin Economy](#-coin-economy)
- [🛡️ Admin Guide](#️-admin-guide)
- [📜 Credits](#-credits)

---

## ✨ Features

| 🏷️ Category | 🔧 Details |
|---|---|
| **🖥️ VPS Backend** | Docker containers · privileged mode · nested Docker support |
| **🔐 SSH Access** | tmate relay (auto-install, 3× retry) + OpenSSH port-mapped fallback |
| **💾 Database** | SQLite WAL — zero-config, crash-safe, no external DB server needed |
| **🎨 UI** | Cyber-Neon premium embeds · progress bars · animated step lists · status badges |
| **💰 Economy** | Coins · daily / work · streaks · achievements · quests · shop · boosters |
| **📦 Plans** | Deploy plans · resource packs · OS-selector wizard · admin plan CRUD |
| **🎟️ Coupons** | Create · redeem · disable / enable · per-code use limits & expiry |
| **🔌 Port Forwarding** | Real iptables DNAT rules · per-user slot system · auto fallback |
| **📊 VPS Control** | ManageView (SSH / Start / Stop / Restart / Stats / Reinstall / Neofetch) |
| **🛡️ Admin Suite** | Add · remove · suspend · unsuspend · exec · move · clone · wipe |
| **📡 Monitoring** | Background resource monitor · auto-suspend · threshold config · `hostfetch` |
| **📸 Snapshots** | Docker commit/restore system · per-VPS snapshot library |
| **👥 Sharing** | Share VPS access with other users · revoke at any time |
| **📟 Hosting Status** | `1hostfetch` — neofetch-style host panel (CPU · RAM · Disk · Network) |

---

## 🚀 Installation

### Prerequisites

Make sure your **host machine** has the following installed:

```bash
# Check required tools
docker --version       # Docker 20.10+
python3 --version      # Python 3.11+
pip3 --version         # pip (latest)
```

> **Root access** is recommended for iptables port forwarding.  
> **Docker** must be accessible by the user running the bot.

---

### Step 1 — Download the bot

```bash
# Clone or unzip into your server
unzip DFX_Cloud_Bot.zip
cd discord-bot
```

---

### Step 2 — Install Python dependencies

```bash
pip install -r requirements.txt
```

> Installs: `discord.py>=2.3`, `python-dotenv`, `psutil`, `aiohttp`

---

### Step 3 — Configure the bot

```bash
# Copy the example config
cp .env.example .env

# Open and fill in your values
nano .env
```

**Required fields in `.env`:**

```env
DISCORD_TOKEN=your_discord_bot_token_here
ADMIN_IDS=1329731773021552660
SERVER_IP=your_server_public_ip
```

> See the full [Configuration](#️-configuration) section for all options.

---

### Step 4 — Invite the bot to your server

Go to the [Discord Developer Portal](https://discord.com/developers/applications), select your application, and generate an OAuth2 URL with these permissions:

- ✅ `bot`
- ✅ `Send Messages`
- ✅ `Embed Links`
- ✅ `Read Message History`
- ✅ `Manage Roles` *(optional — for VPS role assignment)*
- ✅ `Administrator` *(simplest for full functionality)*

---

### Step 5 — Run the bot

```bash
python3 bot.py
```

**Run in background (recommended for production):**

```bash
# Using screen
screen -S dfxbot
python3 bot.py
# Detach: Ctrl+A then D

# Or using nohup
nohup python3 bot.py > logs/bot.log 2>&1 &

# Or using systemd (see below)
```

**Systemd service (recommended):**

```ini
# /etc/systemd/system/dfxbot.service
[Unit]
Description=DFX Cloud VPS Bot
After=network.target docker.service
Requires=docker.service

[Service]
Type=simple
User=root
WorkingDirectory=/path/to/discord-bot
ExecStart=/usr/bin/python3 bot.py
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable dfxbot
sudo systemctl start dfxbot
sudo systemctl status dfxbot
```

---

### Step 6 — Verify startup

You should see in the console:

```
[INFO] dfx-bot — Logged in as YourBot#1234 (123456789)
[INFO] dfx-bot — Bot prefix: 1  |  Admins: {1329731773021552660}
[INFO] dfx-bot — Loaded cog: cogs.vps_manage
[INFO] dfx-bot — Loaded cog: cogs.admin_vps
... (9 cogs total)
```

Bot status in Discord will show: **🎮 Playing with DFX Cloud ⚡ Powered by DFX Hosting**

---

## ⚙️ Configuration

All configuration is in `.env`. Copy `.env.example` and fill in your values.

| Variable | Default | Required | Description |
|---|---|---|---|
| `DISCORD_TOKEN` | — | ✅ | Your bot token from Discord Developer Portal |
| `ADMIN_IDS` | — | ✅ | Comma-separated Discord user IDs with admin access |
| `SERVER_IP` | `127.0.0.1` | ✅ | Public IP of your VPS host machine |
| `LOG_CHANNEL_ID` | `0` | ➖ | Discord channel ID for admin logs (`0` = disabled) |
| `VPS_ROLE_ID` | `0` | ➖ | Role ID to assign on VPS creation (`0` = disabled) |
| `BOT_PREFIX` | `1` | ➖ | Command prefix (default: `1`) |
| `BOT_NAME` | `DFX Cloud` | ➖ | Bot display name used in embeds |
| `HOST_NAME` | `DFX Cloud Technologies` | ➖ | Host company name |
| `PORT_START` | `10000` | ➖ | Start of host port pool for VPS allocation |
| `PORT_END` | `20000` | ➖ | End of host port pool |
| `TMATE_WAIT_SECS` | `8` | ➖ | Seconds to wait per tmate connection attempt |
| `TMATE_RETRIES` | `3` | ➖ | tmate attempts before OpenSSH fallback |
| `CPU_THRESHOLD` | `90` | ➖ | CPU % that triggers auto-suspend |
| `RAM_THRESHOLD` | `90` | ➖ | RAM % that triggers auto-suspend |
| `DB_PATH` | `data/bot.db` | ➖ | SQLite database file path |

---

## 📂 Project Structure

```
discord-bot/
│
├── bot.py                    ← Main bot file (config · DB · Docker · embeds · tasks)
├── requirements.txt          ← Python dependencies
├── .env.example              ← Configuration template
├── README.md                 ← This file
│
├── data/
│   ├── bot.db                ← SQLite database (auto-created on first run)
│   └── snapshots/            ← VPS snapshot tarballs
│
└── cogs/
    ├── vps_manage.py         ← ManageView · myvps · manage · snapshots · sharing · clone
    ├── admin_vps.py          ← Full admin VPS suite (add/remove/suspend/exec/move/wipe…)
    ├── coins.py              ← Economy system (daily · work · streaks · achievements · quests)
    ├── plans.py              ← Deploy & resource plans · OS wizard · plan CRUD
    ├── coupons.py            ← Coupon codes (create · redeem · manage)
    ├── ports.py              ← Port forwarding (iptables DNAT · per-user slots)
    ├── monitoring.py         ← hostfetch · serverstats · resource-check · thresholds
    ├── admin_coins.py        ← Admin coin management (give · remove · set · config)
    └── misc.py               ← Help menu · botinfo · set-status
```

---

## 📖 Command Reference

> **Prefix:** `1` &nbsp;|&nbsp; Example: `1myvps`, `1deploy 1`, `1daily`

---

### 👤 User Commands

| Command | Description |
|---|---|
| `1ping` | Check bot latency |
| `1uptime` | Show bot and host uptime |
| `1botinfo` | Display bot and server information |
| `1hostfetch` | Neofetch-style host panel (CPU · RAM · Disk · Network · Fleet) |
| `1help` | Interactive category-based help with dropdown |

---

### 🖥️ VPS Management

| Command | Description |
|---|---|
| `1myvps` | List all your VPS instances |
| `1manage [vps#]` | Open interactive VPS control panel (SSH · Start · Stop · Restart · Stats · Reinstall · Neofetch) |
| `1vpsinfo [vps#]` | Detailed VPS information |
| `1vps-stats [vps#]` | Live CPU & RAM usage |
| `1vps-uptime [vps#]` | Show VPS uptime |
| `1vps-processes [vps#]` | List top running processes |
| `1vps-logs [vps#] [lines]` | Tail container logs |
| `1restart-vps [vps#]` | Restart a VPS container |
| `1neofetch [vps#]` | Run neofetch inside your VPS |
| `1vps-name [vps#] <name>` | Set a custom name for your VPS |
| `1snapshot [vps#] [name]` | Take a VPS snapshot |
| `1list-snapshots [vps#]` | List all saved snapshots |
| `1restore-snapshot [vps#] <name>` | Restore VPS from snapshot |
| `1clone-vps [vps#] [name]` | Clone a VPS (costs 300 🪙) |
| `1share-user @user <vps#>` | Grant another user VPS access |
| `1share-ruser @user <vps#>` | Revoke a user's VPS access |
| `1manage-shared @owner <vps#>` | Control a shared VPS |
| `1add-resources [vps#] [ram] [cpu] [disk]` | Purchase extra resources directly |

---

### 🚀 Plans & Deployment

| Command | Description |
|---|---|
| `1deploy-plans` | Browse all VPS deployment plans |
| `1resource-plans` | Browse resource upgrade packs |
| `1os-list` | List all supported OS versions |
| `1deploy <plan_id>` | Deploy a VPS (includes OS selector) |
| `1deploy-os <plan_id>` | Deploy VPS with explicit OS selection |
| `1upgrade [vps#] <plan_id>` | Upgrade resources on an existing VPS |
| `1renewprices` | View renewal pricing |
| `1renew [vps#] <15\|30>` | Extend VPS expiry with coins |

---

### 💰 Coins & Economy

| Command | Description |
|---|---|
| `1balance [@user]` | Check coin balance |
| `1daily` | Claim daily reward (streak bonuses apply!) |
| `1work` | Work for coins (4-hour cooldown) |
| `1streak [@user]` | View daily streak and multiplier |
| `1leaderboard` | Top coin holders |
| `1transactions [page]` | View your transaction history |
| `1gift @user <amount>` | Send coins to another user |
| `1shop [item_id]` | Browse and purchase coin boosters |
| `1booster` | View your active boosters |
| `1achievements [@user]` | View unlocked achievements |
| `1quests` | View daily & weekly quests |
| `1profile [@user]` | Full user profile (coins · streak · VPS · achievements) |
| `1coinhelp` | Tips on how to earn coins fast |

---

### 🎟️ Coupons

| Command | Description |
|---|---|
| `1redeem <code>` | Redeem a coupon code for coins |
| `1create-coupon <coins> <code> [max_uses] [days]` | Create a coupon *(Admin)* |
| `1list-coupons [all]` | List all coupon codes *(Admin)* |
| `1coupon-stats <id>` | View coupon redemption stats *(Admin)* |
| `1disable-coupon <id>` | Disable a coupon *(Admin)* |
| `1enable-coupon <id>` | Re-enable a coupon *(Admin)* |
| `1delete-coupon <id>` | Permanently delete a coupon *(Admin)* |

---

### 🔌 Port Forwarding

| Command | Description |
|---|---|
| `1ports list` | List your active port forwards |
| `1ports add <vps#> <host>:<container> [tcp\|udp]` | Add a port forward |
| `1ports remove <id>` | Remove a port forward |
| `1ports-add-user <amount> @user` | Grant extra port slots *(Admin)* |
| `1ports-remove-user <amount> @user` | Reduce user port slots *(Admin)* |
| `1ports-revoke <id>` | Force-revoke any forward *(Admin)* |

---

### 📊 Monitoring & System

| Command | Description |
|---|---|
| `1hostfetch` | Neofetch-style host info panel |
| `1serverstats` | Full host + fleet statistics |
| `1thresholds` | View current auto-suspend thresholds |
| `1resource-check` | Scan all VPS for high resource usage *(Admin)* |
| `1cpu-monitor <status\|enable\|disable>` | Toggle background monitor *(Admin)* |
| `1set-threshold <cpu%> <ram%>` | Update auto-suspend limits *(Admin)* |

---

### 🛡️ Admin — VPS

| Command | Description |
|---|---|
| `1admin-add @user <ram> <cpu> <disk> [os] [days]` | Provision VPS for any user |
| `1admin-remove <container_id>` | Force-delete any VPS |
| `1admin-list [@user]` | List all VPS, optionally filtered by user |
| `1admin-info <container_id>` | Detailed info for any VPS |
| `1admin-stats` | Full fleet overview statistics |
| `1admin-suspend <container_id> [reason]` | Suspend a VPS |
| `1admin-unsuspend <container_id>` | Unsuspend a VPS |
| `1admin-extend <container_id> [days]` | Extend VPS expiry |
| `1admin-exec <container_id> <command>` | Execute shell command in container |
| `1admin-setres <container_id> <ram> <cpu> <disk>` | Override VPS resource limits |
| `1admin-wipe <container_id>` | Wipe and recreate a VPS container |
| `1admin-move <container_id> @user` | Transfer VPS ownership |
| `1admin-clone <container_id> [@user]` | Clone any VPS |
| `1whitelist-vps <container_id> add\|remove` | Exempt VPS from auto-suspend |
| `1suspension-logs [container_id]` | View suspension history |
| `1stop-vps-all` | Force-stop ALL running containers ⚠️ |
| `1broadcast <message>` | DM all active VPS owners |
| `1vps-network <container_id>` | Inspect container network config |
| `1admin-snapshot <container_id> [name]` | Admin: snapshot any VPS |
| `1admin-vps-stats` | Aggregate resource stats across fleet |

---

### 🛡️ Admin — Plans

| Command | Description |
|---|---|
| `1create-deploy-plan <name> <ram> <cpu> <disk> <days> <cost> [emoji]` | Create a deploy plan |
| `1edit-deploy-plan <id> <field> <value>` | Edit a deploy plan field |
| `1delete-deploy-plan <id>` | Delete a deploy plan |
| `1list-deploy-plans` | List all deploy plans |
| `1create-resource-plan <name> [ram] [cpu] [disk] <cost> [emoji]` | Create a resource plan |
| `1delete-resource-plan <id>` | Delete a resource plan |
| `1admin-renew @user [vps#] [days]` | Free VPS renewal for any user |
| `1renewconfig [cost_15\|cost_30] [value]` | Configure renewal pricing |

---

### 🛡️ Admin — Coins & Bot

| Command | Description |
|---|---|
| `1givecoins @user <amount>` | Add coins to a user |
| `1removecoins @user <amount>` | Deduct coins from a user |
| `1setcoins @user <amount>` | Set exact coin balance |
| `1coinconfig [setting] [value]` | Configure economy settings |
| `1userinfo @user` | Full user profile for any member |
| `1set-status <playing\|watching\|listening> <text>` | Change bot presence |

---

## 🔌 SSH Access

The bot uses a **two-tier SSH system**:

```
Tier 1 (Primary)   → tmate relay (auto-installed, 3 retries)
Tier 2 (Fallback)  → OpenSSH on pre-allocated ssh_port
```

Each container is allocated **two host ports** at creation:

| Port | Maps to | Purpose |
|---|---|---|
| `http_port` | Container `:80` | Web services |
| `ssh_port`  | Container `:22` | SSH fallback |

**If tmate fails** (relay unreachable, rate-limited, etc.), the bot automatically:
1. Installs `openssh-server` inside the container
2. Generates a random root password
3. Returns `ssh root@YOUR_SERVER_IP -p <ssh_port>` with credentials

---

## 💰 Coin Economy

| Source | Amount | Cooldown |
|---|---|---|
| `1daily` | 100–300 🪙 + streak bonus | 24 hours |
| `1work` | 50–150 🪙 | 4 hours |
| Streak bonus | Up to `3×` multiplier at 30-day streak | — |
| Achievements | Bonus coins on unlock | — |
| Quests | Daily & weekly bonus rewards | Resets daily/weekly |
| Coupons | Admin-defined | Per-code limit |

**Spending:**

| Purchase | Cost |
|---|---|
| Deploy plan | Plan-defined |
| Resource upgrade | Plan-defined |
| VPS renewal (15 days) | Configurable (default 200 🪙) |
| VPS renewal (30 days) | Configurable (default 350 🪙) |
| Clone VPS | 300 🪙 |

---

## 🛡️ Admin Guide

**Set your admin ID in `.env`:**
```env
ADMIN_IDS=1329731773021552660
```

**Multiple admins:**
```env
ADMIN_IDS=1329731773021552660,987654321098765432
```

**First-time setup checklist:**
- [ ] Set `DISCORD_TOKEN` and `SERVER_IP` in `.env`
- [ ] Set `ADMIN_IDS` to your Discord user ID
- [ ] (Optional) Set `LOG_CHANNEL_ID` to a private admin channel
- [ ] (Optional) Set `VPS_ROLE_ID` for auto-role on VPS creation
- [ ] Create deployment plans: `1create-deploy-plan Basic 1 1 10 7 100`
- [ ] Create resource plans: `1create-resource-plan ExtraRAM 2 0 0 150`
- [ ] Create a welcome coupon: `1create-coupon 200 WELCOME2024 0 30`

---

## 📜 Credits

<div align="center">

```
╔══════════════════════════════════════════════════════════╗
║                  🏆  MADE WITH ❤️ BY                    ║
╠══════════════════════════════════════════════════════════╣
║                                                          ║
║   ⚡  DFX CLOUD  (WarriorXwiN)                          ║
║       Lead Developer · Architecture · Core Systems       ║
║                                                          ║
║   🎮  OG BEGAMING                                        ║
║       Co-Developer · Testing · Feature Design            ║
║                                                          ║
║   🌐  DFX CLOUD COMMUNITY                               ║
║       Contributors · Testers · Feedback                  ║
║                                                          ║
╠══════════════════════════════════════════════════════════╣
║              Powered by DFX Cloud Technologies           ║
║                   © 2024  DFX CLOUD                      ║
╚══════════════════════════════════════════════════════════╝
```

### 🔗 Project Info

| | |
|---|---|
| **Bot Name** | DFX Cloud VPS Bot |
| **Version** | 2.0 (Merged Edition) |
| **Backend** | Docker · SQLite WAL |
| **Language** | Python 3.11+ · discord.py 2.3+ |
| **Prefix** | `1` |
| **Made by** | DFX CLOUD (WarriorXwiN) & OG BEGAMING |
| **Organisation** | DFX Cloud Technologies |
| **Status** | 🟢 Active |

</div>

---

<div align="center">

**⭐ If you find this bot useful, give it a star!**

*DFX Cloud Technologies — Powering your infrastructure, one container at a time.*

</div>
