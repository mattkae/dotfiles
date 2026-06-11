#!/bin/bash

set -e

PREVIOUS_DIR=$(pwd)

NERD_VERSION="3.1.1"
NERD_FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$NERD_FONT_DIR"
if ! $FORCE && [ "$(cat "$NERD_FONT_DIR/.jbmono-nerd-version" 2>/dev/null)" = "$NERD_VERSION" ]; then
    info "JetBrains Mono Nerd Font $NERD_VERSION already installed, skipping."
else
    info "Installing JetBrains Mono Nerd Font..."
    cd "$NERD_FONT_DIR"
    wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v$NERD_VERSION/JetBrainsMono.zip"
    unzip -o JetBrainsMono.zip
    rm JetBrainsMono.zip
    echo "$NERD_VERSION" > "$NERD_FONT_DIR/.jbmono-nerd-version"
    fc-cache -fv
    cd "$PREVIOUS_DIR"
fi