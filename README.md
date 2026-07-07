<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=700&size=30&pause=1000&color=00D4FF&center=true&vCenter=true&width=750&lines=DFX+Cloud+Bot+%E2%9A%A1;Discord+VPS+Management+Bot;LXC+%7C+Multi-Node+%7C+tmate+SSH;Economy+%7C+Plans+%7C+Port+Forwarding" alt="Typing SVG" />
</p>

<p align="center">
  <a href="https://github.com/CodeXOwnz/DFXBOT-V1">
    <img src="https://img.shields.io/badge/GitHub-DFXBOT--V1-181717?style=for-the-badge&logo=github&logoColor=white" />
  </a>
  <img src="https://img.shields.io/badge/Python-3.11%2B-3776AB?style=for-the-badge&logo=python&logoColor=white" />
  <img src="https://img.shields.io/badge/discord.py-2.3%2B-5865F2?style=for-the-badge&logo=discord&logoColor=white" />
  <img src="https://img.shields.io/badge/Backend-LXC%20%2F%20LXD-E95420?style=for-the-badge&logo=linux&logoColor=white" />
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

         DISCORD VPS MANAGEMENT BOT  ·  LXC MULTI-NODE EDITION  ⚡
```

</p>

---

## 📖 About

**DFX Cloud Bot** is a production-grade Discord bot that lets server admins **sell, deploy, manage, and monitor real Linux VPS containers** — entirely from Discord. No web panel, no browser, just commands and buttons.

Built on **LXC / LXD** with multi-node support, it combines a full coin economy, interactive deploy wizards, ephemeral tmate SSH, port forwarding, anti-miner protection, and a live Flask web admin panel into a single self-hosted bot.

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

The installer will automatically:

- ✅ Install Python 3.11+, LXD, and tmate  
- ✅ Download and extract the bot  
- ✅ Create a Python virtual environment and install dependencies  
- ✅ Prompt for your Bot Token, Admin ID, Server IP, and Flask secret  
- ✅ Register a `systemd` service with auto-restart on crash  
- ✅ Install the global `dfxbot` CLI command  

---

## 🛠️ dfxbot CLI — Run From Anywhere

After installation, manage your bot with the `dfxbot` command:

```bash
dfxbot start          # ▶  Start the bot
dfxbot stop           # ⏹  Stop the bot
dfxbot restart        # 🔄  Restart the bot
dfxbot status         # 📊  Show systemd service status
dfxbot logs           # 📜  Stream live logs  (Ctrl+C to exit)
dfxbot update         # ⬆  Pull latest package and restart
dfxbot edit-env       # ✏️  Edit .env in your default editor
dfxbot update-deps    # 📦  Upgrade Python packages and restart
dfxbot lxd-status     # 🌐  Show LXD pools, networks, and containers
dfxbot uninstall      # 🗑️  Remove the service (files kept)
```

---

## ✨ Features

<table>
<tr>
<td width="50%">

### 🖥️ VPS Management
- Deploy containers with interactive node + OS picker
- Start · Stop · Restart · Stats via button panel
- Live CPU / RAM / Disk / Network metrics
- Snapshot, restore, and clone containers
- Share VPS access with other Discord users
- Auto-suspend on expiry with DM notification
- Run `neofetch` inside any container from Discord

</td>
<td width="50%">

### 🌐 Multi-Node Architecture
- Unlimited remote LXC nodes via REST API
- Smart routing — local exec vs. remote HTTP
- Node picker UI shown before OS selection
- Per-node capacity tracking and limits
- Add / remove nodes live from Discord
- `1node-status` — real-time capacity overview

</td>
</tr>
<tr>
<td width="50%">

### 💰 Full Coin Economy
- Daily rewards with 7-day streak multipliers
- Work command (4 h cooldown, random payout)
- Leaderboard, transaction history, gifting
- Achievements, daily quests, coin boosters
- Coupon codes redeemable for coins
- Plan-based VPS deploy & renewal system

</td>
<td width="50%">

### 🔒 Security & Monitoring
- **Anti-miner** — scans every container every 5 min
- Auto-suspend on mining process detection
- Resource threshold alerts (CPU & RAM %)
- Whitelist system for trusted containers
- Suspension log with timestamps
- Flask panel refuses default / weak secrets

</td>
</tr>
<tr>
<td width="50%">

### 🔌 Port Forwarding
- Expose any container port to the internet
- Per-user slot quota with admin override
- LXC proxy device — no iptables mess
- List, remove, and force-revoke forwards
- Port conflict detection before creation

</td>
<td width="50%">

### 🔑 tmate SSH Sessions
- Ephemeral SSH — no exposed passwords
- One-click button in the `1manage` panel
- Auto-installs tmate inside container
- Link sent privately — never stored
- Configurable timeout and retry count

</td>
</tr>
<tr>
<td width="50%">

### 🎨 Premium Embed UI
- Custom `Colors` palette across all responses
- `build_embed` — consistent DFX branding
- `progress_bar` & `mini_bar` for live stats
- `step_list` — animated deploy wizard steps
- `status_badge` — colour-coded container state
- Discord button & dropdown component views

</td>
<td width="50%">

### 🌍 Flask Web Admin Panel
- Live stats dashboard with Socket.IO push
- VPS table with status badges for all nodes
- API endpoint for external integrations
- Password-protected login (`FLASK_SECRET`)
- Disable entirely with `FLASK_ENABLED=0`
- Binds on configurable port (default `5000`)

</td>
</tr>
</table>

---

## 🐧 Supported OS Images

<div align="center">

| Emoji | Image Key | Full Name |
|:-----:|-----------|-----------|
| 🟠 | `ubuntu-24.04` | Ubuntu 24.04 LTS (Noble Numbat) |
| 🟠 | `ubuntu-22.04` | Ubuntu 22.04 LTS (Jammy Jellyfish) |
| 🟠 | `ubuntu-20.04` | Ubuntu 20.04 LTS (Focal Fossa) |
| 🟠 | `ubuntu-18.04` | Ubuntu 18.04 LTS (Bionic Beaver) |
| 🔴 | `debian-12` | Debian 12 (Bookworm) |
| 🔴 | `debian-11` | Debian 11 (Bullseye) |
| 🔴 | `debian-10` | Debian 10 (Buster) |
| 🟣 | `alpine-3.18` | Alpine Linux 3.18 |

</div>

---

## 📋 All Bot Commands

> Default prefix: **`1`** (configurable in `.env`)

---

### 👤 User Commands

| Command | Description |
|---------|-------------|
| `1help` | Interactive category-based help menu |
| `1ping` | Check bot latency |
| `1uptime` | Show host and bot uptime |
| `1botinfo` | Bot stats — servers, fleet size, nodes, latency |
| `1os-list` | List all supported OS images |

---

### 🖥️ VPS Commands

| Command | Description |
|---------|-------------|
| `1myvps` | List all your VPS instances with status badges |
| `1manage` | Open interactive control panel for VPS #1 |
| `1manage <vps#>` | Open control panel for a specific VPS |
| `1vpsinfo` | Detailed info for VPS #1 (IP, specs, expiry, node) |
| `1vpsinfo <vps#>` | Detailed info for a specific VPS |
| `1neofetch` | Run neofetch inside VPS #1 |
| `1neofetch <vps#>` | Run neofetch inside a specific VPS |
| `1share-user @user <vps#>` | Grant another Discord user access to your VPS |
| `1share-ruser @user <vps#>` | Revoke a user's shared access |
| `1manage-shared @owner <vps#>` | Open the control panel for a VPS shared with you |

