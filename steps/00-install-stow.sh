#!/bin/sh

echo "Applying configurations via stow..."
[ -d "dotfiles" ] && STOW_DIR="dotfiles" || STOW_DIR="../dotfiles"
rm -rf ~/.bashrc ~/.config/starship.toml ~/.config/fastfetch ~/.config/git 
stow -t "$HOME" -d "$STOW_DIR" bash
stow -t "$HOME" -d "$STOW_DIR" starship
stow -t "$HOME" -d "$STOW_DIR" fastfetch
stow -t "$HOME" -d "$STOW_DIR" git
stow -t "$HOME" -d "$STOW_DIR" opencode
stow -t "$HOME" -d "$STOW_DIR" hyprland
stow -t "$HOME" -d "$STOW_DIR" mc
stow -t "$HOME" -d "$STOW_DIR" tmux


