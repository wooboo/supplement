#!/bin/sh

yay -S --noconfirm --needed opencode-bin

# Install plugins
if command -v npm >/dev/null 2>&1; then
    echo "Installing OpenCode plugins..."
    npm install -g oh-my-opencode opencode-antigravity-auth opencode-openai-codex-auth opencode-antigravity-quota
fi

TEMPLATE_DIR="$REPO_ROOT/templates/opencode"

process_bw_templates "dotfiles-secrets" "$TEMPLATE_DIR" "--merge-json"
