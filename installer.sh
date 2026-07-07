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

BOT_ARCHIVE_URL="https://files.catbox.moe/ddeaey.gz"
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

    if ! curl -fsSL https://get.docker.com -o /tmp/get-docker.sh; then
        error "Could not download the Docker install script. Check your internet connection."
        exit 1
    fi

    if ! sh /tmp/get-docker.sh; then
        rm -f /tmp/get-docker.sh
        error "Docker install script failed. Falling back to apt install..."
        apt update -y
        apt install -y docker.io || {
            error "Docker installation failed. Please install Docker manually and re-run this script."
            exit 1
        }
    fi
    rm -f /tmp/get-docker.sh

    systemctl enable docker >/dev/null 2>&1 || true
    systemctl start docker >/dev/null 2>&1 || true
fi

# Re-check after install attempts — this is the actual fix for
# "[Errno 2] No such file or directory: 'docker'" style errors: the
# script must hard-stop here instead of silently continuing without
# a working docker binary.
if ! command -v docker >/dev/null 2>&1; then
    error "Docker still not found on PATH after installation. Aborting."
    exit 1
fi

# Make sure the Docker daemon is actually reachable, not just installed.
if ! docker info >/dev/null 2>&1; then
    warn "Docker daemon not responding yet, starting it..."
    systemctl start docker >/dev/null 2>&1 || service docker start >/dev/null 2>&1 || true
    sleep 3
    if ! docker info >/dev/null 2>&1; then
        error "Docker daemon is not running. Try 'systemctl status docker' to diagnose."
        exit 1
    fi
fi

ok "Docker is installed and running."

if docker compose version >/dev/null 2>&1; then
    COMPOSE_CMD="docker compose"
elif command -v docker-compose >/dev/null 2>&1; then
    COMPOSE_CMD="docker-compose"
else
    info "Docker Compose plugin not found. Installing..."
    apt install -y docker-compose-plugin
    if docker compose version >/dev/null 2>&1; then
        COMPOSE_CMD="docker compose"
    elif command -v docker-compose >/dev/null 2>&1; then
        COMPOSE_CMD="docker-compose"
    else
        error "Docker Compose could not be installed. Aborting."
        exit 1
    fi
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
# BUILD VPS BASE IMAGES (ALL UBUNTU + DEBIAN VERSIONS)
# =========================================================

