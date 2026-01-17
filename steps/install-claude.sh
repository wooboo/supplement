#!/bin/sh

yay -S --noconfirm --needed claude-code

TEMPLATE_DIR="$REPO_ROOT/templates/claude"

process_bw_templates "dotfiles-secrets" "$TEMPLATE_DIR" "--merge-json"
