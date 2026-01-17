# PROJECT KNOWLEDGE BASE

**Generated:** 2026-01-17
**Commit:** 9271a12
**Branch:** main

## OVERVIEW
Arch Linux + Hyprland dotfile management and system provisioning repository. Uses GNU Stow for configuration symlinking and a custom shell-based orchestration for system setup with integrated Bitwarden secret management.

## STRUCTURE
```
.
├── dotfiles/        # Stow Packages (mapped to ~/)
├── steps/           # Provisioning scripts (sourced by install-all.sh)
├── templates/       # Gomplate templates for secret-injected configs
├── install-all.sh   # MAIN ENTRY POINT - Sources all steps/* scripts
├── uninstall-bloat.sh # cleanup script for pre-installed bloat
├── upstow.sh        # Helper for creating dotfile packages
├── unstow.sh        # Unlinks configurations
└── AGENTS.md        # Project conventions and knowledge base
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| **Install System** | `./install-all.sh` | Updates system + runs steps/*. |
| **Add Package** | `steps/` | Create `install-NAME.sh` |
| **Secrets/Templates**| `templates/` | Gomplate files (.tmpl) |
| **Window Rules** | `dotfiles/hyprland/` | See Hyprland overrides |
| **Shell Aliases** | `dotfiles/bash/.bashrc` | Custom bash environment |
| **Cleanup** | `uninstall-bloat.sh` | Removes pre-defined bloat software |

## CONVENTIONS
- **Stow-First**: All configurations MUST live in `dotfiles/`. Direct edits to `~/.config` are forbidden.
- **Sourcing**: `install-all.sh` uses `source`. Scripts in `steps/` share the same shell environment.
- **Idempotency**: All installation scripts must use `--needed` flags or conditional checks.
- **Numerical Prefix**: Use `00-` for scripts that must run early. `01-secrets-helper.sh` provides common utility.
- **Secrets**: Use `process_bw_templates <bw_item> <template_dir>` from the helper.

## ANTI-PATTERNS (THIS PROJECT)
- **No `exit`**: Using `exit` in `steps/*.sh` terminates the main installer. Use `return`.
- **No `set -e`**: In sourced scripts, this causes the parent installer to exit on any error.
- **Direct Home Edits**: Manual changes in `~` cause Stow conflicts.
- **Variable Leaks**: Avoid global variables in `steps/` unless intended for subsequent scripts.

## COMMANDS
```bash
# Full installation/update
./install-all.sh

# Unlink all configurations
./unstow.sh

# Remove specific bloat packages
./uninstall-bloat.sh
```

## NOTES
- Tightly coupled with the parent "Omarchy" system.
- `steps/00-install-stow.sh` is destructive; it removes existing local configs before linking.
- Hyprland overrides are automatically reloaded via `hyprctl reload` in `steps/install-overrides.sh`.
