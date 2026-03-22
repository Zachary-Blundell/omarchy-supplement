#!/bin/bash

ROLE="${1:-}"

choose_role() {
  if [[ -n "$ROLE" ]]; then
    case "$ROLE" in
      laptop|desktop) return 0 ;;
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
      laptop|desktop) ;;
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
./install-terminal-tools.sh
./install-asdf.sh
./install-brave.sh
./install-bun.sh
./install-dotfiles.sh "$ROLE"
./install-freetube.sh
./install-via-omarchy.sh
./install-kitty.sh
./install-nerdfonts.sh
./install-nextcloud.sh
./install-nodejs.sh
./install-stow.sh
./install-trash.sh
./install-screensaver.sh
./install-zellij.sh
./install-zsh.sh



# Role specific packages
case "$ROLE" in
  laptop) # if laptop
    ./install-hyprdynamicmonitors.sh
    ;;
  desktop) # if desktop
    ./install-hyprmon.sh
    ;;
esac

# Remove stuff
./remove-1password.sh
./remove-nordvpn.sh
./remove-obsidian.sh
./remove-typora.sh

./set-shell.sh

# Nextcloud stuff
./nextcloud-postinstall-setup.sh

echo "Done installing $ROLE setup."
