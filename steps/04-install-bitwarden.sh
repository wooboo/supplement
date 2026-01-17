#!/bin/sh

yay -S --noconfirm --needed bitwarden

if command -v npm >/dev/null 2>&1; then
    npm install -g @bitwarden/cli
fi

if command -v bw >/dev/null 2>&1; then
    bw config server https://vault.bitwarden.eu
fi
