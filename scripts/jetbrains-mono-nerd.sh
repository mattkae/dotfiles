#!/bin/bash

set -e

NERD_VERSION="3.1.1"
NERD_FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$NERD_FONT_DIR"
if ! $FORCE && [ "$(cat "$NERD_FONT_DIR/.jbmono-nerd-version" 2>/dev/null)" = "$NERD_VERSION" ]; then
    info "JetBrains Mono Nerd Font $NERD_VERSION already installed, skipping."
else
    (
        info "Installing JetBrains Mono Nerd Font..."
        NERD_ARCHIVE=$(mktemp --suffix=.zip)
        trap 'rm -f "$NERD_ARCHIVE"' EXIT
        if ! curl -fL --retry 3 -o "$NERD_ARCHIVE" \
            "https://github.com/ryanoasis/nerd-fonts/releases/download/v$NERD_VERSION/JetBrainsMono.zip"; then
            error "Failed to download JetBrains Mono Nerd Font $NERD_VERSION." >&2
            exit 1
        fi
        if ! unzip -tq "$NERD_ARCHIVE"; then
            error "Invalid JetBrains Mono Nerd Font archive; please rerun the installer." >&2
            exit 1
        fi
        unzip -o "$NERD_ARCHIVE" -d "$NERD_FONT_DIR"
        fc-cache -fv
        echo "$NERD_VERSION" > "$NERD_FONT_DIR/.jbmono-nerd-version"
    )
fi