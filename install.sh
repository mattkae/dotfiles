#!/bin/bash

. scripts/_meta.sh

UBUNTU_VERSION=$(lsb_release -rs 2>/dev/null)
if [[ "$UBUNTU_VERSION" != "26.04" && "$UBUNTU_VERSION" != "25.10" ]]; then
  echo "ERROR: This script requires Ubuntu 26.04. Detected: $(lsb_release -ds 2>/dev/null || echo 'unknown')"
  exit 1
fi

YES=false

# Optional feature groups (both default ON). Toggled by flags or the interactive TUI.
INSTALL_MIRACLE=true
INSTALL_DEV=true
# Tracks whether the user passed any feature flag explicitly; if so we skip the TUI.
FEATURE_FLAG_SET=false

print_help() {
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --yes                   Skip the interactive menu / confirmation prompt"
  echo "  --force                 Reinstall everything, ignoring 'already installed' checks"
  echo "  --miracle               Install the miracle-wm PPAs + package (default)"
  echo "  --no-miracle            Skip the miracle-wm PPAs + package (e.g. local build)"
  echo "  --dev                   Install developer tooling (default)"
  echo "  --no-dev                Skip developer tooling (bun, openssh, build tools, languages)"
  echo "  --help                  Show this help message and exit"
  echo ""
  echo "With no --yes and no feature flag, an interactive menu is shown."
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
    --miracle)
      INSTALL_MIRACLE=true
      FEATURE_FLAG_SET=true
      ;;
    --no-miracle)
      INSTALL_MIRACLE=false
      FEATURE_FLAG_SET=true
      ;;
    --dev)
      INSTALL_DEV=true
      FEATURE_FLAG_SET=true
      ;;
    --no-dev)
      INSTALL_DEV=false
      FEATURE_FLAG_SET=true
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

info "Ensuring curl installation..."
apt_install_missing curl

if $YES || $FEATURE_FLAG_SET; then
    info "Installation of Matt's dotfiles is starting..."
else
    # Bootstrap gum for the graphical menu; tui.sh falls back to plain prompts if absent.
    info "Ensuring gum installation for the interactive menu..."
    apt_install_missing gum || true
    . $PWD/scripts/tui.sh
    info "Installation of Matt's dotfiles is starting..."
fi

if $INSTALL_MIRACLE; then
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
else
  info "Skipping miracle-wm PPAs (--no-miracle)."
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

if $INSTALL_MIRACLE; then
  info "Installing miracle-wm..."
  apt_install_missing miracle-wm
else
  info "Skipping miracle-wm package (--no-miracle)."
fi

info "Installing applications dependencies from archive..."
apt_install_missing atfs wofi swaylock bat fd-find kitty network-manager-gnome fish wlogout papirus-icon-theme pamixer brightnessctl sway-notification-center grimshot waybar wl-clipboard bibata-cursor-theme slurp pavucontrol nautilus eza playerctl fastfetch
command -v snap &>/dev/null && sudo snap install bibata-all-cursor

. $PWD/scripts/fish.sh

if $INSTALL_DEV; then
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
else
  info "Skipping developer tooling (--no-dev)."
fi

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

info "Copying miracle-wm config..."
mkdir -p "$HOME/.config/miracle-wm/plugins"
cp "config/miracle-wm/config.yaml" "$HOME/.config/miracle-wm/"

info "Downloading the latest WebAssembly plugin..."
curl -fSL -o "$HOME/.config/miracle-wm/plugins/matts_config.wasm" \
  https://github.com/mattkae/dotfiles/releases/download/nightly/matts_config.wasm

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
