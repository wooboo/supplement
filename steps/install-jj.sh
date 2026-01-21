#!/bin/sh

print_step "Jujutsu (jj)" "Installs jj, a Git-compatible version control system"

yay -S --noconfirm --needed jujutsu

# Setup jujutsu configuration via stow
if [ -d "$REPO_ROOT/dotfiles/jj" ]; then
    process_bw_templates "dotfiles-secrets" "$REPO_ROOT/dotfiles/jj"
    safe_stow "jj" "$REPO_ROOT/dotfiles"
fi

# Generate shell completions if jj is installed
if command -v jj >/dev/null 2>&1; then
    mkdir -p "$HOME/.local/share/bash-completion/completions"
    jj util completion bash > "$HOME/.local/share/bash-completion/completions/jj"
fi