> 💡 The `1manage` panel has buttons: **Start · Stop · Restart · Stats · SSH (tmate)**

---

### 💰 Economy Commands

| Command | Description |
|---------|-------------|
| `1balance` | Check your coin balance |
| `1balance @user` | Check another user's balance |
| `1daily` | Claim daily reward — streak bonus stacks up to 7× |
| `1work` | Work for coins (4 h cooldown, random payout) |
| `1streak` | View your daily streak and multiplier |
| `1streak @user` | View another user's streak |
| `1leaderboard` | Top 10 coin holders on the server |
| `1transactions` | View your transaction history (page 1) |
| `1transactions <page>` | View a specific transaction history page |
| `1gift @user <amount>` | Gift coins to another user |
| `1shop` | Browse available coin boosters |
| `1shop <item_id>` | Purchase a specific booster |
| `1booster` | Check your active booster and time remaining |
| `1achievements` | View your unlocked achievements |
| `1achievements @user` | View another user's achievements |
| `1quests` | View your active daily and weekly quests |
| `1coinhelp` | Guide on how to earn coins fast |
| `1profile` | View your full profile (coins, streak, VPS, achievements) |
| `1profile @user` | View another user's full profile |

---

### 🚀 Plans & Deployment

| Command | Description |
|---------|-------------|
| `1deploy-plans` | Browse all available deployment plans |
| `1resource-plans` | Browse resource upgrade packs |
| `1deploy <plan_id>` | Deploy a VPS — node picker → OS picker → launch |
| `1deploy-os <plan_id>` | Deploy with an OS picker (skips node picker) |
| `1deploy-os <plan_id> <os_key>` | Deploy with an explicit OS — instant launch |
| `1upgrade <vps#> <plan_id>` | Add resources from a resource plan |
| `1add-resources <vps#> <ram_GB> <cpu> <disk_GB>` | Add custom resources (per-unit coin price) |
| `1renew <vps#> <15\|30>` | Extend VPS expiry with coins (15 or 30 days) |
| `1renewprices` | View renewal coin pricing |
| `1redeem <code>` | Redeem a coupon code for coins |

