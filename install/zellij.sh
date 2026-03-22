#!/bin/bash

# Install zellij
if ! command -v zellij &>/dev/null; then
    yay -S --noconfirm --needed zellij
fi
