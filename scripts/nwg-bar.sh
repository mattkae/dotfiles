#!/bin/bash

set -e

# Ensure script is run as a user (not root), but sudo is available
if [[ $EUID -eq 0 ]]; then
   error "Please do not run this script as root. It will use sudo when needed."
fi

PREVIOUS_DIR=$(pwd)

info "Updating package list..."
sudo apt update

info "Installing required dependencies..."
sudo apt install -y \
    git \
    build-essential \
    meson \
    ninja-build \
    libgtk-3-dev \
    libglib2.0-dev \
    libjson-glib-dev \
    libgdk-pixbuf2.0-dev \
    libpango1.0-dev \
    libcairo2-dev \
    libgtk-layer-shell-dev \
    pkg-config \
    libpulse-dev \
    libwayland-dev \
    libxkbcommon-dev \
    libinput-dev \
    libudev-dev \
    libevdev-dev \
    libpipewire-0.3-dev

# Clone the repo
REPO_URL="https://github.com/nwg-piotr/nwg-bar"
CLONE_DIR="$HOME/.local/src/nwg-bar"

if [[ -d "$CLONE_DIR" ]]; then
    info "Removing existing directory at $CLONE_DIR"
    rm -rf "$CLONE_DIR"
fi

info "Cloning nwg-bar from GitHub..."
git clone "$REPO_URL" "$CLONE_DIR"

cd "$CLONE_DIR"

info "Running 'make get'..."
make get

info "Building nwg-bar..."
make build

info "Installing nwg-bar..."
sudo make install

info "nwg-bar installation complete!"

cd "$PREVIOUS_DIR"
