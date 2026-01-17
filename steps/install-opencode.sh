#!/bin/sh

yay -S --noconfirm --needed opencode-bin

TEMPLATE_DIR="$REPO_ROOT/templates/opencode"

process_bw_templates "dotfiles-secrets" "$TEMPLATE_DIR" "--merge-json"
