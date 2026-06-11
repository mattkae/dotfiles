#!/bin/bash

set -e

info "Installing assets (e.g. wallpapers)"

PREVIOUS_DIR=$(pwd)

WALLPAPER_DIR="$HOME/.local/share/wallpapers"
ROTATION_DIR="$WALLPAPER_DIR/rotation"

# 4K Dracula art set, rotated through by launch-swww.sh.
# Source: https://github.com/aynp/dracula-wallpapers (Art/4k)
ROTATION_BASE_URL="https://raw.githubusercontent.com/aynp/dracula-wallpapers/main/Art/4k"
ROTATION_IMAGES=(
    "Dracula.png"
    "Ghost.png"
    "Hand.png"
    "Kraken.png"
    "Protruding Squares.png"
    "Rainbow 1.png"
    "Rainbow 2.png"
    "Ship.png"
    "Tree.png"
    "Waves 1.png"
)

if ! $FORCE && [ -f "$WALLPAPER_DIR/lockscreen.png" ] && [ -d "$ROTATION_DIR" ] && [ -n "$(ls -A "$ROTATION_DIR" 2>/dev/null)" ]; then
    info "Wallpapers already present, skipping."
else
    mkdir -p "$ROTATION_DIR"

    # Lockscreen image (static; used by swaylock).
    curl -L "https://raw.githubusercontent.com/dracula/wallpaper/refs/heads/master/second-collection/leaves/dracula-leaves-6272a4-dark.png" --output "$WALLPAPER_DIR/lockscreen.png"

    # Rotation set.
    for image in "${ROTATION_IMAGES[@]}"; do
        encoded="${image// /%20}"
        curl -L "$ROTATION_BASE_URL/$encoded" --output "$ROTATION_DIR/$image"
    done

    # Keep a static wallpaper.png fallback for anything that still expects it.
    cp "$ROTATION_DIR/${ROTATION_IMAGES[0]}" "$WALLPAPER_DIR/wallpaper.png"
fi

cd "$PREVIOUS_DIR"
