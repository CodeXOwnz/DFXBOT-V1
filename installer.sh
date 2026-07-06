#!/usr/bin/env bash

# =========================================================
# DFX CLOUD BOT INSTALLER
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

BOT_ZIP_URL="https://files.catbox.moe/gn8bc4.zip"
BOT_ZIP_NAME="dfxcloudbot.zip"

INSTALL_DIR="dfxcloudbot"

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

              DFX CLOUD DISCORD BOT INSTALLER

EOF
echo -e "${NC}"

line

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
# INSTALL DEPENDENCIES
# =========================================================

info "Installing dependencies..."

apt update -y
apt install -y python3 python3-pip python3-venv unzip curl wget

ok "Dependencies installed."

line

# =========================================================
# DOWNLOAD BOT FILES
# =========================================================

info "Downloading bot files..."

rm -f "${BOT_ZIP_NAME}"

curl -L --fail --retry 5 --retry-delay 3 --progress-bar -o "${BOT_ZIP_NAME}" "${BOT_ZIP_URL}"

if [[ ! -s "${BOT_ZIP_NAME}" ]]; then
    error "Download failed. ${BOT_ZIP_NAME} is missing or empty."
    exit 1
fi

ok "Downloaded ${BOT_ZIP_NAME} successfully."

line

# =========================================================
# EXTRACT BOT FILES
# =========================================================

info "Extracting bot files..."

rm -rf "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}"

unzip -o "${BOT_ZIP_NAME}" -d "${INSTALL_DIR}" >/dev/null

# If the zip extracted into a single nested folder, move its contents up
CONTENTS=("${INSTALL_DIR}"/*)
if [[ ${#CONTENTS[@]} -eq 1 && -d "${CONTENTS[0]}" ]]; then
    mv "${CONTENTS[0]}"/* "${INSTALL_DIR}"/
    rmdir "${CONTENTS[0]}"
fi

cd "${INSTALL_DIR}"

ok "Bot files extracted to ./${INSTALL_DIR}"

line

# =========================================================
# CREATE VIRTUAL ENVIRONMENT
# =========================================================

info "Creating virtual environment..."

python3 -m venv venv

# shellcheck disable=SC1091
source venv/bin/activate

ok "Virtual environment created and activated."

line

# =========================================================
# INSTALL PYTHON DEPENDENCIES
# =========================================================

if [[ -f requirements.txt ]]; then
    info "Installing Python dependencies..."
    pip install --upgrade pip >/dev/null
    pip install -r requirements.txt
    ok "Python dependencies installed."
else
    warn "requirements.txt not found. Skipping dependency installation."
fi

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
# START THE BOT
# =========================================================

info "Starting the bot..."
line

python3 bot.py
