#!/bin/bash

set -e

info "Installing Dracula theme..."

mkdir -p ~/.local/share/themes
rm -rf ~/.local/share/themes/Dracula
git clone https://github.com/dracula/gtk.git ~/.local/share/themes/Dracula
