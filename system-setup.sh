#!/usr/bin/env bash

# find the package manager of the distro
manager=$(command -v apt || command -v dnf)

# make sure the system is up to date
sudo "$manager" -y update

# install all the apps
apps=("emacs" "fish" "curl" "fd-find" "ripgrep" "podman" "go" "wget" "jq" "timeshift" "gnome-boxes" "git" "ccls" "mosh" "Shellcheck" "flatpak")
for app in "${apps[@]}"; do
	if [ ! "$(command -v "$app")" ]; then
		sudo "$manager" install -y "$app"
		printf "\n"
	fi
done

# add flathub as a flatpak source
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# install flatpaks
flatpaks=("org.telegram.desktop" "com.gigitux.gtkwhats" "org.onlyoffice.desktopeditors" "com.bitwarden.desktop")
for app in "${flatpaks[@]}"; do
	flatpak install -y flathub "$app"
	printf "\n"
done

# set the default shell as fish
if [ "$SHELL" != "/usr/bin/fish" ]; then
	chsh -s "$(which fish)"
fi

# if Doom is not install, install it
if [ ! -d "$HOME/.doom.d" ]; then
	# clone the Doom Emacs repo
	git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d

	# install the default version
	~/.emacs.d/bin/doom install

	# remove the default config and clone custom config
	rm -rf ~/.doom.d
	git clone git@gitlab.com:alex_petrean80/doom-config.git ~/.doom.d

	# install and byte-compile custom config
	~/.emacs.d/bin/doom sync && ~/.emacs.d/bin/doom compile

fi

# install fnm and the latest version of node.js
curl -fsSL https://github.com/Schniz/fnm/raw/master/.ci/install.sh | bash
# shellcheck disable=SC1091
source /home/alex/.config/fish/config.fish
fnm install latest

# install rustup and the default toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# shellcheck source=$HOME/.cargo/env
# shellcheck disable=SC1091
source "$HOME/.cargo/env"

# install gvm
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)

# install ytop from crates.io
if [ ! "$(command -v ytop)" ]; then
	cargo install ytop
fi

# install golang standard tooling
go get -u golang.org/x/tools/...

exit
