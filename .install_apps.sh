#!/usr/bin/env bash

manager=$(command -v apt || command -v dnf)
sudo "$manager" -y update
# repo apps
apps=("emacs" "fish" "curl" "fd-find" "ripgrep" "podman" "wget" "jq" "timeshift" "gnome-boxes" "git" "ccls" "mosh" "Shellcheck" "flatpak" "npm" "parallel")

# flatpak apps
flatpaks=("org.telegram.desktop" "com.gigitux.gtkwhats" "org.onlyoffice.desktopeditors" "com.bitwarden.desktop")

# install repo apps
for app in "${apps[@]}"; do
    sudo "$manager" install -y "$app"
done

# add flathub as a flatpak repo and install the flatpaks
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
for app in "${flatpaks[@]}"; do
    flatpak install -y flathub "$app"
    printf "\n"
done
