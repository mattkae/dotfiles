#!/bin/bash

set -e

info "Installing Dracula theme..."

DRACULA_DIR="$HOME/.local/share/themes/Dracula"
mkdir -p ~/.local/share/themes
if $FORCE || [ ! -d "$DRACULA_DIR" ]; then
    rm -rf "$DRACULA_DIR"
    git clone https://github.com/dracula/gtk.git "$DRACULA_DIR"
else
    info "Dracula theme already present, skipping."
fi
