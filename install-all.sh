#!/bin/sh
sudo pacman -Syyu --noconfirm
# Source all scripts in the install folder
for script in install/*; do
    if [ -f "$script" ]; then
        echo "Sourcing $script..."
        source "$script"
    fi
done