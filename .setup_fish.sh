#!/usr/bin/env bash

# set the default shell as fish
chsh -s "$(command -v fish)"

# remove the default configuration and clone custom one
rm -rf "$HOME"/.config/fish
git clone git@gitlab.com:alex_petrean80/fish-config.git "$HOME"/.config/fish
