#!/usr/bin/env bash

# install g
curl -sSL https://git.io/g-install | sh -s -- -y

# install golang standard tooling
"$HOME"/.go/bin/go get -u golang.org/x/tools/...
