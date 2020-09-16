#!/usr/bin/env bash

# clone the Doom Emacs repo
git clone --depth 1 https://github.com/hlissner/doom-emacs "$HOME"/.emacs.d

# install the default version
"$HOME"/.emacs.d/bin/doom install -y

# remove the default config and clone custom config
git clone git@gitlab.com:alex_petrean80/doom-config.git "$HOME"/.doom.d

# install and byte-compile custom config
"$HOME"/.emacs.d/bin/doom sync && "$HOME"/.emacs.d/bin/doom compile
