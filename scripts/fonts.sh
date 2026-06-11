#!/bin/bash

set -e

# Ensure script is run as a user (not root), but sudo is available
if [[ $EUID -eq 0 ]]; then
   error "Please do not run this script as root. It will use sudo when needed."
fi

PREVIOUS_DIR=$(pwd)

# Setup the directories
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

INSTALLED_FONT=false

# Fetch and install Iosevka (pinned)
IOSEVKA_VERSION="33.2.3"
if ! $FORCE && [ "$(cat "$FONT_DIR/.iosevka-version" 2>/dev/null)" = "$IOSEVKA_VERSION" ]; then
    info "Iosevka $IOSEVKA_VERSION already installed, skipping."
else
    info "Installing Iosevka..."
    IOSEVKA_ZIP_FILENAME="PkgTTF-Iosevka-$IOSEVKA_VERSION.zip"
    IOSEVKA_URL="https://github.com/be5invis/Iosevka/releases/download/v$IOSEVKA_VERSION/$IOSEVKA_ZIP_FILENAME"
    curl -LO "$IOSEVKA_URL"
    IOSEVKA_FILE=$(basename "$IOSEVKA_ZIP_FILENAME")
    IOSEVKA_TARGET_DIR=$(basename "Iosevka")
    unzip -q "$IOSEVKA_FILE" -d "$IOSEVKA_TARGET_DIR"
    rm -rf "$FONT_DIR/Iosevka"
    mv -f "$IOSEVKA_TARGET_DIR" "$FONT_DIR/"
    rm $IOSEVKA_FILE
    echo "$IOSEVKA_VERSION" > "$FONT_DIR/.iosevka-version"
    INSTALLED_FONT=true
fi


# Fetch and install JetBrains Mono (tracks latest)
if ! $FORCE && [ -d "$FONT_DIR/JetBrainsMono" ]; then
    info "JetBrains Mono already installed, skipping."
else
    info "Installing JetBrains Mono..."
    JBMONO_URL=$(curl -s https://api.github.com/repos/JetBrains/JetBrainsMono/releases/latest \
      | grep "browser_download_url" \
      | grep "JetBrainsMono-.*.zip" \
      | cut -d '"' -f 4)

    JBMONO_FILE=$(basename "$JBMONO_URL")
    JBMONO_TARGET_DIR=$(basename "JetBrainsMono")
    curl -LO "$JBMONO_URL"
    unzip -q "$JBMONO_FILE" -d "$JBMONO_TARGET_DIR"
    rm -rf "$FONT_DIR/JetBrainsMono"
    mv -f "$JBMONO_TARGET_DIR" "$FONT_DIR/"
    rm $JBMONO_FILE
    INSTALLED_FONT=true
fi


# Update font cache (only if something changed)
if $INSTALLED_FONT; then
    info "Updating font cache..."
    fc-cache -f "$FONT_DIR"
fi

cd "$PREVIOUS_DIR"
