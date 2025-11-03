#!/bin/bash

set -e

info "Installing JetBrains Mono Nerd Font..."
PREVIOUS_DIR=$(pwd)

mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
unzip JetBrainsMono.zip
rm JetBrainsMono.zip
fc-cache -fv
cd "$PREVIOUS_DIR"