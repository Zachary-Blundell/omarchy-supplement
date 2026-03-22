#!/usr/bin/env bash
set -euo pipefail

if pacman -Qq "1password-beta" >/dev/null 2>&1; then
  yay -Rns --noconfirm "1password-beta"
else
  echo "1password-beta is not installed, skipping."
fi

if pacman -Qq "1password-cli" >/dev/null 2>&1; then
  yay -Rns --noconfirm "1password-cli"
else
  echo "1password-cli is not installed, skipping."
fi




