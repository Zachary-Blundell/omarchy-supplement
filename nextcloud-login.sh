#!/bin/bash
set -euo pipefail

SERVER_URL="https://cloud.zac.coffee"
LOCAL_DIR="$HOME/Nextcloud"
CONFIG_FILE="$HOME/.config/Nextcloud/nextcloud.cfg"

mkdir -p "$LOCAL_DIR"
mkdir -p "$(dirname "$CONFIG_FILE")"

has_nextcloud_account() {
  [[ -f "$CONFIG_FILE" ]] && grep -q '^\[Accounts' "$CONFIG_FILE"
}

if has_nextcloud_account; then
  echo "Nextcloud account already configured"
  exit 0
fi

echo "Launching Nextcloud login..."
nohup nextcloud --overrideserverurl "$SERVER_URL" \
                --overridelocaldir "$LOCAL_DIR" \
                >/dev/null 2>&1 &
