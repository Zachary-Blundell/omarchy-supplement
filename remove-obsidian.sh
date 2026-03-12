#!/usr/bin/env bash
set -euo pipefail

if pacman -Qq "obsidian" >/dev/null 2>&1; then
  yay -Rns --noconfirm "obsidian"
else
  echo "Obsidian is not installed, skipping."
fi
