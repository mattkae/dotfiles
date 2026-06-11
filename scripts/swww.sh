#!/bin/bash

set -e

info "Installing swww (animated wallpaper daemon)..."

# swww isn't published to crates.io or packaged in the Ubuntu archive, so build it
# from its git repo with cargo (rustup is already installed earlier in install.sh).
# The workspace exposes two binary crates, `swww` (client) and `swww-daemon`.
# liblz4-dev is required for its compressed animation frame cache.
apt_install_missing liblz4-dev

if $FORCE || ! has_cmd swww || ! has_cmd swww-daemon; then
    cargo install --git https://github.com/LGFae/swww swww swww-daemon
else
    info "swww already installed, skipping."
fi
