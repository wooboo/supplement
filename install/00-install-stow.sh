#!/bin/sh

echo "Installing stow and applying configurations..."
yay -S --noconfirm --needed stow
if [ $? -ne 0 ]; then
    echo "Error installing stow. Exiting."
    exit 1
fi
rm -rf ~/.bashrc ~/.config/starship.toml ~/.config/fastfetch ~/.config/git 
stow bash
stow starship
stow fastfetch
stow git


