#!/bin/bash

yay -Q | awk '{print $1}' >"$HOME/Scripts/postinstall/packages.txt"

echo "Packages saved"
