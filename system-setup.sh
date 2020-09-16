#!/usr/bin/env bash

# give execution permision to all auxiliary scripts
chmod +x .create_dirs.sh .install_apps.sh .setup_emacs.sh .setup_fish.sh .setup_golang.sh .setup_node.sh .setup_rust.sh

# program installation and fish setup are handled syncronously, since all other
# scripts depend on at least one tool which is installed here and the programming
# language setups depend on the active user shell
./.install_apps.sh

parallel ::: ./.setup_emacs.sh ./.setup_golang.sh ./.setup_rust.sh ./.create_dirs.sh
