#!/usr/bin/env bash

# =========================================================
# DFX CLOUD BOT INSTALLER  (LXC + Docker Dual-Backend)
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

BOT_ARCHIVE_URL="https://files.catbox.moe/xmtgk1.gz"
BOT_ARCHIVE_NAME="dfxcloudbot.tar.gz"

INSTALL_DIR="dfx-cloud-bot"
SERVICE_NAME="dfxcloudbot"
COMPOSE_CMD=""
CHOSEN_BACKEND=""   # "lxc" or "docker" — set during backend detection

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

         DFX CLOUD DISCORD BOT INSTALLER  ⚡  LXC + DOCKER

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
# DETECT / SELECT BACKEND  (LXC or Docker)
# =========================================================

info "Detecting available container backends..."

_LXD_OK=0
_DOCKER_OK=0

# Test LXD — needs both the binary and a working daemon
if command -v lxc >/dev/null 2>&1 || [[ -f /snap/bin/lxc ]]; then
    export PATH="${PATH}:/snap/bin"
    if lxc list >/dev/null 2>&1; then
        _LXD_OK=1
    fi
fi

# Test Docker — needs both the binary and a responding daemon
if command -v docker >/dev/null 2>&1; then
    if docker info >/dev/null 2>&1; then
        _DOCKER_OK=1
    fi
fi

echo
if [[ "${_LXD_OK}" -eq 1 && "${_DOCKER_OK}" -eq 1 ]]; then
    echo -e "${GREEN}Both LXC/LXD and Docker are available.${NC}"
    echo -e "  ${CYAN}[1]${NC} LXC / LXD  (best for bare-metal and KVM hosts)"
    echo -e "  ${CYAN}[2]${NC} Docker      (works on any VPS, including OpenVZ)"
    echo
    read -rp "$(echo -e "${YELLOW}Choose backend [1/2, default 1]: ${NC}")" _CHOICE
    _CHOICE="${_CHOICE:-1}"
    if [[ "${_CHOICE}" == "2" ]]; then
        CHOSEN_BACKEND="docker"
    else
        CHOSEN_BACKEND="lxc"
    fi

elif [[ "${_LXD_OK}" -eq 1 ]]; then
    warn "Docker not found — using LXC/LXD backend."
    CHOSEN_BACKEND="lxc"

elif [[ "${_DOCKER_OK}" -eq 1 ]]; then
    warn "LXC/LXD not available on this host — using Docker backend."
    CHOSEN_BACKEND="docker"

else
    echo
    echo -e "${YELLOW}Neither LXC/LXD nor Docker is running. What should the installer set up?${NC}"
    echo -e "  ${CYAN}[1]${NC} Install LXC/LXD via snap  (bare-metal / KVM recommended)"
    echo -e "  ${CYAN}[2]${NC} Install Docker             (works on any VPS, incl. OpenVZ)"
    echo
    read -rp "$(echo -e "${YELLOW}Choose [1/2, default 2]: ${NC}")" _CHOICE
    _CHOICE="${_CHOICE:-2}"
    if [[ "${_CHOICE}" == "1" ]]; then
        CHOSEN_BACKEND="lxc"
    else
        CHOSEN_BACKEND="docker"
    fi
fi

ok "Selected backend: ${CHOSEN_BACKEND^^}"

line

# =========================================================
# INSTALL LXD (if chosen and not present)
# =========================================================

if [[ "${CHOSEN_BACKEND}" == "lxc" ]]; then
    if [[ "${_LXD_OK}" -eq 0 ]]; then
        info "Installing LXD via snap..."
        systemctl enable snapd >/dev/null 2>&1 || true
        systemctl start  snapd >/dev/null 2>&1 || true
        sleep 3

        if ! snap install lxd; then
            error "LXD snap install failed. Try manually: snap install lxd --channel=latest/stable"
            exit 1
        fi
        export PATH="${PATH}:/snap/bin"
    fi

    # Verify lxc binary is on PATH
    if ! command -v lxc >/dev/null 2>&1; then
        export PATH="${PATH}:/snap/bin"
    fi
    if ! command -v lxc >/dev/null 2>&1; then
        error "lxc not found after install. Aborting."
        exit 1
    fi
    ok "LXC: $(lxc --version 2>/dev/null || echo 'installed')"

    # Initialise LXD if not already done
    if ! lxc storage list >/dev/null 2>&1; then
        info "Running 'lxd init --auto'..."
        lxd init --auto || {
            error "'lxd init' failed. Please run it manually and re-run this installer."
            exit 1
        }
    fi
    ok "LXD initialised."

    # Detect default storage pool
    DETECTED_POOL="$(lxc storage list --format=csv 2>/dev/null | cut -d',' -f1 | head -1 || echo 'default')"
    [[ -z "${DETECTED_POOL}" ]] && DETECTED_POOL="default"

    line

    # Install tmate on host
    if ! command -v tmate >/dev/null 2>&1; then
        info "Installing tmate..."
        snap install tmate 2>/dev/null || apt install -y tmate 2>/dev/null || \
            warn "tmate not installed — the bot installs it inside containers on demand."
    else
        ok "tmate: $(tmate -V 2>/dev/null | head -1)"
    fi
