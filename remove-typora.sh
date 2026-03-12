#!/usr/bin/env bash
set -euo pipefail

if pacman -Qq "typora" >/dev/null 2>&1; then
  yay -Rns --noconfirm "typora"
else
  echo "typora is not installed, skipping."
fi
