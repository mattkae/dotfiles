#!/bin/bash

set -e

info "Installing assets (e.g. wallpapers)"

PREVIOUS_DIR=$(pwd)

WALLPAPER_DIR="$HOME/.local/share/wallpapers"
if ! $FORCE && [ -f "$WALLPAPER_DIR/wallpaper.png" ] && [ -f "$WALLPAPER_DIR/lockscreen.png" ]; then
    info "Wallpapers already present, skipping."
else
    mkdir -p "$WALLPAPER_DIR"
    cd "$WALLPAPER_DIR"
    curl https://raw.githubusercontent.com/dracula/wallpaper/refs/heads/master/second-collection/leaves/dracula-leaves-44475a.png --output wallpaper.png
    curl https://raw.githubusercontent.com/dracula/wallpaper/refs/heads/master/second-collection/leaves/dracula-leaves-6272a4-dark.png --output lockscreen.png
    cd "$PREVIOUS_DIR"
fi
