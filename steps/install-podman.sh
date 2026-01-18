#!/bin/sh

if pacman -Qi docker >/dev/null 2>&1 || pacman -Qi docker-compose >/dev/null 2>&1; then
    echo "Removing docker/docker-compose..."
    sudo pacman -Rns --noconfirm docker docker-compose
fi

if pacman -Qi docker-desktop >/dev/null 2>&1 || yay -Qi docker-desktop >/dev/null 2>&1; then
    echo "Removing docker-desktop..."
    yay -Rns --noconfirm docker-desktop || sudo pacman -Rns --noconfirm docker-desktop
fi

if getent group docker >/dev/null 2>&1; then
    sudo groupdel docker 2>/dev/null || true
fi

yay -S --noconfirm --needed podman podman-docker podman-compose || return 1


sudo mkdir -p /etc/containers/registries.conf.d
sudo tee /etc/containers/registries.conf.d/10-unqualified-search-registries.conf >/dev/null <<'EOF'
unqualified-search-registries = ["docker.io", "hgcr.io", "mcr.microsoft.com"]
EOF

if command -v loginctl >/dev/null 2>&1; then
    loginctl enable-linger "$USER" >/dev/null 2>&1 || true
fi

if systemctl --user show-environment >/dev/null 2>&1; then
    systemctl --user enable --now podman.socket || true
else
    echo "systemctl --user not available; skipped enabling podman.socket"
fi

echo "Podman installed. docker CLI provided by podman-docker shim."
