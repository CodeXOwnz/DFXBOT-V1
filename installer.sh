#!/usr/bin/env bash

# =========================================================
# DFX CLOUD BOT INSTALLER (LXC / Merged Edition)
# =========================================================

set -uo pipefail

# =========================================================
# COLORS
# =========================================================

RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
CYAN="\e[1;36m"
MAGENTA="\e[1;35m"
NC="\e[0m"

# =========================================================
# VARIABLES
# =========================================================

INSTALLER_CODE="dfxcloud2026"

BOT_ARCHIVE_URL="https://files.catbox.moe/97nr03.gz"
BOT_ARCHIVE_NAME="dfxcloudbot-lxc.tar.gz"

INSTALL_DIR="dfx-cloud-bot"
SERVICE_NAME="dfxcloudbot"

# =========================================================
# HELPERS
# =========================================================

line() {
    echo -e "${MAGENTA}============================================================${NC}"
}

info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

ok() {
    echo -e "${GREEN}[OK]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# =========================================================
# LOGO
# =========================================================

clear

echo -e "${CYAN}"
cat << "EOF"

██████╗ ███████╗██╗  ██╗     ██████╗██╗      ██████╗ ██╗   ██╗██████╗
██╔══██╗██╔════╝╚██╗██╔╝    ██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗
██║  ██║█████╗   ╚███╔╝     ██║     ██║     ██║   ██║██║   ██║██║  ██║
██║  ██║██╔══╝   ██╔██╗     ██║     ██║     ██║   ██║██║   ██║██║  ██║
██████╔╝██║     ██╔╝ ██╗    ╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝
╚═════╝ ╚═╝     ╚═╝  ╚═╝     ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝

            DFX CLOUD DISCORD BOT INSTALLER (LXC EDITION)

EOF
echo -e "${NC}"

line

# =========================================================
# ROOT CHECK
# =========================================================

if [[ "$EUID" -ne 0 ]]; then
    error "Please run this installer as root (use: sudo bash installer.sh)."
    exit 1
fi

# =========================================================
# INSTALLER CODE CHECK
# =========================================================

read -rp "$(echo -e "${YELLOW}Enter Installer Code: ${NC}")" ENTERED_CODE

if [[ "${ENTERED_CODE}" != "${INSTALLER_CODE}" ]]; then
    error "Wrong Installer Code"
    exit 1
fi

ok "Installer code accepted. Continuing installation..."

line

# =========================================================
# INSTALL BASE DEPENDENCIES
# =========================================================

info "Installing base dependencies..."

apt update -y
apt install -y \
    curl wget tar rsync ca-certificates gnupg lsb-release \
    iptables iproute2 snapd \
    python3 python3-pip python3-venv python3-dev \
    build-essential libssl-dev libffi-dev \
    net-tools jq

ok "Base dependencies installed."

line

# =========================================================
# ENSURE PYTHON 3.11+
# =========================================================

PYTHON_BIN=""

# Prefer python3.11 → python3.12 → python3.13 → fallback to python3
for _py in python3.13 python3.12 python3.11; do
    if command -v "${_py}" >/dev/null 2>&1; then
        PYTHON_BIN="${_py}"
        break
    fi
done

if [[ -z "${PYTHON_BIN}" ]]; then
    info "Python 3.11+ not found — attempting to install via deadsnakes PPA..."
    apt install -y software-properties-common
    add-apt-repository -y ppa:deadsnakes/ppa
    apt update -y
    apt install -y python3.11 python3.11-venv python3.11-dev
    if command -v python3.11 >/dev/null 2>&1; then
        PYTHON_BIN="python3.11"
    fi
fi

if [[ -z "${PYTHON_BIN}" ]]; then
    # Last resort: use whatever python3 is available and hope it's >=3.11
    PYTHON_BIN="python3"
fi

PY_VERSION="$("${PYTHON_BIN}" --version 2>&1)"
ok "Using Python: ${PY_VERSION} (${PYTHON_BIN})"

line

# =========================================================
# INSTALL LXD / LXC (IF NOT ALREADY INSTALLED)
# =========================================================

if ! command -v lxc >/dev/null 2>&1; then
    info "LXC not found. Installing LXD via snap..."

    # Ensure snapd is running
    systemctl enable snapd >/dev/null 2>&1 || true
    systemctl start snapd >/dev/null 2>&1 || true
    sleep 3

    if ! snap install lxd; then
        error "LXD snap install failed. Try: snap install lxd --channel=latest/stable"
        exit 1
    fi

    # Add lxc to PATH for this session
    export PATH="${PATH}:/snap/bin"
fi

# Re-check after any install attempt
if ! command -v lxc >/dev/null 2>&1 && [[ -f /snap/bin/lxc ]]; then
    export PATH="${PATH}:/snap/bin"
fi

if ! command -v lxc >/dev/null 2>&1; then
    error "LXC still not found on PATH after installation. Aborting."
    exit 1
fi

ok "LXC is installed: $(lxc --version 2>/dev/null || echo 'version unknown')"

line

# =========================================================
# INITIALISE LXD (IF NEEDED)
# =========================================================

if ! lxc storage list >/dev/null 2>&1; then
    info "LXD not yet initialised. Running 'lxd init --auto'..."
    if ! lxd init --auto; then
        error "LXD initialisation failed. Please run 'lxd init' manually and re-run this installer."
        exit 1
    fi
    ok "LXD initialised."
else
    ok "LXD already initialised."
fi

# Detect the default storage pool
DETECTED_POOL="$(lxc storage list --format=csv 2>/dev/null | cut -d',' -f1 | head -1 || echo 'default')"
[[ -z "${DETECTED_POOL}" ]] && DETECTED_POOL="default"

line

# =========================================================
# INSTALL TMATE (EPHEMERAL SSH)
# =========================================================

if ! command -v tmate >/dev/null 2>&1; then
    info "Installing tmate..."
    if snap install tmate 2>/dev/null; then
        ok "tmate installed via snap."
    else
        warn "snap install tmate failed — trying apt..."
        apt install -y tmate 2>/dev/null || \
        warn "tmate could not be installed automatically. The bot will install it inside containers on demand."
    fi
else
    ok "tmate already installed: $(tmate -V 2>/dev/null | head -1)"
fi

line

# =========================================================
# DOWNLOAD BOT FILES
# =========================================================

info "Downloading bot files..."

rm -f "${BOT_ARCHIVE_NAME}"

curl -L --fail --retry 5 --retry-delay 3 --progress-bar -o "${BOT_ARCHIVE_NAME}" "${BOT_ARCHIVE_URL}"

if [[ ! -s "${BOT_ARCHIVE_NAME}" ]]; then
    error "Download failed. ${BOT_ARCHIVE_NAME} is missing or empty."
    exit 1
fi

ok "Downloaded ${BOT_ARCHIVE_NAME} successfully."

line

# =========================================================
# EXTRACT BOT FILES
# =========================================================

info "Extracting bot files..."

rm -rf "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}"

tar -xzf "${BOT_ARCHIVE_NAME}" -C "${INSTALL_DIR}"

# If the archive extracted into a single nested folder, move its contents up
CONTENTS=("${INSTALL_DIR}"/*)
if [[ ${#CONTENTS[@]} -eq 1 && -d "${CONTENTS[0]}" ]]; then
    mv "${CONTENTS[0]}"/* "${INSTALL_DIR}"/
    rmdir "${CONTENTS[0]}"
fi

cd "${INSTALL_DIR}"

if [[ ! -f bot.py ]]; then
    error "bot.py not found in the downloaded package — the archive may be corrupted."
    exit 1
fi

mkdir -p data

ok "Bot files extracted to ./${INSTALL_DIR}"

line

# =========================================================
# SET UP PYTHON VIRTUAL ENVIRONMENT
# =========================================================

info "Creating Python virtual environment..."

"${PYTHON_BIN}" -m venv venv

# Activate
# shellcheck source=/dev/null
source venv/bin/activate

info "Upgrading pip..."
pip install --upgrade pip --quiet

info "Installing Python dependencies..."
pip install -r requirements.txt

if ! python -c "import discord" 2>/dev/null; then
    error "discord.py failed to install. Check your internet connection and Python version."
    deactivate
    exit 1
fi

deactivate

ok "Python virtual environment ready."

line

# =========================================================
# CONFIGURE .env FILE
# =========================================================

if [[ -f .env.example ]]; then
    cp .env.example .env
    ok "Created .env from .env.example."
else
    warn ".env.example not found. Creating a blank .env file."
    touch .env
fi

echo
line
echo -e "${CYAN}  Bot Configuration${NC}"
line
echo

read -rp "$(echo -e "${YELLOW}Enter Bot Token: ${NC}")" BOT_TOKEN
read -rp "$(echo -e "${YELLOW}Enter Admin ID(s) (comma-separated Discord user IDs): ${NC}")" ADMIN_IDS_INPUT
read -rp "$(echo -e "${YELLOW}Enter your server's public IP (leave blank to auto-detect): ${NC}")" SERVER_IP_INPUT
read -rp "$(echo -e "${YELLOW}Enter bot command prefix [default: 1]: ${NC}")" BOT_PREFIX_INPUT
read -rp "$(echo -e "${YELLOW}Enter Flask web panel port [default: 5000]: ${NC}")" FLASK_PORT_INPUT
read -rp "$(echo -e "${YELLOW}Enter Flask secret key (random string — do NOT leave default): ${NC}")" FLASK_SECRET_INPUT
echo

# ── Trim whitespace from pasted values ──────────────────
BOT_TOKEN="$(echo -n "${BOT_TOKEN}" | xargs)"
ADMIN_IDS_INPUT="$(echo -n "${ADMIN_IDS_INPUT}" | xargs)"
SERVER_IP_INPUT="$(echo -n "${SERVER_IP_INPUT}" | xargs)"
BOT_PREFIX_INPUT="$(echo -n "${BOT_PREFIX_INPUT}" | xargs)"
FLASK_PORT_INPUT="$(echo -n "${FLASK_PORT_INPUT}" | xargs)"
FLASK_SECRET_INPUT="$(echo -n "${FLASK_SECRET_INPUT}" | xargs)"

# ── Validate required fields ─────────────────────────────
if [[ -z "${BOT_TOKEN}" ]]; then
    error "Bot Token cannot be empty."
    exit 1
fi

if [[ -z "${ADMIN_IDS_INPUT}" ]]; then
    error "Admin IDs cannot be empty."
    exit 1
fi

if [[ -z "${FLASK_SECRET_INPUT}" || "${FLASK_SECRET_INPUT}" == "change-me-to-something-random" ]]; then
    error "You must set a real Flask secret key — the default is rejected by the bot for security."
    exit 1
fi

# ── Apply defaults ───────────────────────────────────────
[[ -z "${BOT_PREFIX_INPUT}" ]]   && BOT_PREFIX_INPUT="1"
[[ -z "${FLASK_PORT_INPUT}" ]]   && FLASK_PORT_INPUT="5000"

# Auto-detect public IP if not provided
if [[ -z "${SERVER_IP_INPUT}" ]]; then
    info "Auto-detecting public IP address..."
    SERVER_IP_INPUT="$(curl -s --max-time 5 https://api.ipify.org 2>/dev/null \
        || curl -s --max-time 5 https://ifconfig.me 2>/dev/null \
        || hostname -I 2>/dev/null | awk '{print $1}' \
        || echo "0.0.0.0")"
    info "Detected IP: ${SERVER_IP_INPUT}"
fi

# ── Write .env helper ────────────────────────────────────
update_env_var() {
    local key="$1"
    local value="$2"
    if grep -q "^${key}=" .env; then
        sed -i "s|^${key}=.*|${key}=${value}|" .env
    else
        echo "${key}=${value}" >> .env
    fi
}

update_env_var "DISCORD_TOKEN"      "${BOT_TOKEN}"
update_env_var "ADMIN_IDS"          "${ADMIN_IDS_INPUT}"
update_env_var "SERVER_IP"          "${SERVER_IP_INPUT}"
update_env_var "BOT_PREFIX"         "${BOT_PREFIX_INPUT}"
update_env_var "FLASK_PORT"         "${FLASK_PORT_INPUT}"
update_env_var "FLASK_SECRET"       "${FLASK_SECRET_INPUT}"
update_env_var "FLASK_ENABLED"      "1"
update_env_var "DEFAULT_STORAGE_POOL" "${DETECTED_POOL}"
update_env_var "DB_PATH"            "data/bot.db"

ok "Configuration saved to .env"

line

# =========================================================
# INSTALL SYSTEMD SERVICE
# =========================================================

info "Installing systemd service (${SERVICE_NAME})..."

BOT_INSTALL_PATH="$(pwd)"
VENV_PYTHON="${BOT_INSTALL_PATH}/venv/bin/python"

cat > "/etc/systemd/system/${SERVICE_NAME}.service" << EOF
[Unit]
Description=DFX Cloud Bot (LXC Edition)
After=network.target snapd.service

[Service]
Type=simple
User=root
WorkingDirectory=${BOT_INSTALL_PATH}
ExecStart=${VENV_PYTHON} bot.py
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal
SyslogIdentifier=${SERVICE_NAME}

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable "${SERVICE_NAME}"
systemctl start  "${SERVICE_NAME}"
sleep 3

if systemctl is-active --quiet "${SERVICE_NAME}"; then
    ok "Bot service is running."
else
    warn "Bot service may not have started yet. Check: journalctl -u ${SERVICE_NAME} -n 50"
fi

line

# =========================================================
# CREATE GLOBAL "dfxbot" CLI COMMAND
# =========================================================

info "Setting up the 'dfxbot' command..."

cat > /usr/local/bin/dfxbot << EOF
#!/usr/bin/env bash
set -uo pipefail

BOT_DIR="${BOT_INSTALL_PATH}"
SERVICE="${SERVICE_NAME}"
ARCHIVE_URL="${BOT_ARCHIVE_URL}"
ARCHIVE_NAME="${BOT_ARCHIVE_NAME}"

case "\${1:-}" in
    start)
        systemctl start "\${SERVICE}"
        echo "[OK] Bot started."
        ;;
    stop)
        systemctl stop "\${SERVICE}"
        echo "[OK] Bot stopped."
        ;;
    restart)
        systemctl restart "\${SERVICE}"
        echo "[OK] Bot restarted."
        ;;
    status)
        systemctl status "\${SERVICE}" --no-pager
        ;;
    logs)
        journalctl -u "\${SERVICE}" -f
        ;;
    update)
        echo "[INFO] Downloading latest bot package..."
        curl -L --fail --retry 5 --retry-delay 3 --progress-bar -o "/tmp/\${ARCHIVE_NAME}" "\${ARCHIVE_URL}"
        TMP_DIR="\$(mktemp -d)"
        tar -xzf "/tmp/\${ARCHIVE_NAME}" -C "\${TMP_DIR}"
        CONTENTS=("\${TMP_DIR}"/*)
        if [[ \${#CONTENTS[@]} -eq 1 && -d "\${CONTENTS[0]}" ]]; then
            SRC_DIR="\${CONTENTS[0]}"
        else
            SRC_DIR="\${TMP_DIR}"
        fi
        rsync -a --exclude '.env' --exclude 'data' --exclude 'venv' \
            "\${SRC_DIR}/" "\${BOT_DIR}/" 2>/dev/null \
            || cp -rf "\${SRC_DIR}/." "\${BOT_DIR}/"
        rm -rf "\${TMP_DIR}" "/tmp/\${ARCHIVE_NAME}"
        echo "[INFO] Updating Python dependencies..."
        "\${BOT_DIR}/venv/bin/pip" install -r "\${BOT_DIR}/requirements.txt" --quiet
        systemctl restart "\${SERVICE}"
        echo "[OK] Bot updated and restarted."
        ;;
    uninstall)
        systemctl stop  "\${SERVICE}" 2>/dev/null || true
        systemctl disable "\${SERVICE}" 2>/dev/null || true
        rm -f "/etc/systemd/system/\${SERVICE}.service"
        systemctl daemon-reload
        rm -f /usr/local/bin/dfxbot
        echo "[OK] Bot service uninstalled. Files remain in \${BOT_DIR}."
        ;;
    edit-env)
        \${EDITOR:-nano} "\${BOT_DIR}/.env"
        echo "[INFO] Restart with 'dfxbot restart' to apply changes."
        ;;
    update-deps)
        echo "[INFO] Updating Python dependencies..."
        "\${BOT_DIR}/venv/bin/pip" install --upgrade -r "\${BOT_DIR}/requirements.txt"
        systemctl restart "\${SERVICE}"
        echo "[OK] Dependencies updated and bot restarted."
        ;;
    lxd-status)
        echo "[INFO] LXD storage pools:"
        lxc storage list
        echo
        echo "[INFO] LXD network list:"
        lxc network list
        echo
        echo "[INFO] Running containers:"
        lxc list
        ;;
    *)
        echo "DFX Cloud Bot (LXC Edition) — control command"
        echo
        echo "Usage: dfxbot {start|stop|restart|status|logs|update|edit-env|update-deps|lxd-status|uninstall}"
        echo
        echo "  start         Start the bot"
        echo "  stop          Stop the bot"
        echo "  restart       Restart the bot"
        echo "  status        Show service status"
        echo "  logs          Stream live logs"
        echo "  update        Download latest package and restart"
        echo "  edit-env      Edit the .env configuration file"
        echo "  update-deps   Upgrade Python dependencies and restart"
        echo "  lxd-status    Show LXD pools, networks, and containers"
        echo "  uninstall     Stop, disable, and remove the service"
        ;;
esac
EOF

chmod +x /usr/local/bin/dfxbot

ok "'dfxbot' command installed to /usr/local/bin/dfxbot"

line

# =========================================================
# FINISH
# =========================================================

echo -e "${GREEN}"
cat << EOF

╔══════════════════════════════════════════════════════╗
║          DFX CLOUD BOT (LXC) IS NOW RUNNING          ║
╚══════════════════════════════════════════════════════╝

INSTALL DIRECTORY : ${BOT_INSTALL_PATH}
SERVICE NAME      : ${SERVICE_NAME}
FLASK PANEL       : http://${SERVER_IP_INPUT}:${FLASK_PORT_INPUT}
LXC STORAGE POOL  : ${DETECTED_POOL}

════════════════════════════════════════════════════════

QUICK COMMANDS (run from anywhere)

dfxbot start          # Start the bot
dfxbot stop           # Stop the bot
dfxbot restart        # Restart the bot
dfxbot status         # Show service status
dfxbot logs           # View live logs (Ctrl+C to exit)
dfxbot update         # Download latest package and restart
dfxbot edit-env       # Edit .env configuration
dfxbot update-deps    # Upgrade Python dependencies
dfxbot lxd-status     # Show LXD pools, networks, containers
dfxbot uninstall      # Remove the service

════════════════════════════════════════════════════════

RAW COMMANDS (run from ${INSTALL_DIR}/)

systemctl status ${SERVICE_NAME}          # Service status
journalctl -u ${SERVICE_NAME} -f          # Live logs
lxc list                                  # All containers
lxc exec <container> -- bash              # Shell into container

════════════════════════════════════════════════════════

NEXT STEPS

1. Check the bot is online in your Discord server
2. Run:  dfxbot logs   to watch the startup output
3. Visit the web panel at http://${SERVER_IP_INPUT}:${FLASK_PORT_INPUT}
   Login password = FLASK_SECRET you entered above

════════════════════════════════════════════════════════

EOF
echo -e "${NC}"
