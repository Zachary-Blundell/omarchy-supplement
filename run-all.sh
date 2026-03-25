#!/bin/bash

# -----------------------------
# Colors
# -----------------------------
RED=$'\e[31m'
GREEN=$'\e[32m'
YELLOW=$'\e[33m'
BLUE=$'\e[34m'
BOLD=$'\e[1m'
RESET=$'\e[0m'

info() { echo "${BLUE}${BOLD}==>${RESET} $*"; }
success() { echo "${GREEN}${BOLD}✔${RESET}  $*"; }
warn() { echo "${YELLOW}${BOLD}⚠ Warning:${RESET}  $*"; }
error() { echo "${RED}${BOLD}✖ Error:${RESET}  $*" >&2; }

# Can be passed in
ROLE="${1}"

choose_role() {
  if [[ -n "$ROLE" ]]; then
    case "$ROLE" in
    laptop | desktop) return 0 ;;
    *)
      echo "Invalid role: $ROLE"
      echo "Usage: $0 [laptop|desktop]"
      exit 1
      ;;
    esac
  fi

  if command -v gum >/dev/null 2>&1; then
    ROLE="$(gum choose --header "Which setup do you want to install?" laptop desktop)"
  else
    echo "gum is not installed."
    printf "Install which setup? [laptop/desktop]: "
    read -r ROLE
    case "$ROLE" in
    laptop | desktop) ;;
    *)
      echo "Invalid choice: $ROLE"
      exit 1
      ;;
    esac
  fi
}

choose_role

echo "Installing $ROLE setup..."

# Install all packages in order
./install/dotfiles.sh "$ROLE"

./install/asdf.sh
./install/brave.sh
./install/bun.sh
./install/calibre.sh
./install/freetube.sh
./install/hyprmon.sh
./install/keymapp.sh
./install/kitty.sh
./install/nerdfonts.sh
./install/nextcloud.sh
./install/nodejs.sh
./install/onlyoffice.sh
./install/screensaver.sh
./install/stow.sh
./install/terminal-tools.sh
./install/via-omarchy.sh
./install/zellij.sh
./install/zsh.sh

if [[ $ROLE == 'laptop' ]]; then
  ./install/kanata.sh
fi

# Remove stuff
./remove/1password.sh
./remove/nordvpn.sh
./remove/obsidian.sh
./remove/typora.sh

# Set up stuff
./setup/set-shell.sh

echo "Done installing $ROLE setup."
