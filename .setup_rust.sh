#!/usr/bin/env bash

# install rustup and the default toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# shellcheck source=$HOME/.cargo/env
# shellcheck disable=SC1091
source "$HOME"/.cargo/env

# add the sources of the standard lib
rustup component add rust-src

#install rust-analyzer
git clone https://github.com/rust-analyzer/rust-analyzer.git "$HOME"/rust-analyzer
cd "$HOME"/rust-analyzer || return
"$HOME"/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/cargo xtask install

# install ytop from crates.io
cargo install ytop
