#!/bin/sh

set_server() {
    local current_server
    current_server=$(bw config list 2>/dev/null | jq -r '.server // ""')

    echo "Current Bitwarden server: ${current_server:-"(not set)"}"
    read -r -p "Enter Bitwarden server URL [default: https://vault.bitwarden.eu]: " server_input
    server_input=${server_input:-https://vault.bitwarden.eu}

    if [ -z "$current_server" ] || [ "$current_server" != "$server_input" ]; then
        if [ -n "$current_server" ] && [ "$current_server" != "$server_input" ] && bw login --check >/dev/null 2>&1; then
            echo "Logging out of Bitwarden to update server URL..."
            bw logout
        fi
        bw config server "$server_input"
    else
        echo "Bitwarden server already set to $current_server"
    fi
}

yay -S --noconfirm --needed bitwarden jq || return 1

if command -v npm >/dev/null 2>&1; then
    npm install -g @bitwarden/cli
fi

if command -v bw >/dev/null 2>&1; then
    set_server
fi
