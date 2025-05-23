#!/bin/bash

set -e

info "Installing nwg-panel..."

sudo apt install git curl bluez-tools gir1.2-gtklayershell-0.1 libgtk-3-0 pulseaudio-utils\
    gir1.2-dbusmenu-gtk3-0.4 gir1.2-playerctl-2.0 playerctl python3-dasbus python3-gi-cairo\
    python3-i3ipc python3-netifaces python3-psutil python3-requests python3-setuptools python3-wheel sway-notification-center

# Clone the repo
REPO_URL="https://github.com/nwg-piotr/nwg-panel"
CLONE_DIR="$HOME/.local/src/nwg-panel"

if [[ -d "$CLONE_DIR" ]]; then
    info "Removing existing directory at $CLONE_DIR"
    rm -rf "$CLONE_DIR"
fi

info "Cloning nwg-panel from GitHub..."
git clone "$REPO_URL" "$CLONE_DIR"

cd "$CLONE_DIR"

info "Running 'install.sh'..."
./install.sh


REPO_URL="https://github.com/nwg-piotr/nwg-icon-picker"
CLONE_DIR="$HOME/.local/src/nwg-icon-picker"

if [[ -d "$CLONE_DIR" ]]; then
    info "Removing existing directory at $CLONE_DIR"
    rm -rf "$CLONE_DIR"
fi

info "Cloning nwg-icon-picker from GitHub..."
git clone "$REPO_URL" "$CLONE_DIR"

cd "$CLONE_DIR"

info "Running 'install.sh'..."
./install.sh


info "Building nwg-bar..."
make build

info "Installing nwg-bar..."
sudo make install

info "nwg-panel installation complete!"
