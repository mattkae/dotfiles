#!/bin/bash

source scripts/_meta.sh

INSTALL_DEPS=false

print_help() {
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --install-deps     Install required dependencies (Ubuntu 24.04 only)"
  echo "  --help             Show this help message and exit"
}

# Parse arguments
for arg in "$@"; do
  case $arg in
    --install-deps)
      INSTALL_DEPS=true
      ;;
    --help)
      print_help
      exit 0
      ;;
    *)
      echo "Unknown option: $arg"
      print_help
      exit 1
      ;;
  esac
done

if $INSTALL_DEPS; then
    info "Installing dependencies..."

    info "Installing applications dependencies from archive..."
    sudo add-apt-repository ppa:matthew-kosarek/miracle-wm
    sudo apt update
    sudo apt install miracle-wm atfs wofi swaylock kitty network-manager-gnome

    info "Installing development dependencis form archive..."
    sudo apt install golang
    source $PWD/scripts/pyenv.sh

    info "Installing snaps..."
    sudo snap install clion --classic
    sudo snap install emacs --classic

    source $PWD/scripts/nushell.sh
    source $PWD/scripts/carapace.sh
    source $PWD/scripts/nwg-panel.sh
fi

info "Installing fonts..."
source $PWD/scripts/fonts.sh

info "Copy bashrc..."
cp -f "bashrc" "$HOME/.bashrc"

info "Copying kitty config..."
cp -rf "config/kitty" "$HOME/.config/kitty"

info "Copying nushell config..."
cp -rf "config/nushell" "$HOME/.config/nushell"

info "Copying nwg-bar config..."
cp -rf "config/nwg-bar" "$HOME/.config/nwg-bar"

info "Copying nwg-panel config..."
cp -rf "config/nwg-panel" "$HOME/.config/nwg-panel"

info "Copying swaylock config..."
cp -rf "config/swaylock" "$HOME/.config/swaylock"

info "Copying wofi config..."
cp -rf "config/wofi" "$HOME/.config/wofi"

success "Installation complete"