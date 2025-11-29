#!/bin/bash

# Uninstall 1password
yay -Rns 1password-cli 1password-beta --noconfirm
yay -Rns alacritty --noconfirm
yay -Rns obsidian --noconfirm

omarchy-webapp-remove Basecamp
omarchy-webapp-remove Discord
omarchy-webapp-remove Figma
omarchy-webapp-remove "Google Contacts"
omarchy-webapp-remove "Google Messages"
omarchy-webapp-remove HEY
omarchy-webapp-remove WhatsApp
omarchy-webapp-remove X
omarchy-webapp-remove Zoom