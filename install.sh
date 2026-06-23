#!/bin/bash

. scripts/_meta.sh

UBUNTU_VERSION=$(lsb_release -rs 2>/dev/null)
if [[ "$UBUNTU_VERSION" != "26.04" && "$UBUNTU_VERSION" != "25.10" ]]; then
  echo "ERROR: This script requires Ubuntu 26.04. Detected: $(lsb_release -ds 2>/dev/null || echo 'unknown')"
  exit 1
fi

YES=false

print_help() {
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --yes                   Skip confirmation prompt"
  echo "  --force                 Reinstall everything, ignoring 'already installed' checks"
  echo "  --help                  Show this help message and exit"
}

# Parse arguments
for arg in "$@"; do
  case $arg in
    --yes)
      YES=true
      ;;
    --force)
      export FORCE=true
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
apt_install_missing curl

info "Adding miracle-wm PPAs..."
NEED_APT_UPDATE=false
add_ppa_if_missing() {
  if ! $FORCE && grep -rq "$1" /etc/apt/sources.list.d/ 2>/dev/null; then
    info "PPA $1 already added, skipping."
    return
  fi
  sudo add-apt-repository -y --no-update "ppa:$1"
  NEED_APT_UPDATE=true
}
add_ppa_if_missing "mir-team/dev"
add_ppa_if_missing "matthew-kosarek/miracle-wm"
if $NEED_APT_UPDATE; then
  sudo apt update
fi

info "Installing rust..."
if $FORCE || ! has_cmd cargo; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
else
  info "Rust already installed, skipping."
fi
. "$HOME/.cargo/env"

. $PWD/scripts/swww.sh

. $PWD/scripts/assets.sh

info "Installing miracle-wm..."
apt_install_missing miracle-wm

info "Installing applications dependencies from archive..."
apt_install_missing atfs wofi swaylock bat fd-find kitty network-manager-gnome fish wlogout papirus-icon-theme pamixer brightnessctl sway-notification-center grimshot waybar wl-clipboard bibata-cursor-theme slurp pavucontrol nautilus eza playerctl fastfetch
command -v snap &>/dev/null && sudo snap install bibata-all-cursor

. $PWD/scripts/fish.sh

info "Installing development dependencies from archive..."
apt_install_missing cmake pkg-config golang pyenv clang clangd net-tools ripgrep

info "Installing bun..."
if $FORCE || { ! has_cmd bun && [ ! -x "$HOME/.bun/bin/bun" ]; }; then
  curl -fsSL https://bun.sh/install | bash
else
  info "bun already installed, skipping."
fi

apt_install_missing openssh-server
sudo systemctl enable ssh
systemctl is-active --quiet systemd 2>/dev/null && sudo systemctl start ssh || true

. $PWD/scripts/screenshare.sh

info "Installing fonts..."
. $PWD/scripts/jetbrains-mono-nerd.sh
. $PWD/scripts/fonts.sh

info "Copying bashrc..."
cp -f "bashrc" "$HOME/.bashrc"

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
if ! rustup target list --installed | grep -q wasm32-wasip1; then
  rustup target add wasm32-wasip1
fi
cd config/miracle-wm/matts-config
apt_install_missing build-essential libclang-dev libmircore-dev
if $FORCE; then
  cargo clean
fi
cargo build --target wasm32-wasip1 --release
cd "$PREVIOUS_DIR"

info "Copying miracle-wm config..."
mkdir -p "$HOME/.config/miracle-wm/plugins"
cp "config/miracle-wm/config.yaml" "$HOME/.config/miracle-wm/"
cp "config/miracle-wm/matts-config/target/wasm32-wasip1/release/matts_config.wasm" "$HOME/.config/miracle-wm/plugins/"

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
gsettings set org.gnome.desktop.interface gtk-theme Dracula || true
gsettings set org.gnome.desktop.interface color-scheme prefer-dark || true

info "Setting cursor for snaps..."
if command -v snap &>/dev/null; then
  for plug in $(snap connections | grep gtk-common-themes:icon-themes | awk '{print $2}'); do sudo snap connect ${plug} bibata-all-cursor:icon-themes; done
fi

success "Installation complete"
