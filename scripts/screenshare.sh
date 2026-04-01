#!/bin/bash

set -e

info "Building and installing xdg-desktop-portal-wlr v0.5.0 from source..."
sudo apt install meson ninja-build libpipewire-0.3-dev libxkbcommon-dev libsystemd-dev libinih-dev wayland-protocols libwayland-dev
XDPW_DOTFILES_DIR=$(pwd)
XDPW_TMP=$(mktemp -d)
git clone https://github.com/emersion/xdg-desktop-portal-wlr "$XDPW_TMP/xdg-desktop-portal-wlr"
cd "$XDPW_TMP/xdg-desktop-portal-wlr"
git checkout 7c0f352
meson setup builddir --prefix=/usr
cd builddir
ninja -j4
sudo ninja install
cd "$XDPW_DOTFILES_DIR"
rm -rf "$XDPW_TMP"

info "Copying xdg-desktop-portal-wlr config..."
sudo mkdir -p /etc/xdg/xdg-desktop-portal-wlr
sudo cp "config/xdg-desktop-portal-wlr/config" /etc/xdg/xdg-desktop-portal-wlr/config

info "Setting up mir portal..."
if [ -f /usr/share/xdg-desktop-portal/portals/wlr.portal ]; then
  sudo cp /usr/share/xdg-desktop-portal/portals/wlr.portal /usr/share/xdg-desktop-portal/portals/mir.portal
  sudo sed -i 's/UseIn=.*/UseIn=mir/' /usr/share/xdg-desktop-portal/portals/mir.portal
else
  info "wlr.portal not found - xdg-desktop-portal-wlr may not have installed correctly"
fi
