#!/bin/bash

# This script handles the post install setup of my particular system on Endeavour OS
ANTIGEN_DIR="$HOME/.antigen.d/"
CONFIGS_DIR="$HOME/Configs"
EMACS_DIR="$HOME/.emacs.d"
DOOM="$EMACS_DIR/bin/doom"
DOOM_DIR="$HOME/.doom.d"
FSHARP_DIR="$HOME/.fsharp"

sudo pacman -S rustup

rustup toolchain install stable

yay -S paru pamac
paru -R yay

paru -S - <packages.txt

#change user shell to zsh
chsh -s $(which zsh)

# fetch antigen.zsh
if [[ ! -d "$ANTIGEN_DIR" ]]; then
	mkdir "$ANTIGEN_DIR"
fi
curl -L git.io/antigen >"$ANTIGEN_DIR"/antigen.zsh

#
# fetch and install doom emacs
if [[ ! -d "$DOOM_DIR" ]]; then
	git clone --depth 1 https://github.com/hlissner/doom-emacs "$EMACS_DIR"
	$DOOM install
fi

# fetch my configs
if [[ ! -d "$CONFIGS_DIR"/.git ]]; then
	git clone https://github.com/alexpetrean80/configs.git "$CONFIGS_DIR"
fi
cd $CONFIGS_DIR || exit
stow ./*
cd "$HOME" || exit

# symlink all the configs to their usual places
stow ./*

# get cli utils
# setup for tj/n
sudo mkdir -p /usr/local/n
sudo chown -R "$(whoami)" /usr/local/n
sudo chown -R "$(whoami)" /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share

# install tj/n for node.js version management
curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n
# install stefanmaric/g for go version management
curl -sSL https://git.io/g-install | sh -s -- zsh
# install rustup for rust toolchain management
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | zsh

# install fsharp compiler
if [[ ! -d "$FSHARP_DIR" ]]; then
	mkdir "$FSHARP_DIR"
fi
git clone https://github.com/dotnet/fsharp.git "$FSHARP_DIR"
"$FSHARP_DIR/build.sh"

#install golang tools
go get -u golang.org/x/tools/...
go get -u github.com/fatih/gomodifytags
go get -u github.com/motemen/gore/cmd/gore
go get -u github.com/cweill/gotests/...
go get -u github.com/stamblerre/gocode

# install python tools
pip install black pyflakes isort pipenv nose pytest

# install node tools
npm i -g node-gyp
npm i -g stylelint beautify js-beautify

# sync the emacs configs
$DOOM sync

# finish by rebooting
sudo reboot now