_build_vps_images() {
    local DOCKERFILE="${1}/Dockerfile.vps"
    local SCRIPT_DIR="${1}"

    if [[ ! -f "${DOCKERFILE}" ]]; then
        warn "Dockerfile.vps not found at ${DOCKERFILE} — skipping VPS image build."
        return 1
    fi

    local BASE_IMAGES=(
        "ubuntu:16.04"
        "ubuntu:18.04"
        "ubuntu:20.04"
        "ubuntu:22.04"
        "ubuntu:24.04"
        "debian:8"
        "debian:9"
        "debian:10"
        "debian:11"
        "debian:12"
    )

    local FAILED=()
    local BUILT=()

    echo
    info "Building ${#BASE_IMAGES[@]} VPS base images. This can take a while the first time..."
    echo

    for BASE in "${BASE_IMAGES[@]}"; do
        local TAG
        TAG="$(echo "${BASE}" | tr ':' '-')-with-tmate"
        info "Building ${TAG} (from ${BASE})..."

        if docker build --build-arg BASE_IMAGE="${BASE}" -f "${DOCKERFILE}" -t "${TAG}" "${SCRIPT_DIR}" \
            >"/tmp/dfx-build-$(echo "${TAG}" | tr '/' '_').log" 2>&1; then
            ok "Built ${TAG}"
            BUILT+=("${TAG}")
        else
            error "Failed to build ${TAG} (see /tmp/dfx-build-${TAG}.log for details)"
            FAILED+=("${BASE}")
        fi
    done

    echo
    if [[ ${#BUILT[@]} -gt 0 ]]; then
        ok "Successfully built: ${BUILT[*]}"
    fi

    if [[ ${#FAILED[@]} -eq 0 ]]; then
        echo
        ok "All VPS base images built successfully."
        return 0
    else
        echo
        error "Some images failed to build: ${FAILED[*]}"
        warn "The bot will still work for OS versions that built successfully."
        return 1
    fi
}

info "Building VPS base images for every supported Ubuntu/Debian version..."
info "(These images are pre-baked with tmate + OpenSSH — this can take several minutes.)"

if _build_vps_images "$(pwd)"; then
    ok "VPS base images built successfully."
else
    warn "Some VPS base images failed to build. The bot will still run;"
    warn "re-run 'dfxbot build-images' later to retry the failed ones."
fi

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
BASE_IMAGES=(
    "ubuntu:16.04"
    "ubuntu:18.04"
    "ubuntu:20.04"
    "ubuntu:22.04"
    "ubuntu:24.04"
    "debian:8"
    "debian:9"
    "debian:10"
    "debian:11"
    "debian:12"
)

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
    build-images)
        DOCKERFILE="\${BOT_DIR}/Dockerfile.vps"
        if [[ ! -f "\${DOCKERFILE}" ]]; then
            echo "[ERROR] Dockerfile.vps not found at \${DOCKERFILE}"
            exit 1
        fi
        if ! command -v docker >/dev/null 2>&1; then
            echo "[ERROR] Docker is not installed."
            exit 1
        fi
        _FAILED=()
        _BUILT=()
        echo
        echo "[INFO] Building \${#BASE_IMAGES[@]} VPS base images..."
        echo
        for _BASE in "\${BASE_IMAGES[@]}"; do
            _TAG="\$(echo "\${_BASE}" | tr ':' '-')-with-tmate"
            echo "[INFO] Building \${_TAG} (from \${_BASE})..."
            if docker build --build-arg BASE_IMAGE="\${_BASE}" -f "\${DOCKERFILE}" -t "\${_TAG}" "\${BOT_DIR}" \
                >"/tmp/dfx-build-\$(echo "\${_TAG}" | tr '/' '_').log" 2>&1; then
                echo "[OK]   Built \${_TAG}"
                _BUILT+=("\${_TAG}")
            else
                echo "[ERROR] Failed to build \${_TAG} (see /tmp/dfx-build-\${_TAG}.log)"
                _FAILED+=("\${_BASE}")
            fi
        done
        echo
        [[ \${#_BUILT[@]} -gt 0 ]] && echo "[OK] Successfully built: \${_BUILT[*]}"
        if [[ \${#_FAILED[@]} -eq 0 ]]; then
            echo "[OK] All VPS base images built successfully."
        else
            echo "[ERROR] Some images failed: \${_FAILED[*]}"
            echo "[WARNING] The bot will still work for OS versions that built OK."
            exit 1
        fi
        ;;
    list-images)
        for BASE in "\${BASE_IMAGES[@]}"; do
            TAG="\$(echo "\${BASE}" | tr ':' '-')-with-tmate"
            if docker image inspect "\${TAG}" >/dev/null 2>&1; then
                echo "[BUILT]   \${TAG}"
            else
                echo "[MISSING] \${TAG}"
            fi
        done
        ;;
    *)
        echo "DFX Cloud Bot control command"
        echo
        echo "Usage: dfxbot {start|stop|restart|status|logs|update|edit-env|build-images|list-images|uninstall}"
        echo
        echo "  start         Start the bot container"
        echo "  stop          Stop the bot container"
        echo "  restart       Restart the bot container"
        echo "  status        Show container status"
        echo "  logs          Stream live logs"
        echo "  update        Download the latest bot package and rebuild"
        echo "  edit-env      Edit the .env configuration file"
        echo "  build-images  (Re)build all Ubuntu/Debian VPS base images"
        echo "  list-images   Show which VPS base images are built"
        echo "  uninstall     Stop and remove the bot container"
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

dfxbot start          # Start the bot
dfxbot stop           # Stop the bot
dfxbot restart        # Restart the bot
dfxbot status         # Show container status
dfxbot logs           # View live logs
dfxbot update         # Pull latest package and rebuild
dfxbot edit-env       # Edit .env configuration
dfxbot build-images   # (Re)build all Ubuntu/Debian VPS base images
dfxbot list-images    # Show which VPS base images are built
dfxbot uninstall      # Stop and remove the container

════════════════════════════════════════════════════════

VPS BASE IMAGES (Ubuntu 16.04–24.04, Debian 8–12, tmate preinstalled)

ubuntu-16.04-with-tmate   ubuntu-18.04-with-tmate
ubuntu-20.04-with-tmate   ubuntu-22.04-with-tmate
ubuntu-24.04-with-tmate   debian-8-with-tmate
debian-9-with-tmate       debian-10-with-tmate
debian-11-with-tmate      debian-12-with-tmate

════════════════════════════════════════════════════════

RAW CONTAINER COMMANDS (run from ${INSTALL_DIR}/)

${COMPOSE_CMD} logs -f        # View live logs
${COMPOSE_CMD} restart        # Restart the bot
${COMPOSE_CMD} stop           # Stop the bot
${COMPOSE_CMD} up -d --build  # Rebuild and start after updates

════════════════════════════════════════════════════════

EOF
echo -e "${NC}"