---

### 🔌 Port Forwarding

| Command | Description |
|---------|-------------|
| `1ports` | Show port forwarding help and your slot quota |
| `1ports add <vps#> <port>` | Forward a container port to the host |
| `1ports list` | View all your active port forwards |
| `1ports remove <forward_id>` | Remove a specific port forward |
| `1ports slots` | Check your total and used port slot quota |

---

### 🔧 Admin — VPS Management

> 🔒 Restricted to Discord user IDs listed in `ADMIN_IDS`

| Command | Description |
|---------|-------------|
| `1give-vps @user <ram> <cpu> <disk>` | Provision a free VPS for a user (default OS + node) |
| `1give-vps @user <ram> <cpu> <disk> <os> <days> <node>` | Provision with full options |
| `1delete-vps @user <vps#>` | Permanently delete a user's VPS |
| `1suspend-vps <container>` | Suspend a container (stops it, blocks commands) |
| `1unsuspend-vps <container>` | Unsuspend and restart a container |
| `1whitelist-vps <container> add` | Whitelist container from anti-miner scanning |
| `1whitelist-vps <container> remove` | Remove from anti-miner whitelist |
| `1exec <container> <command>` | Execute a shell command inside a container |
| `1vps-stats <container>` | Live CPU / RAM / Disk stats for a container |
| `1snapshot <container>` | Create a snapshot of a container |
| `1restore-snapshot <container> <snap_name>` | Restore a container from a snapshot |
| `1clone-vps <container>` | Clone a container to a new VPS |
| `1list-all` | Full VPS dashboard — all users, all nodes |
| `1broadcast <message>` | DM all VPS holders with an announcement |
| `1apply-perms <container>` | Reapply LXC security config to a container |
| `1admin-renew <container>` | Extend VPS expiry by 30 days (free, admin) |
| `1admin-renew <container> <days>` | Extend by a custom number of days |
| `1suspension-logs` | View all suspension history across all VPS |
| `1suspension-logs <container>` | View suspension history for a specific container |

---

### 🌐 Admin — Node Management

| Command | Description |
|---------|-------------|
| `1add-node <name> <location> <url> <api_key>` | Register a remote LXC node |
| `1add-node <name> <location> <url> <api_key> <max_vps>` | Register with capacity limit |
| `1list-nodes` | List all nodes with used / total capacity |
| `1remove-node <node_id>` | Remove a remote node |
| `1node-status` | Live capacity and health overview for all nodes |

---

### 📊 Admin — Monitoring

| Command | Description |
|---------|-------------|
| `1sysinfo` | Host CPU, RAM, Disk, network, and uptime |
| `1resource-check` | Manual scan of all containers for overuse |
| `1monitor-config <cpu%> <ram%>` | Set auto-suspend thresholds (e.g. `90 90`) |
| `1anti-miner` | Trigger a manual anti-miner scan across all containers |

---

### 💵 Admin — Economy

| Command | Description |
|---------|-------------|
| `1givecoins @user <amount>` | Add coins to a user's balance |
| `1removecoins @user <amount>` | Remove coins from a user's balance |
| `1setcoins @user <amount>` | Set a user's balance to an exact amount |
| `1userinfo @user` | Full admin profile — coins, VPS list, transactions |
| `1create-coupon <coins> <code>` | Create a redeemable coupon code |
| `1list-coupons` | List all coupon codes and redemption counts |
| `1ports-add-user <slots> @user` | Grant extra port forwarding slots to a user |
| `1ports-remove-user <slots> @user` | Remove port forwarding slots from a user |
| `1ports-revoke <forward_id>` | Force-remove any user's port forward |
| `1list-forwards` | View all active port forwards across all users |

---

### 📦 Admin — Plans

| Command | Description |
|---------|-------------|
| `1create-plan <id> <name> <ram> <cpu> <disk>` | Create a deployment plan (7d / free) |
| `1create-plan <id> <name> <ram> <cpu> <disk> <days> <cost> <emoji>` | Full plan config |
| `1delete-plan <plan_id>` | Delete a plan |
| `1list-plans` | List all deploy and resource plans |
| `1set-status <text>` | Change the bot's Discord activity status |

---

## ⚙️ Environment Variables

