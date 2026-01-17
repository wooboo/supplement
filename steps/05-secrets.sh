#!/bin/bash

yay -S --noconfirm --needed gomplate jq

if ! bw login --check >/dev/null 2>&1; then
    export BW_SESSION=$(bw login --raw)
elif [ -z "$BW_SESSION" ]; then
    export BW_SESSION=$(bw unlock --raw)
fi

SECRETS_FILE="/dev/shm/dotfiles-secrets.json"
bw get item "dotfiles-secrets" | jq -r '.notes' > "$SECRETS_FILE"
chmod 600 "$SECRETS_FILE"

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TEMPLATE_DIR="$REPO_DIR/templates"

if [ -d "$TEMPLATE_DIR" ]; then
    find "$TEMPLATE_DIR" -type f | while read -r tmpl_path; do
        rel_path="${tmpl_path#$TEMPLATE_DIR/}"
        
        if [[ "$rel_path" == *.tmpl ]]; then
            target_path="$HOME/${rel_path%.tmpl}"
            mkdir -p "$(dirname "$target_path")"
            gomplate -d secrets="file://$SECRETS_FILE" -f "$tmpl_path" -o "$target_path"
            chmod 600 "$target_path"
        else
            target_path="$HOME/$rel_path"
            mkdir -p "$(dirname "$target_path")"
            cp "$tmpl_path" "$target_path"
        fi
    done
fi

rm -f "$SECRETS_FILE"
