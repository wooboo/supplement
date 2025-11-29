#!/bin/sh

yay -S --noconfirm --needed base-devel openssl zlib rustup

rustup toolchain install stable
rustup default stable
cargo install fnm
fnm install 24
fnm use 24
yay -S --noconfirm --needed nodejs-lts-jod bun deno
yay -S --noconfirm --needed dotnet-sdk 


deno completions bash > deno.bash

if [ -d "/usr/local/etc/bash_completion.d/" ]; then
  sudo mv deno.bash /usr/local/etc/bash_completion.d/
  source /usr/local/etc/bash_completion.d/deno.bash
elif [ -d "/usr/share/bash-completion/completions/" ]; then
  sudo mv deno.bash /usr/share/bash-completion/completions/
  source /usr/share/bash-completion/completions/deno.bash
else
  echo "Please move deno.bash to the appropriate bash completions directory"
fi