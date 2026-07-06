#!/usr/bin/env bash

# =========================================================
# DFX CLOUD BOT INSTALLER (Docker Edition)
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

BOT_ARCHIVE_URL="https://files.catbox.moe/am3dy6.gz"
BOT_ARCHIVE_NAME="dfxcloudbot.tar.gz"

INSTALL_DIR="dfxcloudbot"
COMPOSE_CMD=""

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

           DFX CLOUD DISCORD BOT INSTALLER (DOCKER)

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
apt install -y curl wget tar rsync ca-certificates gnupg lsb-release

ok "Base dependencies installed."

line

# =========================================================
# INSTALL DOCKER (IF NOT ALREADY INSTALLED)
# =========================================================

if ! command -v docker >/dev/null 2>&1; then
    info "Docker not found. Installing Docker..."
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    sh /tmp/get-docker.sh
    rm -f /tmp/get-docker.sh
    systemctl enable docker >/dev/null 2>&1 || true
    systemctl start docker >/dev/null 2>&1 || true
    ok "Docker installed."
else
    ok "Docker is already installed."
fi

if docker compose version >/dev/null 2>&1; then
    COMPOSE_CMD="docker compose"
elif command -v docker-compose >/dev/null 2>&1; then
    COMPOSE_CMD="docker-compose"
else
    info "Docker Compose plugin not found. Installing..."
    apt install -y docker-compose-plugin
    COMPOSE_CMD="docker compose"
fi

ok "Using compose command: ${COMPOSE_CMD}"

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

if [[ ! -f Dockerfile || ! -f docker-compose.yml ]]; then
    error "Dockerfile or docker-compose.yml not found in the downloaded package."
    exit 1
fi

ok "Bot files extracted to ./${INSTALL_DIR}"

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
read -rp "$(echo -e "${YELLOW}Enter Admin ID: ${NC}")" ADMIN_ID
read -rp "$(echo -e "${YELLOW}Enter Bot Token: ${NC}")" BOT_TOKEN
echo

# Trim leading/trailing whitespace that can sneak in when pasting
ADMIN_ID="$(echo -n "${ADMIN_ID}" | xargs)"
BOT_TOKEN="$(echo -n "${BOT_TOKEN}" | xargs)"

if [[ -z "${BOT_TOKEN}" ]]; then
    error "Bot Token cannot be empty."
    exit 1
fi

update_env_var() {
    local key="$1"
    local value="$2"

    if grep -q "^${key}=" .env; then
        sed -i "s|^${key}=.*|${key}=${value}|" .env
    else
        echo "${key}=${value}" >> .env
    fi
}

# bot.py reads the token from DISCORD_TOKEN, so it must be saved under that
# exact key. ADMIN_ID is written under both common key names so it works
# regardless of which one bot.py expects.
update_env_var "ADMIN_ID" "${ADMIN_ID}"
update_env_var "ADMIN_IDS" "${ADMIN_ID}"
update_env_var "DISCORD_TOKEN" "${BOT_TOKEN}"

ok "Admin ID and Bot Token saved to .env"

line

# =========================================================
# BUILD AND START THE BOT CONTAINER
# =========================================================

info "Building and starting the bot container..."

${COMPOSE_CMD} up -d --build

if [[ $? -ne 0 ]]; then
    error "Failed to start the bot container. Check the logs above."
    exit 1
fi

ok "Bot container started successfully."

line

# =========================================================
# CREATE GLOBAL "dfxbot" CLI COMMAND
# =========================================================

info "Setting up the 'dfxbot' command..."

BOT_INSTALL_PATH="$(pwd)"

cat > /usr/local/bin/dfxbot << EOF
#!/usr/bin/env bash
set -uo pipefail

BOT_DIR="${BOT_INSTALL_PATH}"
COMPOSE_CMD="${COMPOSE_CMD}"
ARCHIVE_URL="${BOT_ARCHIVE_URL}"
ARCHIVE_NAME="${BOT_ARCHIVE_NAME}"

cd "\${BOT_DIR}" || { echo "Bot directory not found: \${BOT_DIR}"; exit 1; }

case "\${1:-}" in
    start)
        \${COMPOSE_CMD} up -d
        ;;
    stop)
        \${COMPOSE_CMD} stop
        ;;
    restart)
        \${COMPOSE_CMD} restart
        ;;
    status)
        \${COMPOSE_CMD} ps
        ;;
    logs)
        \${COMPOSE_CMD} logs -f
        ;;
    update)
        echo "Downloading latest bot package..."
        curl -L --fail --retry 5 --retry-delay 3 --progress-bar -o "\${ARCHIVE_NAME}" "\${ARCHIVE_URL}"
        TMP_DIR="\$(mktemp -d)"
        tar -xzf "\${ARCHIVE_NAME}" -C "\${TMP_DIR}"
        CONTENTS=("\${TMP_DIR}"/*)
        if [[ \${#CONTENTS[@]} -eq 1 && -d "\${CONTENTS[0]}" ]]; then
            SRC_DIR="\${CONTENTS[0]}"
        else
            SRC_DIR="\${TMP_DIR}"
        fi
        rsync -a --exclude '.env' --exclude 'data' "\${SRC_DIR}/" "\${BOT_DIR}/" 2>/dev/null || cp -rf "\${SRC_DIR}/." "\${BOT_DIR}/"
        rm -rf "\${TMP_DIR}" "\${ARCHIVE_NAME}"
        \${COMPOSE_CMD} up -d --build
        echo "Bot updated and restarted."
        ;;
    uninstall)
        \${COMPOSE_CMD} down
        echo "Bot container stopped and removed. Files remain in \${BOT_DIR}."
        ;;
    edit-env)
        \${EDITOR:-nano} "\${BOT_DIR}/.env"
        echo "Restart with 'dfxbot restart' to apply changes."
        ;;
    *)
        echo "DFX Cloud Bot control command"
        echo
        echo "Usage: dfxbot {start|stop|restart|status|logs|update|edit-env|uninstall}"
        echo
        echo "  start      Start the bot container"
        echo "  stop       Stop the bot container"
        echo "  restart    Restart the bot container"
        echo "  status     Show container status"
        echo "  logs       Stream live logs"
        echo "  update     Download the latest bot package and rebuild"
        echo "  edit-env   Edit the .env configuration file"
        echo "  uninstall  Stop and remove the bot container"
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
║             DFX CLOUD BOT IS NOW RUNNING              ║
╚══════════════════════════════════════════════════════╝

INSTALL DIRECTORY : ${BOT_INSTALL_PATH}

════════════════════════════════════════════════════════

QUICK COMMANDS (run from anywhere)

dfxbot start       # Start the bot
dfxbot stop        # Stop the bot
dfxbot restart     # Restart the bot
dfxbot status      # Show container status
dfxbot logs        # View live logs
dfxbot update      # Pull latest package and rebuild
dfxbot edit-env    # Edit .env configuration
dfxbot uninstall   # Stop and remove the container

════════════════════════════════════════════════════════

RAW CONTAINER COMMANDS (run from ${INSTALL_DIR}/)

${COMPOSE_CMD} logs -f        # View live logs
${COMPOSE_CMD} restart        # Restart the bot
${COMPOSE_CMD} stop           # Stop the bot
${COMPOSE_CMD} up -d --build  # Rebuild and start after updates

════════════════════════════════════════════════════════

EOF
echo -e "${NC}"
