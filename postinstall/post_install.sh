#!/bin/bash

# This script handles the post install setup of my particular system on Endeavour OS

CONFIGS_DIR="$HOME/Configs"
EMACS_DIR="$HOME/.emacs.d"
DOOM="$EMACS_DIR/bin/doom"

yay -S paru pamac
paru -R yay

paru -S - < packages.txt

# fetch antigen.zsh
mkdir "$HOME/GitStuff"
curl -L git.io/antigen > antigen.zsh

# fetch my configs
git clone https://github.com/alexpetrean80/configs.git $CONFIG_DIR
cd $CONFIG_DIR

# fetch and install doom emacs
git clone --depth 1 https://github.com/hlissner/doom-emacs $EMACS_DIR
$DOOM install

# symlink all the configs to their usual places
stow *

# sync the emacs configs
$DOOM sync

sudo reboot now
