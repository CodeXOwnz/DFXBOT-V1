#!/usr/bin/env bash

# =========================================================
# DFX Cloud — VPS base image builder
# =========================================================
# Builds one Docker image per OS listed in bot.py's OS_IMAGES catalogue,
# each with tmate + OpenSSH already installed (see Dockerfile.vps).
# Run this once after installing the bot, and again any time you want
# to refresh the base images (e.g. "dfxbot build-images").
# =========================================================

set -uo pipefail

RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
CYAN="\e[1;36m"
NC="\e[0m"

info() { echo -e "${CYAN}[INFO]${NC} $1"; }
ok()   { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error(){ echo -e "${RED}[ERROR]${NC} $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKERFILE="${SCRIPT_DIR}/Dockerfile.vps"

if ! command -v docker >/dev/null 2>&1; then
    error "Docker is not installed. Run installer.sh first."
    exit 1
fi

if [[ ! -f "${DOCKERFILE}" ]]; then
    error "Dockerfile.vps not found at ${DOCKERFILE}"
    exit 1
fi

# base image -> tag suffix, must match the keys used in bot.py's OS_IMAGES
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

FAILED=()
BUILT=()

echo
info "Building ${#BASE_IMAGES[@]} VPS base images. This can take a while the first time..."
echo

for BASE in "${BASE_IMAGES[@]}"; do
    TAG="$(echo "${BASE}" | tr ':' '-')-with-tmate"
    info "Building ${TAG} (from ${BASE})..."

    if docker build --build-arg BASE_IMAGE="${BASE}" -f "${DOCKERFILE}" -t "${TAG}" "${SCRIPT_DIR}" >/tmp/dfx-build-"$(echo "${TAG}" | tr '/' '_')".log 2>&1; then
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
    exit 0
else
    echo
    error "Some images failed to build: ${FAILED[*]}"
    warn "The bot will still work for OS versions that built successfully."
    exit 1
fi
