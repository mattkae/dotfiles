#!/bin/bash

set -e

# Ensure script is run as a user (not root), but sudo is available
if [[ $EUID -eq 0 ]]; then
   error "Please do not run this script as root. It will use sudo when needed."
fi

info "Installing swww..."

# Clone the repo
PREVIOUS_DIR=$(pwd)
REPO_URL="https://github.com/LGFae/swww"
CLONE_DIR="$HOME/.local/src/swww"

if [[ -d "$CLONE_DIR" ]]; then
    info "Removing existing directory at $CLONE_DIR"
    rm -rf "$CLONE_DIR"
fi

info "Cloning swww from GitHub..."
git clone "$REPO_URL" "$CLONE_DIR"

cd "$CLONE_DIR"

info "Bulding using cargo..."
cargo build --release

cp -f "target/release/swww" "~/.local/bin/swww"
cp -f "target/release/swww-daemon" "~/.local/bin/swww-daemon"

info "swww installation complete!"


cd "$PREVIOUS_DIR"