fi

# =========================================================
# INSTALL DOCKER (if chosen and not present)
# =========================================================

if [[ "${CHOSEN_BACKEND}" == "docker" ]]; then
    if ! command -v docker >/dev/null 2>&1; then
        info "Installing Docker..."
        if curl -fsSL https://get.docker.com -o /tmp/get-docker.sh; then
            sh /tmp/get-docker.sh || {
                warn "Docker script failed — trying apt install docker.io..."
                apt install -y docker.io
            }
            rm -f /tmp/get-docker.sh
        else
            apt install -y docker.io
        fi
        systemctl enable docker >/dev/null 2>&1 || true
        systemctl start  docker >/dev/null 2>&1 || true
        sleep 3
    fi

    if ! command -v docker >/dev/null 2>&1; then
        error "Docker still not found after installation. Aborting."
        exit 1
    fi

    if ! docker info >/dev/null 2>&1; then
        warn "Docker daemon not responding — attempting start..."
        systemctl start docker >/dev/null 2>&1 || service docker start >/dev/null 2>&1 || true
        sleep 5
        if ! docker info >/dev/null 2>&1; then
            error "Docker daemon is not running. Check: systemctl status docker"
            exit 1
        fi
    fi
    ok "Docker: $(docker --version)"

    # Docker Compose (for optional bot-container deployment)
    if docker compose version >/dev/null 2>&1; then
        COMPOSE_CMD="docker compose"
    elif command -v docker-compose >/dev/null 2>&1; then
        COMPOSE_CMD="docker-compose"
    else
        apt install -y docker-compose-plugin 2>/dev/null || true
        if docker compose version >/dev/null 2>&1; then
            COMPOSE_CMD="docker compose"
        fi
    fi
    [[ -n "${COMPOSE_CMD}" ]] && ok "Docker Compose: ${COMPOSE_CMD}"

    # Enable iptables forwarding — required for port-forward rules
    info "Enabling IP forwarding for port forwarding..."
    echo 1 > /proc/sys/net/ipv4/ip_forward 2>/dev/null || true
    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf 2>/dev/null || true
    iptables -t nat -A POSTROUTING -j MASQUERADE 2>/dev/null || true
    ok "IP forwarding enabled."

    DETECTED_POOL="default"   # unused for docker, but referenced later
fi

line

# =========================================================
# ENSURE PYTHON 3.11+
# =========================================================

PYTHON_BIN=""
for _py in python3.13 python3.12 python3.11; do
    if command -v "${_py}" >/dev/null 2>&1; then
        PYTHON_BIN="${_py}"
        break
    fi
done

if [[ -z "${PYTHON_BIN}" ]]; then
    info "Python 3.11+ not found — attempting to install..."
    # Try system package first (works on Debian 12+ with backports, Ubuntu 22.04+)
    apt install -y python3.11 python3.11-venv python3.11-dev 2>/dev/null && \
        command -v python3.11 >/dev/null 2>&1 && PYTHON_BIN="python3.11"

    # If still missing and we're on Ubuntu, try deadsnakes PPA
    if [[ -z "${PYTHON_BIN}" ]] && grep -qi "ubuntu" /etc/os-release 2>/dev/null; then
        info "Trying deadsnakes PPA (Ubuntu)..."
        apt install -y software-properties-common
        add-apt-repository -y ppa:deadsnakes/ppa
        apt update -y
        apt install -y python3.11 python3.11-venv python3.11-dev
        command -v python3.11 >/dev/null 2>&1 && PYTHON_BIN="python3.11"
    fi

    # Last resort: use whatever python3 is available (3.10+ is usually fine)
    if [[ -z "${PYTHON_BIN}" ]]; then
        warn "Could not install Python 3.11. Falling back to system python3 — upgrade manually if the bot errors."
    fi
fi

[[ -z "${PYTHON_BIN}" ]] && PYTHON_BIN="python3"

ok "Python: $("${PYTHON_BIN}" --version 2>&1)  (${PYTHON_BIN})"

line

# =========================================================
# DOWNLOAD BOT FILES
# =========================================================

