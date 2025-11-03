#!/bin/bash

set -e

PREVIOUS_DIR=$(pwd)

if [ ! -d "$HOME/.local/share/omf" ]; then
    info "Installing oh my fish..."
    curl -L https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
else
    info "Oh My Fish already installed, skipping."
fi

info "Installing bobthefish..."
if [ ! -d "$BOB_DIR" ]; then
    info "Installing bobthefish theme..."
    fish -c "omf install bobthefish"
else
    info "bobthefish already installed, skipping."
fi

cd "$PREVIOUS_DIR"
