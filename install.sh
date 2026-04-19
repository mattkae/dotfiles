#!/bin/bash

. scripts/_meta.sh

UBUNTU_VERSION=$(lsb_release -rs 2>/dev/null)
if [[ "$UBUNTU_VERSION" != "25.10" ]]; then
  echo "ERROR: This script requires Ubuntu 25.10. Detected: $(lsb_release -ds 2>/dev/null || echo 'unknown')"
  exit 1
fi

INSTALL_DEV_DEPS=false
INSTALL_BASHRC=false
YES=false

print_help() {
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --install-dev-deps      Install development dependencies (HIGHLY Matt-specific)"
  echo "  --install-bashrc        Install bashrc too"
  echo "  --yes                   Skip confirmation prompt"
  echo "  --help                  Show this help message and exit"
}

# Parse arguments
for arg in "$@"; do
  case $arg in
    --install-dev-deps)
      INSTALL_DEV_DEPS=true
      ;;
    --install-bashrc)
      INSTALL_BASHRC=true
      ;;
    --yes)
      YES=true
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

if $YES; then
    info "Installation of Matt's dotfiles is starting..."
else
    read -p "Are you sure that you want to run this? This install could be DESTRUCTIVE to your system. Proceed with caution. (y/n): " choice
    choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
    if [[ "$choice" == "y" || "$choice" == "yes" ]]; then
        info "Installation of Matt's dotfiles is starting..."
    else
        error "Installation was aborted."
        exit 0
    fi
fi

info "Ensuring curl installation..."
sudo apt install -y curl

info "Adding miracle-wm PPAs..."
sudo add-apt-repository ppa:mir-team/dev -y
sudo add-apt-repository ppa:matthew-kosarek/miracle-wm -y
sudo apt update

info "Installing rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
. "$HOME/.cargo/env"

. $PWD/scripts/assets.sh

info "Installing miracle-wm..."
sudo apt install miracle-wm -y

info "Installing applications dependencies from archive..."
sudo apt -y install atfs wofi swaylock bat fd-find kitty network-manager-gnome fish wlogout papirus-icon-theme pamixer brightnessctl sway-notification-center grimshot waybar wl-clipboard bibata-cursor-theme slurp pavucontrol nautilus
command -v snap &>/dev/null && sudo snap install bibata-all-cursor

. $PWD/scripts/fish.sh

if $INSTALL_DEV_DEPS; then
  info "Installing development dependencies from archive..."
  sudo apt install cmake pkg-config golang pyenv clang clangd net-tools ripgrep -y

  # sudo snap install clion --classic
  command -v snap &>/dev/null && sudo snap install code --classic

  info "Installing bun..."
  curl -fsSL https://bun.sh/install | bash

  sudo apt install -y openssh-server
  sudo systemctl enable --now ssh

fi

. $PWD/scripts/screenshare.sh

info "Installing fonts..."
. $PWD/scripts/jetbrains-mono-nerd.sh
. $PWD/scripts/fonts.sh

if $INSTALL_BASHRC; then
  info "Copy bashrc..."
  cp -f "bashrc" "$HOME/.bashrc"
fi

info "Setting user permissions..."
sudo usermod -a -G video $USER || true

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

info "Copying swaync config..."
cp -rf "config/swaync" "$HOME/.config"

info "Copying gtk config..."
. ./scripts/gtk.sh
cp -rf "config/gtk-3.0" "$HOME/.config"
cp -rf "config/gtk-4.0" "$HOME/.config"

info "Copying newsboat config..."
mkdir -p "$HOME/.config/.newsboat"
cp "config/newsboat/config" "$HOME/.config/.newsboat/"

info "Building the WebAssembly plugin..."
PREVIOUS_DIR=$(pwd)
rustup target add wasm32-wasip1
cd config/miracle-wm/matts-config
sudo apt install -y build-essential libclang-dev libmircore-dev
cargo clean
cargo build --target wasm32-wasip1 --release
cd "$PREVIOUS_DIR"

info "Copying miracle-wm config..."
cp -rf "config/miracle-wm" "$HOME/.config"

info "Copying local bin files..."
mkdir -p ~/.local/bin
cp -rf local/bin/* ~/.local/bin/ 

info "Copying local share files..."
mkdir -p ~/.local/share
mkdir -p ~/.local/share/icons/default
cp -rf local/share/* ~/.local/share/ 

info "Copying Xresources..."
cp .Xresources ~/.Xresources
xrdb -load ~/.Xresources || true

info "Copying and setting cursor values..."
cp -rf "config/environment.d" "$HOME/.config"
gsettings set org.gnome.desktop.interface cursor-size 24 || true
gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Classic || true

info "Setting cursor for snaps..."
if command -v snap &>/dev/null; then
  for plug in $(snap connections | grep gtk-common-themes:icon-themes | awk '{print $2}'); do sudo snap connect ${plug} bibata-all-cursor:icon-themes; done
fi
  

success "Installation complete"
