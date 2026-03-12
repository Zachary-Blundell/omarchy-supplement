#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if pacman -Q nextcloud-client >/dev/null 2>&1; then
  "$SCRIPT_DIR/nextcloud-login.sh"

  gum confirm "Have you finished signing in to Nextcloud?" || exit 1

  "$SCRIPT_DIR/nextcloud-symlinks.sh"
else
  echo "Nextcloud was not installed properly"
  exit 1
fii
