#!/bin/bash

# Install all packages in order
./install-asdf.sh
./install-tui-tools.sh
./install-freetube.sh
./install-kitty.sh
./install-nerdfonts.sh
./install-nextcloud.sh
./install-nodejs.sh
./install-stow.sh
./install-trash.sh
./install-zellij.sh
./install-zsh.sh

./install-dotfiles.sh


# Remove stuff
./remove-1password.sh
./remove-bloat.sh
./remove-nordvpn.sh
./remove-obsidian.sh
./remove-typora.sh

./set-shell.sh

./post-nextcloud-setup.sh
