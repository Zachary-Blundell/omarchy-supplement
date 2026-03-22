#!/bin/bash
set -euo pipefail

SOURCE_DOCUMENTS="$HOME/Nextcloud/Documents"
DEST_DOCUMENTS="$HOME/Documents"

SOURCE_PICTURES="$HOME/Nextcloud/Photos"
DEST_PICTURES="$HOME/Pictures"

symlink_it() {
  local src="$1"
  local dest="$2"
  echo "Symlinking '$dest' -> '$src'"
  ln -s -- "$src" "$dest"
}

safelink() {
  local src="$1"
  local dest="$2"
  local current_target

  if [[ ! -e "$src" ]]; then
    echo "Source does not exist: $src"
    return 1
  fi

  if [[ -L "$dest" ]]; then
    current_target="$(readlink -- "$dest")"
    if [[ "$current_target" == "$src" ]]; then
      echo "$dest already points to $src"
      return 0
    else
      echo "$dest is a symlink, but points to $current_target. Check that out before proceeding."
      return 1
    fi
  fi

  if [[ -e "$dest" ]]; then
    echo "$dest already exists"

    if [[ -d "$dest" ]]; then
      if [[ -z "$(find "$dest" -mindepth 1 -maxdepth 1 -print -quit)" ]]; then
        echo "$dest is an empty directory, removing it"
        rmdir -- "$dest"
        symlink_it "$src" "$dest"
      else
        echo "$dest is not empty, move your files first:"
        ls -- "$dest"
        if gum confirm "Do you want to move all files from '$dest' into '$src' and proceed?"; then
          echo "Moving files..."
          mv -- "$dest"/* "$src"/
          rmdir -- "$dest"
          symlink_it "$src" "$dest"
        else
          echo "Not proceeding."
          return 1
        fi
      fi
    else
      echo "$dest exists and is not a directory, refusing to replace it"
      return 1
    fi
  else
    echo "$dest does not exist"
    symlink_it "$src" "$dest"
  fi
}

safelink "$SOURCE_DOCUMENTS" "$DEST_DOCUMENTS"
safelink "$SOURCE_PICTURES" "$DEST_PICTURES"
