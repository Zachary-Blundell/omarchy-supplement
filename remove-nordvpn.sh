#!/usr/bin/env bash
set -euo pipefail

PKGS=(nordvpn-bin nordvpn-gui)

have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

remove_pkg_if_installed() {
  local pkg="$1"

  if pacman -Qq "$pkg" >/dev/null 2>&1; then
    echo "Removing $pkg..."
    if have_cmd paru; then
      paru -Rns --noconfirm "$pkg"
    elif have_cmd yay; then
      yay -Rns --noconfirm "$pkg"
    else
      sudo pacman -Rns --noconfirm "$pkg"
    fi
  else
    echo "$pkg is not installed, skipping."
  fi
}

# Stop and disable the daemon if it exists.
if systemctl list-unit-files | grep -q '^nordvpnd\.service'; then
  echo "Stopping and disabling nordvpnd.service..."
  sudo systemctl disable --now nordvpnd.service || true
else
  echo "nordvpnd.service not present, skipping."
fi

# Remove NordVPN packages if installed.
for pkg in "${PKGS[@]}"; do
  remove_pkg_if_installed "$pkg"
done

# Remove the current user from the nordvpn group if both exist.
if getent group nordvpn >/dev/null 2>&1; then
  if id -nG "$USER" | tr ' ' '\n' | grep -qx 'nordvpn'; then
    echo "Removing $USER from nordvpn group..."
    sudo gpasswd -d "$USER" nordvpn >/dev/null || true
  else
    echo "$USER is not in nordvpn group, skipping."
  fi
else
  echo "nordvpn group not present, skipping user removal."
fi

# Delete the nordvpn group if it exists and has no members left.
if getent group nordvpn >/dev/null 2>&1; then
  group_line="$(getent group nordvpn)"
  members="${group_line##*:}"

  if [[ -z "$members" ]]; then
    echo "Deleting empty nordvpn group..."
    sudo groupdel nordvpn || true
  else
    echo "nordvpn group still has members ($members), leaving it in place."
  fi
fi

# Remove leftover state/config if present.
for path in \
  /var/lib/nordvpn \
  /var/log/nordvpn \
  /etc/opt/nordvpn \
  "$HOME/.config/nordvpn" \
  "$HOME/.local/share/nordvpn" \
  "$HOME/.cache/nordvpn"
do
  if [[ -e "$path" ]]; then
    echo "Removing $path..."
    sudo rm -rf "$path" 2>/dev/null || rm -rf "$path"
  else
    echo "$path not present, skipping."
  fi
done

echo "NordVPN cleanup complete."
echo "Log out and back in if group membership changes have not reflected yet."
