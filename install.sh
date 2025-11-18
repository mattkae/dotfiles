#!/bin/bash

. scripts/_meta.sh

INSTALL_DEPS=false
INSTALL_DEV_DEPS=false
INSTALL_MIRACLE_WM=false
INSTALL_FONTS=false
INSTALL_BASHRC=false

print_help() {
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --install-deps          Install required dependencies (Ubuntu 25.10 only)"
  echo "  --install-dev-deps      Install development dependencies (HIGHLY Matt-specific, Ubuntu 25.10 only)"
  echo "  --install-fonts         Install required fonts"
  echo "  --install-bashrc        Install bashrc too"
  echo "  --install-miracle-wm    Install miracle-wm from the archive (Ubuntu 25.10 only)"
  echo "  --help             Show this help message and exit"
}

# Parse arguments
for arg in "$@"; do
  case $arg in
    --install-deps)
      INSTALL_DEPS=true
      ;;
    --install-dev-deps)
      INSTALL_DEV_DEPS=true
      ;;
    --install-miracle-wm)
      INSTALL_MIRACLE_WM=true
      ;;
    --install-fonts)
      INSTALL_FONTS=true
      ;;
    --install-bashrc)
      INSTALL_BASHRC=true
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

read -p "Are you sure that you want to run this? This install could be DESTRUCTIVE to your system. Proceed with caution. (y/n): " choice

choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
if [[ "$choice" == "y" || "$choice" == "yes" ]]; then
    info "Installation of Matt's dotfiles is starting..."
else
    error "Installation was aborted."
    exit 0
fi

. $PWD/scripts/assets.sh

if $INSTALL_MIRACLE_WM; then
  info "Installing miracle-wm..."
  sudo add-apt-repository ppa:matthew-kosarek/miracle-wm
  sudo apt update
  sudo apt install miracle-wm
fi

if $INSTALL_DEPS; then
  info "Installing applications dependencies from archive..."
  sudo apt install atfs wofi swaylock bat fd-find kitty network-manager-gnome fish wlogout papirus-icon-theme pamixer brightnessctl sway-notification-center

  . $PWD/scripts/fish.sh
fi

if $INSTALL_DEV_DEPS; then
  info "Installing development dependencies from archive..."
  sudo apt install golang pyenv clang clangd

  sudo snap install clion --classic
  sudo snap install code --classic

  info "Installing bun..."
  curl -fsSL https://bun.sh/install | bash

  sudo apt install openssh-server
  sudo systemctl enable --now ssh
fi

if $INSTALL_FONTS; then
  info "Installing fonts..."
  . $PWD/scripts/jetbrains-mono-nerd.sh
  . $PWD/scripts/fonts.sh
fi

if $INSTALL_BASHRC; then
  info "Copy bashrc..."
  cp -f "bashrc" "$HOME/.bashrc"
fi

info "Setting user permissions..."
sudo usermod -a -G video $USER

info "Copying kitty config..."
cp -rf "config/kitty" "$HOME/.config/"

info "Copying fish config..."
cp -rf "config/fish" "$HOME/.config/"

info "Copying waybar config..."
cp -rf "config/waybar" "$HOME/.config"

info "Copying swaylock config..."
cp -rf "config/swaylock" "$HOME/.config"

info "Copying wofi config..."
cp -rf "config/wofi" "$HOME/.config"

info "Copying wlogout config..."
cp -rf "config/wlogout" "$HOME/.config"

info "Copying gtk config..."
. ./scripts/gtk.sh
cp -rf "config/gtk-3.0" "$HOME/.config"
cp -rf "config/gtk-4.0" "$HOME/.config"

info "Copying newsboat config..."
mkdir -p "$HOME/.config/.newsboat"
cp "config/newsboat/config" "$HOME/.config/.newsboat/"

info "Copying miracle-wm config..."
cp -rf "config/miracle-wm" "$HOME/.config"

info "Copying local bin files..."
mkdir -p ~/.local/bin
cp -r local/bin/* ~/.local/bin/ 

success "Installation complete"
