#!/bin/bash

set -e

info "Installing xdg-desktop-portal-wlr from apt..."
sudo apt install -y xdg-desktop-portal-wlr slurp

info "Copying xdg-desktop-portal-wlr config..."
sudo mkdir -p /etc/xdg/xdg-desktop-portal-wlr
sudo cp "config/xdg-desktop-portal-wlr/config" /etc/xdg/xdg-desktop-portal-wlr/config

info "Setting preferred portal backends..."
mkdir -p "$HOME/.config/xdg-desktop-portal"
cp "config/xdg-desktop-portal/portals.conf" "$HOME/.config/xdg-desktop-portal/portals.conf"
