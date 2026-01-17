# omarchy-supplement

This repository contains supplementary configuration files, dotfiles, and installation scripts for the Omarchy environment. It is designed to streamline the setup of a personalized Arch Linux environment (specifically tailored for Hyprland).

## Features

- **Automated Installation:** `install-all.sh` updates the system and runs a suite of installation scripts.
- **Dotfile Management:** Uses [GNU Stow](https://www.gnu.org/software/stow/) to manage configurations for Bash, Git, Hyprland, etc.
- **Secret Management:** Integrated Bitwarden CLI and `gomplate` for secure, step-scoped configuration templating.
- **Tool Setup:** Scripts for VS Code, Ghostty, Zen Browser, OpenCode, and more.
- **Cleanup:** `uninstall-bloat.sh` for removing unwanted software.

## Bitwarden Secrets Setup

The system uses specialized Bitwarden Secure Notes to inject secrets into configuration templates.

### 1. Global Secrets (`dotfiles-secrets`)
Create a Secure Note named `dotfiles-secrets` for general configurations.

### 2. Package-Specific Secrets (e.g., `opencode-secrets`)
For specific tools like OpenCode, create a separate Secure Note (e.g., `opencode-secrets`):
```json
{
  "GITEA_HOST": "https://git.example.com",
  "GITEA_ACCESS_TOKEN": "your-token",
  "EXA_API_KEY": "your-key"
}
```

During installation, you will be prompted to login/unlock Bitwarden once, and the session will be reused.

## Usage

### Installation

To update the system and install all supplementary tools and configurations:

```bash
./install-all.sh
```

### Uninstalling Bloat

To remove specific pre-installed applications:

```bash
./uninstall-bloat.sh
```

## Directory Structure

- **`dotfiles/`**: Stow packages for symlinking to `$HOME`.
- **`steps/`**: Modular installation scripts sourced by `install-all.sh`.
- **`templates/`**: Configuration templates organized by package (e.g., `templates/opencode/`).
- **`install-all.sh`**: Main entry point.
- **`upstow.sh` / `unstow.sh`**: Helpers for managing dotfile packages.
