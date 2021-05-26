#!/bin/bash

paru -Q | awk '{print $1}' | tr '\n' ' ' > $HOME/Scripts/postinstall/packages.txt

echo "Packages saved"
