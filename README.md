# omarchy-supplement

This repository contains supplementary configuration files, dotfiles, and installation scripts for the Omarchy environment. It is designed to streamline the setup of a personalized Arch Linux environment (specifically tailored for Hyprland).

## Features

- **Automated Installation:** `install-all.sh` updates the system and runs a suite of installation scripts.
- **Dotfile Management:** Uses [GNU Stow](https://www.gnu.org/software/stow/) to manage configurations for:
  - Bash
  - Starship
  - Fastfetch
  - Git
  - Tmux
  - Midnight Commander (mc)
  - Hyprland
- **Tool Setup:** Scripts to install and configure development tools like VS Code, Ghostty, Zen Browser, and more.
- **Cleanup:** Includes a script to remove unwanted "bloat" software.

## Usage

### Installation

To update the system and install all supplementary tools and configurations:

```bash
./install-all.sh
```

This script will:
1. Update the system (`pacman -Syyu`).
2. Execute all scripts located in the `install/` directory.
3. Apply dotfiles using `stow`.

### Uninstalling Bloat

To remove specific pre-installed applications (like 1Password, Alacritty, Obsidian) and web apps:

```bash
./uninstall-bloat.sh
```

## Directory Structure

- **`install/`**: Contains individual installation scripts (e.g., `install-ghostty.sh`, `install-vscode.sh`).
- **`bash/`, `fastfetch/`, `git/`, `hyprland/`, `mc/`, `starship/`, `tmux/`**: Configuration directories managed by Stow.
- **`install-all.sh`**: Main entry point for installation.
- **`uninstall-bloat.sh`**: Script for removing specific packages.
