#!/bin/sh

yay -S --noconfirm --needed claude-code claude-desktop-bin

TEMPLATE_DIR="$REPO_ROOT/templates/claude"

process_bw_templates "claude-secrets" "$TEMPLATE_DIR"
