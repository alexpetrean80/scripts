#!/bin/env bash
# This script handles the post install setup of my particular system on Endeavour OS
antigen_dir="$HOME/.antigen/"
configs_dir="$HOME/Configs"
emacs_dir="$HOME/.emacs.d"
doom="$emacs_dir/bin/doom"
doom_dir="$HOME/.config/doom"

setup_shell() {
    zsh_path="$(which zsh)"
    if [[ $SHELL != $zsh_path ]]; then
        chsh -s $zsh_path
    else
        echo "Default shell of user is already zsh."
    fi
    get_antigen
    get_starship
    source .zshrc
}

get_antigen() {
    if [[ ! -d "$antigen_dir" ]]; then
        mkdir "$antigen_dir"
    fi
    if [[ ! -e "$antigen_dir/antigen.zsh" ]]; then
        curl -L git.io/antigen >"$antigen_dir"/antigen.zsh
    else
        echo "Antigen already installed."
    fi
}

get_starship() {
    if [[ ! -x /usr/local/bin/starship ]]; then
        sh -c "$(curl -fsSL https://starship.rs/install.sh)"
    else
        echo "Starship prompt already installed."
    fi
}

get_doom() {
    if [[ ! -d "$doom_dir" ]]; then
        git clone --depth 1 https://github.com/hlissner/doom-emacs "$emacs_dir"
        $doom install
    else
        echo "Doom Emacs already installed."
    fi
}

get_configs() {
    if [[ ! -d "$configs_dir"/.git ]]; then
        git clone https://github.com/alexpetrean80/configs.git "$configs_dir"
    else
        echo "Configs already cloned."
    fi
}

symlink_configs() {
    cd "$configs_dir" || exit
    stow *
    cd "$HOME" || exit
}

setup_golang() {
    echo "Setting up golang..."
    echo "Installing golang packages..."
    cat packages/go.txt | while read -r package; do
        go get -u "$package"
    done
    echo "Done installing golang packages."

    echo "Done setting up golang."
}

setup_emacs() {
    $doom sync
    $doom compile
}

setup_python() {
    echo "Setting up python..."
    echo "Installing pip packages..."
    cat packages/python.txt | while read -r package; do
        sudo pip install "$package"
    done
    echo "Done installing pip packages."
    echo "Done setting up python."
}

setup_rust() {
    echo "Setting up rust..."
    rustup toolchain add stable
    source "$HOME/.cargo/env"
    echo "Installing rust packages..."
    cat packages/rust.txt | while read -r package; do
        cargo install "$package"
    done
    echo "Done installing rust packages." echo "Done setting up rust."
}

get_system_packages() {
    echo "Installing system packages..."
    cat packages/sys.txt | while read -r package; do
        yay -S "$package"
    done
    echo "Done installing system packages."
}

setup_node() {
    echo "Setting up node..."
    echo "Installing node packages..."
    cat packages/node.txt | while read -r package; do
        sudo npm i -g "$package"
    done
    echo "Done installing node packages."
    echo "Done setting up node."
}

setup_dev() {
    setup_golang &
    setup_rust &
    setup_python &
    setup_node &
    get_doom &
}

setup_configs() {
    get_antigen &
    get_configs && symlink_configs &
}

get_system_packages
setup_shell
setup_dev
setup_configs
