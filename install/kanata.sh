#!/bin/bash

# Install kanata
if ! command -v "kanata" >/dev/null 2>&1; then
  yay -S --noconfirm --needed "kanata"
fi

if command -v "kanata" >/dev/null 2>&1; then
  echo "starting kanata service"
  systemctl --user enable kanata.service
  systemctl --user start kanata.service
fi
