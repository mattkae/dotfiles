#!/bin/bash

# Interactive feature picker for install.sh.
#
# Sourced (not executed) by install.sh. Renders an ASCII logo and a checklist of
# optional feature groups, then sets the same variables the CLI flags set:
#
#   INSTALL_MIRACLE   add miracle-wm PPAs + install the miracle-wm package
#   INSTALL_DEV       install developer tooling (bun, openssh, build tools, languages)
#
# On confirm it leaves those variables set; on cancel it exits 0. Prefers `gum` for a
# graphical menu and falls back to a plain numbered `read` prompt when gum is absent.

# Reuses info()/error() and FORCE from _meta.sh, which install.sh sources first.

LOGO=$(cat <<'EOF'
                _    _    _          ___        _
  /\/\    __ _ | |_ | |_ ( )___     /   \ ___  | |_  ___
 /    \  / _` || __|| __||// __|   / /\ // _ \ | __|/ __|
/ /\/\ \| (_| || |_ | |_   \__ \  / /_//| (_) || |_ \__ \
\/    \/ \__,_| \__| \__|  |___/ /___,'  \___/  \__||___/

            dotfiles installer
EOF
)

# Print the human-readable summary used by both menu backends.
print_feature_summary() {
  echo "  • Miracle-wm  : add the miracle-wm PPAs and install the miracle-wm package."
  echo "                  Deselect if you build miracle-wm locally."
  echo "  • Dev tooling : bun, openssh-server, build tools and language toolchains"
  echo "                  (cmake, golang, pyenv, clang, ripgrep, ...)."
  echo ""
  echo "  Desktop config, fonts, themes and the swww/Rust build are always installed."
}

# gum-backed menu: styled logo + multiselect checklist.
run_gum_menu() {
  gum style --border rounded --margin "1" --padding "1 3" --border-foreground 212 "$LOGO"

  echo "This install could be DESTRUCTIVE to your system. Select what to install:"
  echo ""
  print_feature_summary
  echo ""

  local selected
  # --no-limit => multiselect; pre-select both groups as the default.
  selected=$(gum choose --no-limit \
    --selected="Miracle-wm,Developer tooling" \
    --header="Space to toggle, Enter to confirm, Ctrl+C to cancel:" \
    "Miracle-wm" "Developer tooling") || return 1

  # Reset both, then re-enable whatever survived the checklist.
  INSTALL_MIRACLE=false
  INSTALL_DEV=false
  grep -q "Miracle-wm" <<<"$selected" && INSTALL_MIRACLE=true
  grep -q "Developer tooling" <<<"$selected" && INSTALL_DEV=true

  gum confirm "Proceed with the installation?" || return 1
}

# True if the answer is a cancel request: 'q'/'quit'/'exit'.
is_cancel() {
  local a=$1
  [[ "$a" == "q" || "$a" == "quit" || "$a" == "exit" ]]
}

# Plain fallback menu when gum is unavailable.
run_plain_menu() {
  echo "$LOGO"
  echo ""
  echo "This install could be DESTRUCTIVE to your system. Choose what to install."
  echo "(press 'q' at any prompt to cancel)"
  echo ""
  print_feature_summary
  echo ""

  local answer
  read -p "Install miracle-wm PPAs + package? (Y/n): " answer
  answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
  is_cancel "$answer" && return 1
  [[ "$answer" == "n" || "$answer" == "no" ]] && INSTALL_MIRACLE=false || INSTALL_MIRACLE=true

  read -p "Install developer tooling (bun, openssh, build tools)? (Y/n): " answer
  answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
  is_cancel "$answer" && return 1
  [[ "$answer" == "n" || "$answer" == "no" ]] && INSTALL_DEV=false || INSTALL_DEV=true

  echo ""
  read -p "Proceed with the installation? (y/N): " answer
  answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
  is_cancel "$answer" && return 1
  [[ "$answer" == "y" || "$answer" == "yes" ]]
}

if has_cmd gum; then
  run_gum_menu || { error "Installation was aborted."; exit 0; }
else
  run_plain_menu || { error "Installation was aborted."; exit 0; }
fi

info "Selections: miracle-wm=$INSTALL_MIRACLE, dev-tooling=$INSTALL_DEV"
