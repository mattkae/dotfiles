#!/bin/bash

set -e

info "Installing assets (e.g. wallpapers)"

PREVIOUS_DIR=$(pwd)

mkdir -p ~/.local/share/wallpapers
cd ~/.local/share/wallpapers
curl https://raw.githubusercontent.com/dracula/wallpaper/refs/heads/master/second-collection/leaves/dracula-leaves-44475a.png --output wallpaper.png 
curl https://raw.githubusercontent.com/dracula/wallpaper/refs/heads/master/second-collection/leaves/dracula-leaves-6272a4-dark.png --output lockscreen.png

cd "$PREVIOUS_DIR"