info "Downloading bot files..."
rm -f "${BOT_ARCHIVE_NAME}"
curl -L --fail --retry 5 --retry-delay 3 --progress-bar -o "${BOT_ARCHIVE_NAME}" "${BOT_ARCHIVE_URL}"

if [[ ! -s "${BOT_ARCHIVE_NAME}" ]]; then
    error "Download failed. ${BOT_ARCHIVE_NAME} is empty or missing."
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

CONTENTS=("${INSTALL_DIR}"/*)
if [[ ${#CONTENTS[@]} -eq 1 && -d "${CONTENTS[0]}" ]]; then
    mv "${CONTENTS[0]}"/* "${INSTALL_DIR}"/
    rmdir "${CONTENTS[0]}"
fi

cd "${INSTALL_DIR}"

if [[ ! -f bot.py ]]; then
    error "bot.py not found in the downloaded package — archive may be corrupted."
    exit 1
fi

mkdir -p data
ok "Bot files extracted to ./${INSTALL_DIR}"

line

# =========================================================
# PYTHON VIRTUAL ENVIRONMENT
# =========================================================

info "Creating Python virtual environment..."
"${PYTHON_BIN}" -m venv venv
source venv/bin/activate

info "Upgrading pip..."
pip install --upgrade pip --quiet

info "Installing Python dependencies..."
pip install -r requirements.txt

if ! python -c "import discord" 2>/dev/null; then
    error "discord.py failed to install. Check internet connection and Python version."
    deactivate; exit 1
fi
deactivate
ok "Python virtual environment ready."

line

# =========================================================
# CONFIGURE .env
# =========================================================

if [[ -f .env.example ]]; then
    cp .env.example .env
    ok "Created .env from .env.example."
else
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
read -rp "$(echo -e "${YELLOW}Enter Flask secret key (strong random string): ${NC}")" FLASK_SECRET_INPUT
echo

# Trim whitespace
BOT_TOKEN="$(echo -n "${BOT_TOKEN}"         | xargs)"
ADMIN_IDS_INPUT="$(echo -n "${ADMIN_IDS_INPUT}" | xargs)"
SERVER_IP_INPUT="$(echo -n "${SERVER_IP_INPUT}" | xargs)"
BOT_PREFIX_INPUT="$(echo -n "${BOT_PREFIX_INPUT}" | xargs)"
FLASK_PORT_INPUT="$(echo -n "${FLASK_PORT_INPUT}" | xargs)"
FLASK_SECRET_INPUT="$(echo -n "${FLASK_SECRET_INPUT}" | xargs)"

# Validate
[[ -z "${BOT_TOKEN}" ]]         && { error "Bot Token cannot be empty."; exit 1; }
[[ -z "${ADMIN_IDS_INPUT}" ]]   && { error "Admin IDs cannot be empty."; exit 1; }
if [[ -z "${FLASK_SECRET_INPUT}" || "${FLASK_SECRET_INPUT}" == "change-me-to-something-random" ]]; then
    error "FLASK_SECRET must be a real strong key — the default placeholder is rejected by the bot."
    exit 1
fi

# Defaults
[[ -z "${BOT_PREFIX_INPUT}" ]]  && BOT_PREFIX_INPUT="1"
[[ -z "${FLASK_PORT_INPUT}" ]]  && FLASK_PORT_INPUT="5000"

# Auto-detect IP
if [[ -z "${SERVER_IP_INPUT}" ]]; then
    info "Auto-detecting public IP..."
    SERVER_IP_INPUT="$(curl -s --max-time 5 https://api.ipify.org 2>/dev/null \
        || curl -s --max-time 5 https://ifconfig.me 2>/dev/null \
        || hostname -I 2>/dev/null | awk '{print $1}' \
        || echo "0.0.0.0")"
    info "Detected: ${SERVER_IP_INPUT}"
fi

update_env_var() {
    local key="$1" value="$2"
    if grep -q "^${key}=" .env; then
        sed -i "s|^${key}=.*|${key}=${value}|" .env
    else
        echo "${key}=${value}" >> .env
    fi
}

update_env_var "DISCORD_TOKEN"          "${BOT_TOKEN}"
update_env_var "ADMIN_IDS"              "${ADMIN_IDS_INPUT}"
update_env_var "SERVER_IP"              "${SERVER_IP_INPUT}"
update_env_var "BOT_PREFIX"             "${BOT_PREFIX_INPUT}"
update_env_var "FLASK_PORT"             "${FLASK_PORT_INPUT}"
update_env_var "FLASK_SECRET"           "${FLASK_SECRET_INPUT}"
update_env_var "FLASK_ENABLED"          "1"
update_env_var "BACKEND"                "${CHOSEN_BACKEND}"
update_env_var "DEFAULT_STORAGE_POOL"   "${DETECTED_POOL}"
update_env_var "DB_PATH"                "data/bot.db"

ok "Configuration saved to .env  (BACKEND=${CHOSEN_BACKEND})"

line

# =========================================================
# BUILD DOCKER VPS BASE IMAGES  (Docker backend only)
# =========================================================

if [[ "${CHOSEN_BACKEND}" == "docker" && -f Dockerfile.vps ]]; then
    info "Building Docker VPS base images (Ubuntu + Debian)..."
    info "This can take several minutes on the first run..."
    echo

    BASE_IMAGES=(
        "ubuntu:20.04"
        "ubuntu:22.04"
        "ubuntu:24.04"
        "debian:11"
        "debian:12"
    )
    BUILT=()
    FAILED=()

    for BASE in "${BASE_IMAGES[@]}"; do
        TAG="dfxvps:$(echo "${BASE}" | tr ':' '-')"
        info "Building ${TAG} from ${BASE}..."
        if docker build --build-arg BASE="${BASE}" -f Dockerfile.vps -t "${TAG}" . \
            >"/tmp/dfxbuild-$(echo "${TAG}" | tr '/:' '_').log" 2>&1; then
            ok "Built ${TAG}"
            BUILT+=("${TAG}")
        else
            warn "Failed to build ${TAG} — will pull base image on demand instead."
            FAILED+=("${BASE}")
        fi
    done

    echo
    [[ ${#BUILT[@]} -gt 0 ]]  && ok  "Pre-built: ${BUILT[*]}"
    [[ ${#FAILED[@]} -gt 0 ]] && warn "Skipped (will pull on demand): ${FAILED[*]}"
    line
fi

# =========================================================
# INSTALL SYSTEMD SERVICE
# =========================================================

info "Installing systemd service (${SERVICE_NAME})..."

BOT_INSTALL_PATH="$(pwd)"
VENV_PYTHON="${BOT_INSTALL_PATH}/venv/bin/python"

cat > "/etc/systemd/system/${SERVICE_NAME}.service" << EOF
[Unit]
Description=DFX Cloud Bot (${CHOSEN_BACKEND^^} Edition)
After=network.target snapd.service docker.service

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
    ok "Bot service started."
else
    warn "Bot service may not have started yet — check: journalctl -u ${SERVICE_NAME} -n 50"
fi

line

# =========================================================
# CREATE GLOBAL "dfxbot" CLI
# =========================================================

info "Installing 'dfxbot' command..."

cat > /usr/local/bin/dfxbot << EOF
#!/usr/bin/env bash
set -uo pipefail

BOT_DIR="${BOT_INSTALL_PATH}"
SERVICE="${SERVICE_NAME}"
BACKEND="${CHOSEN_BACKEND}"
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
        curl -L --fail --retry 5 --retry-delay 3 --progress-bar \
            -o "/tmp/\${ARCHIVE_NAME}" "\${ARCHIVE_URL}"
        TMP_DIR="\$(mktemp -d)"
        tar -xzf "/tmp/\${ARCHIVE_NAME}" -C "\${TMP_DIR}"
        CONTENTS=("\${TMP_DIR}"/*)
        if [[ \${#CONTENTS[@]} -eq 1 && -d "\${CONTENTS[0]}" ]]; then
            SRC="\${CONTENTS[0]}"
        else
            SRC="\${TMP_DIR}"
        fi
        rsync -a --exclude '.env' --exclude 'data' --exclude 'venv' \
            "\${SRC}/" "\${BOT_DIR}/" 2>/dev/null \
            || cp -rf "\${SRC}/." "\${BOT_DIR}/"
        rm -rf "\${TMP_DIR}" "/tmp/\${ARCHIVE_NAME}"
        "\${BOT_DIR}/venv/bin/pip" install -r "\${BOT_DIR}/requirements.txt" --quiet
        systemctl restart "\${SERVICE}"
        echo "[OK] Bot updated and restarted."
        ;;
    edit-env)
        \${EDITOR:-nano} "\${BOT_DIR}/.env"
        echo "[INFO] Restart with 'dfxbot restart' to apply changes."
        ;;
    update-deps)
        "\${BOT_DIR}/venv/bin/pip" install --upgrade \
            -r "\${BOT_DIR}/requirements.txt"
        systemctl restart "\${SERVICE}"
        echo "[OK] Dependencies upgraded and bot restarted."
        ;;
    backend)
        echo "Active backend: \${BACKEND}"
        if [[ "\${BACKEND}" == "docker" ]]; then
            echo
            docker ps --filter "name=dfx-" --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"
        else
            lxc list 2>/dev/null || echo "(lxc not on PATH)"
        fi
        ;;
    build-images)
        if [[ "\${BACKEND}" != "docker" ]]; then
            echo "[INFO] build-images only applies to the Docker backend."
            exit 0
        fi
        if [[ ! -f "\${BOT_DIR}/Dockerfile.vps" ]]; then
            echo "[ERROR] Dockerfile.vps not found."
            exit 1
        fi
        for BASE in ubuntu:20.04 ubuntu:22.04 ubuntu:24.04 debian:11 debian:12; do
            TAG="dfxvps:\$(echo "\${BASE}" | tr ':' '-')"
            echo "[INFO] Building \${TAG}..."
            docker build --build-arg BASE="\${BASE}" \
                -f "\${BOT_DIR}/Dockerfile.vps" -t "\${TAG}" "\${BOT_DIR}" \
                && echo "[OK] \${TAG}" || echo "[WARN] Failed: \${TAG}"
        done
        ;;
    list-images)
        if [[ "\${BACKEND}" != "docker" ]]; then
            echo "[INFO] list-images only applies to the Docker backend."
            exit 0
        fi
        for BASE in ubuntu:20.04 ubuntu:22.04 ubuntu:24.04 debian:11 debian:12; do
            TAG="dfxvps:\$(echo "\${BASE}" | tr ':' '-')"
            if docker image inspect "\${TAG}" >/dev/null 2>&1; then
                echo "[BUILT]   \${TAG}"
            else
                echo "[MISSING] \${TAG}"
            fi
        done
        ;;
    uninstall)
        systemctl stop    "\${SERVICE}" 2>/dev/null || true
        systemctl disable "\${SERVICE}" 2>/dev/null || true
        rm -f "/etc/systemd/system/\${SERVICE}.service"
        systemctl daemon-reload
        rm -f /usr/local/bin/dfxbot
        echo "[OK] Service uninstalled. Files remain in \${BOT_DIR}."
        ;;
    *)
        echo "DFX Cloud Bot control command  (backend: \${BACKEND})"
        echo
        echo "Usage: dfxbot {start|stop|restart|status|logs|update|edit-env|update-deps|backend|build-images|list-images|uninstall}"
        echo
        echo "  start          Start the bot"
        echo "  stop           Stop the bot"
        echo "  restart        Restart the bot"
        echo "  status         Show service status"
        echo "  logs           Stream live logs"
        echo "  update         Pull latest package and restart"
        echo "  edit-env       Edit the .env file"
        echo "  update-deps    Upgrade Python packages and restart"
        echo "  backend        Show active backend + running VPS containers"
        echo "  build-images   (Docker) Pre-build VPS base images"
        echo "  list-images    (Docker) List pre-built VPS images"
        echo "  uninstall      Remove the service"
        ;;
esac
EOF

chmod +x /usr/local/bin/dfxbot
ok "'dfxbot' installed to /usr/local/bin/dfxbot"

line

# =========================================================
# FINISH
# =========================================================

echo -e "${GREEN}"
cat << EOF

╔══════════════════════════════════════════════════════╗
║          DFX CLOUD BOT IS NOW RUNNING  ⚡             ║
╚══════════════════════════════════════════════════════╝

INSTALL DIRECTORY : ${BOT_INSTALL_PATH}
BACKEND           : ${CHOSEN_BACKEND^^}
FLASK PANEL       : http://${SERVER_IP_INPUT}:${FLASK_PORT_INPUT}

════════════════════════════════════════════════════════

QUICK COMMANDS (run from anywhere)

dfxbot start          # Start the bot
dfxbot stop           # Stop the bot
dfxbot restart        # Restart the bot
dfxbot status         # Show service status
dfxbot logs           # View live logs  (Ctrl+C to exit)
dfxbot update         # Pull latest package and restart
dfxbot edit-env       # Edit .env configuration
dfxbot update-deps    # Upgrade Python dependencies
dfxbot backend        # Show backend + running VPS containers
dfxbot build-images   # (Docker) Pre-build VPS base images
dfxbot list-images    # (Docker) List built VPS images
dfxbot uninstall      # Remove the service

════════════════════════════════════════════════════════

NEXT STEPS

1.  Check the bot is online in Discord
2.  Run:  dfxbot logs   to see startup output
3.  Web panel:  http://${SERVER_IP_INPUT}:${FLASK_PORT_INPUT}
    Password = the FLASK_SECRET you entered above

════════════════════════════════════════════════════════

EOF
echo -e "${NC}"