| Variable | Default | Required | Description |
|----------|---------|:--------:|-------------|
| `DISCORD_TOKEN` | — | ✅ | Your bot token from Discord Developer Portal |
| `ADMIN_IDS` | — | ✅ | Comma-separated Discord user IDs with admin access |
| `SERVER_IP` | — | ✅ | Public IP of your host machine |
| `BOT_PREFIX` | `1` | | Command prefix (e.g. `!`, `?`, `1`) |
| `BOT_NAME` | `DFX Cloud` | | Bot display name used in embeds |
| `HOST_NAME` | `DFX Cloud Technologies` | | Host branding in embeds |
| `POWERED_BY` | `DFX Cloud Technologies` | | Footer branding |
| `LOG_CHANNEL_ID` | `0` | | Discord channel ID for admin log messages |
| `VPS_ROLE_ID` | `0` | | Role ID auto-assigned to VPS owners (`0` = auto-create) |
| `DEFAULT_STORAGE_POOL` | `default` | | LXC storage pool name (`lxc storage list`) |
| `CPU_THRESHOLD` | `90` | | CPU % that triggers auto-suspend |
| `RAM_THRESHOLD` | `90` | | RAM % that triggers auto-suspend |
| `DB_PATH` | `data/bot.db` | | SQLite database file path |
| `FLASK_ENABLED` | `1` | | Set to `0` to disable the web admin panel |
| `FLASK_PORT` | `5000` | | Web admin panel port |
| `FLASK_SECRET` | — | ✅ | Web panel login password (rejects default placeholder) |
| `TMATE_WAIT_SECS` | `15` | | Seconds to wait for tmate session before retry |
| `TMATE_RETRIES` | `4` | | Number of tmate connection retry attempts |

---

## 🌐 Multi-Node Setup

The bot supports **one local node** plus unlimited **remote nodes** connected via a simple REST API.

```
Discord ──► DFX Cloud Bot
                │
        ┌───────┴──────────┐
        ▼                  ▼
  [Local Node]      [Remote Node(s)]
   lxc exec          POST /api/execute
   localhost          { "command": "lxc start abc" }
                      → { "returncode": 0, "stdout": "..." }
```

**Register a remote node from Discord:**
```
1add-node Singapore SG http://10.0.0.2:8080 my-api-key 50
```

The remote node only needs a small API server that wraps `lxc` via subprocess — a minimal Flask app is enough.

---

## 🗂️ Project Structure

```
dfx-cloud-bot/
│
├── bot.py                  # Core — DB init, LXC helpers, embed system, Flask panel, anti-miner
│
├── cogs/
│   ├── admin_vps.py        # Admin VPS CRUD + multi-node management
│   ├── vps_manage.py       # User VPS panel — manage, share, neofetch, tmate
│   ├── plans.py            # Deploy & resource plans — node / OS picker wizard
│   ├── ports.py            # Port forwarding via LXC proxy devices
│   ├── monitoring.py       # sysinfo, resource-check, anti-miner, node-status
│   ├── coins.py            # Full economy — daily, work, shop, achievements, quests
│   ├── admin_coins.py      # Admin coin management
│   ├── coupons.py          # Coupon code creation and redemption
│   └── misc.py             # Help menu, botinfo, set-status
│
├── data/
│   └── bot.db              # SQLite database (auto-created on first run)
│
├── requirements.txt        # Python dependencies
├── .env.example            # Configuration template — copy to .env
├── installer.sh            # One-line installer script
└── README.md
```

---

## 🛡️ Security

| Layer | Implementation |
|-------|---------------|
| **Admin gate** | All admin commands verify the caller's ID against `ADMIN_IDS` |
| **tmate SSH** | Ephemeral sessions — link sent privately to the user, never logged |
| **Anti-miner** | Scans `ps aux` inside every container every 5 minutes automatically |
| **Auto-suspend** | Container stopped immediately upon miner or threshold detection |
| **LXC isolation** | Each VPS runs in its own Linux namespace — full process isolation |
| **Flask auth** | Panel refuses to start when `FLASK_SECRET` matches the default placeholder |
| **Audit trail** | Every coin transaction is logged with type, amount, and timestamp |
| **Suspension log** | Every container suspension is recorded with reason and timestamp |

---

## 📜 Credits

<p align="center">
  <table align="center">
    <tr>
      <td align="center" width="240">
        <b>⚡ WarriorXwiN</b><br/>
        <sub>Creator · OG BEGAMING<br/>Premium UI · LXC Management</sub>
      </td>
      <td align="center" width="240">
        <b>🏢 DFX Cloud Technologies</b><br/>
        <sub>Infrastructure · Economy System<br/>Cog Architecture · Hosting</sub>
      </td>
    </tr>
  </table>
</p>

---

## 🔗 Links

| | |
|-|-|
| 📦 **GitHub** | [github.com/CodeXOwnz/DFXBOT-V1](https://github.com/CodeXOwnz/DFXBOT-V1) |
| 🔑 **tmate** | [tmate.io](https://tmate.io) |
| 🖥️ **LXD Docs** | [documentation.ubuntu.com/lxd](https://documentation.ubuntu.com/lxd/en/latest/) |
| 🐍 **discord.py** | [discordpy.readthedocs.io](https://discordpy.readthedocs.io) |

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
