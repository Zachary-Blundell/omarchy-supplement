#!/bin/bash

# Install NextcloudClient
if ! command -v nextcloud-client &>/dev/null; then
    yay -S --noconfirm --needed nextcloud-client
fi
