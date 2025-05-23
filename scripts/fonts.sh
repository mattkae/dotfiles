#!/bin/bash

set -e


# Setup the directories
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"


# Fetch and install Iosevka 
info "Installing Iosevka..."
IOSEVKA_ZIP_FILENAME="PkgTTF-Iosevka-33.2.3.zip"
IOSEVKA_URL="https://github.com/be5invis/Iosevka/releases/download/v33.2.3/$IOSEVKA_ZIP_FILENAME"
curl -LO "$IOSEVKA_URL"
IOSEVKA_FILE=$(basename "$IOSEVKA_ZIP_FILENAME")
IOSEVKA_TARGET_DIR=$(basename "Iosevka")
unzip -q "$IOSEVKA_FILE" -d "$IOSEVKA_TARGET_DIR"
rm -rf "$FONT_DIR/Iosevka"
mv -f "$IOSEVKA_TARGET_DIR" "$FONT_DIR/"
rm $IOSEVKA_FILE


# Fetch and install JetBrains Mono
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


# Update font cache
info "Updating font cache..."
fc-cache -f "$FONT_DIR"
