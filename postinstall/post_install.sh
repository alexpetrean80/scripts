#!/bin/bash

# This script handles the post install setup of my particular system on Endeavour OS
ANTIGEN_DIR="$HOME/.antigen.d/"
CONFIGS_DIR="$HOME/Configs"
EMACS_DIR="$HOME/.emacs.d"
DOOM="$EMACS_DIR/bin/doom"

sudo pacman -S rustup

rustup toolchain install stable

yay -S paru pamac
paru -R yay

paru -S - <packages.txt

#change user shell to zsh
chsh -s $(which zsh)

# fetch antigen.zsh
mkdir "$ANTIGEN_DIR"
curl -L git.io/antigen >"$ANTIGEN_DIR"/antigen.zsh

#
# fetch and install doom emacs
git clone --depth 1 https://github.com/hlissner/doom-emacs $EMACS_DIR
$DOOM install

# fetch my configs
git clone https://github.com/alexpetrean80/configs.git "$CONFIGS_DIR"
cd $CONFIGS_DIR || exit
stow ./*
cd "$HOME" || exit

# symlink all the configs to their usual places
stow *

# sync the emacs configs
$DOOM sync

# finish by rebooting
sudo reboot now
