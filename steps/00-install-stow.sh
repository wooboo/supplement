#!/bin/sh

echo "Applying configurations via stow..."
[ -d "dotfiles" ] && STOW_DIR="dotfiles" || STOW_DIR="../dotfiles"

# Backup files before removal if they are not already managed by stow/symlinks
for file in ~/.bashrc ~/.config/starship.toml ~/.config/fastfetch ~/.config/git ~/.claude/settings.json; do
    if [ -f "$file" ] || [ -d "$file" ]; then
        if [ ! -L "$file" ]; then
            TIMESTAMP=$(date +%Y%m%d_%H%M%S)
            echo "Backing up $file to ${file}.${TIMESTAMP}.bak"
            cp -r "$file" "${file}.${TIMESTAMP}.bak"
        fi
    fi
done

rm -rf ~/.bashrc ~/.config/starship.toml ~/.config/fastfetch ~/.config/git 
stow -t "$HOME" -d "$STOW_DIR" bash
stow -t "$HOME" -d "$STOW_DIR" starship
stow -t "$HOME" -d "$STOW_DIR" fastfetch
stow -t "$HOME" -d "$STOW_DIR" git
stow -t "$HOME" -d "$STOW_DIR" hyprland
stow -t "$HOME" -d "$STOW_DIR" mc
stow -t "$HOME" -d "$STOW_DIR" tmux
stow -t "$HOME" -d "$STOW_DIR" claude


