#!/usr/bin/env bash

# install fnm and the latest version of node.js
curl -fsSL https://github.com/Schniz/fnm/raw/master/.ci/install.sh | bash
# shellcheck disable=SC1091
source /home/alex/.config/fish/config.fish
fnm install latest
