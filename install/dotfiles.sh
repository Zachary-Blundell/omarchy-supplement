#!/bin/bash

REPO_URL="https://github.com/Zachary-Blundell/dotfiles"
REPO_NAME="dotfiles"
ROLE="${1}"

if [[ -z "$ROLE" ]]; then
  echo "Must provide role"
  echo "Usage: $0 [laptop|desktop]"
  exit 1
elif [[ "$ROLE" != 'laptop' && "$ROLE" != "desktop" ]]; then
  echo "Invalid role: $ROLE"
  echo "Usage: $0 [laptop|desktop]"
  exit 1
fi
echo "looks good"

is_stow_installed() {
  pacman -Qi "stow" &>/dev/null
}

if ! is_stow_installed; then
  echo "Install stow first"
  exit 1
fi

cd ~ || exit

Check if the repository already exists
if [ -d "$REPO_NAME" ]; then
  echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
  git clone "$REPO_URL"
fi

# Check if the clone was successful
if [ -d "$REPO_NAME" ]; then
  echo "removing old configs"
  rm -rf \
    "$HOME/.config/hypr" \
    "$HOME/.config/hyprmon" \
    "$HOME/.config/kanata" \
    "$HOME/.config/kitty" \
    "$HOME/.config/nvim" \
    "$HOME/.config/omarchy" \
    "$HOME/.config/waybar" \
    "$HOME/.config/zellij" \
    "$HOME/.config/zsh" \
    "$HOME/.local/bin"

  cd "$REPO_NAME" || exit
  echo "Stowing dots"
  stow hyprland
  stow hyprmon
  stow kitty
  stow nvim
  stow omarchy
  stow scripts
  stow waybar
  stow zellij
  stow zsh

  if [[ $ROLE == "laptop" ]]; then
    stow kanata
    stow monitors-laptop
  elif [[ $ROLE == "desktop" ]]; then
    stow monitors-desktop
  else
    echo 'error'
    exit 1
  fi

else
  echo "Failed to clone the repository."
  exit 1
fi
