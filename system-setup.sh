#!/usr/bin/env bash

PROGRAMMING_ROOT="$HOME"/Programming
GIT_DIR="$HOME"/Git

DIRS=("js" "go" "rust" "c" "c#" "java" "lisp" "python" "prolog")

# repo apps
APPS=("util-linux-user" "zsh" "curl" "fd-find" "ripgrep" "podman" "wget" "jq" "timeshift" "gnome-boxes" "git" "mosh" "ShellCheck" "flatpak" "parallel" "codium" "dnf-plugins-core" "brave-browser" "kakoune" "neovim")

# flatpak apps
FLATPAKS=("org.telegram.desktop" "com.gigitux.gtkwhats" "org.onlyoffice.desktopeditors" "com.bitwarden.desktop")

function install_app() {
    if [ ! "$(command -v "$1")" ]; then
        sudo dnf install -y "$1" 
    else
        echo "$1" already installed
    fi
    
}

function create_dirs() {    
    if [ ! -d "$GIT_DIR" ]; then
        mkdir "$GIT_DIR"
    else
        echo "$GIT_DIR" already exists
    fi

    if [ ! -d "$PROGRAMMING_ROOT" ]; then
        mkdir "$PROGRAMMING_ROOT"
    else 
        echo "$PROGRAMMING_ROOT" already exists
    fi

    for dir in "${DIRS[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir "$PROGRAMMING_ROOT/$dir"
        else
            echo "$dir" already exists
        fi
    done
}

function setup_repos() {
    # vscodium
    sudo rpm --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg 
    printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=gitlab.com_paulcarroty_vscodium_repo\nbaseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg" |sudo tee -a /etc/yum.repos.d/vscodium.repo

    #brave
    sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
}

function setup_apps() {
    # update repos
    sudo "dnf" -y update

    # install repo apps
    for app in "${APPS[@]}"; do
        install_app "$app"
    done

    # add flathub as a flatpak repo and install the flatpaks
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    for app in "${FLATPAKS[@]}"; do
        flatpak install -y flathub "$app"
        printf "\n"
    done

    # remove APPS
    sudo dnf remove -y firefox nano libreoffice
}

function setup_zsh() {
    # set the default shell as zsh
    chsh -s "$(command -v zsh)"

    # install zim
    if [ ! -d "$HOME".zim ]; then
        curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
    else 
        echo zim already installed
    fi
    
}

function setup_node() {
    # install fnm 
    if [ ! "$(command -v fnm)" ]; then
        curl -fsSL https://github.com/Schniz/fnm/raw/master/.ci/install.sh | sh
    else 
        echo fnm already installed
    fi
    
    # shellcheck disable=SC1091
    source /home/alex/.zshrc

    if [ ! "$(command -v node)" ]; then
        fnm install latest
    else
        echo node already installed
    fi
    
    if [ ! "$(command -v npm)" ]; then
        fnm install npm
    else
        echo npm already installed
    fi
}

function setup_go() {
    # install g
    if [ ! "$(command -v g)" ]; then
        curl -sSL https://git.io/g-install | sh -s -- -y
    else 
        echo g already installed
    fi

    # install golang standard tooling
    "$HOME"/.go/bin/go get -u golang.org/x/tools/...
}

function setup_rust() {
    # install rustup and the default toolchain
    if [ ! "$(command -v rustup)" ]; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    else 
        echo rustup already installed
    fi
    # shellcheck source=$HOME/.cargo/env
    # shellcheck disable=SC1091
    source "$HOME"/.cargo/env

    # add the sources of the standard lib
    rustup component add rust-src

    #install rust-analyzer
    if [ -d "rust-analyzer" ]; then
        git clone https://github.com/rust-analyzer/rust-analyzer.git "$GIT_DIR"/rust-analyzer
        cd "$GIT_DIR"/rust-analyzer || return
        "$HOME"/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/cargo xtask install
    fi
    

    # install ytop from crates.io
    if [ ! "$(command -v ytop)" ]; then
        cargo install ytop
    else
        echo ytop already installed
    fi
}

create_dirs
setup_repos
setup_apps
setup_zsh
setup_node
setup_go
setup_rust