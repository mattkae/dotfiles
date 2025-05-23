#!/bin/bash

set -e

info "Install Jetbrains Mono..."

mkdir -p $HOME/.local/share/fonts
cp -r $PWD/local/share/fonts/JetBrainsMono-2.304 ~/.local/share/fonts/

info "Install Iosevka..."
cp -r $PWD/local/share/fonts/SuperTTC-Iosevka-33.2.3 ~/.local/share/fonts/