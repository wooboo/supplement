#!/bin/sh

yay -S --noconfirm --needed mc
rm -rf ~/.config/mc
stow mc