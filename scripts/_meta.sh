#!/bin/bash

set -e

# Function to print messages
info() {
    echo -e "\e[1;34m[INFO]\e[0m $1"
}

error() {
    echo -e "\e[1;31m[ERROR]\e[0m $1"
}

success() {
    echo -e "\e[1;32m[SUCCESS]\e[0m $1"
}

# When true, smart guards are bypassed and everything is (re)installed.
FORCE=${FORCE:-false}

# Returns success if a command is available on PATH.
has_cmd() { command -v "$1" &>/dev/null; }

# Returns success if a dpkg package is installed.
pkg_installed() { dpkg -s "$1" &>/dev/null; }

# Install only the apt packages that aren't already present (unless FORCE).
apt_install_missing() {
    if $FORCE; then
        sudo apt install -y "$@"
        return
    fi
    local missing=()
    for pkg in "$@"; do
        pkg_installed "$pkg" || missing+=("$pkg")
    done
    if [ ${#missing[@]} -eq 0 ]; then
        info "Already installed, skipping: $*"
        return 0
    fi
    info "Installing missing packages: ${missing[*]}"
    sudo apt install -y "${missing[@]}"
}
