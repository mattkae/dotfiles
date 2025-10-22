#!/bin/bash

set -e

info "Installing Dracula theme..."

rm -rf ~/.themes/Dracula
mkdir -p ~/.themes
git clone https://github.com/dracula/gtk.git ~/.themes/Dracula
