# INSTALLATION SCRIPTS KNOWLEDGE BASE

## OVERVIEW
System provisioning logic modularized into individual shell scripts. Orchestrated by `../install-all.sh`.

## MECHANISM: SOURCING
**CRITICAL**: Scripts here are **SOURCED** (`source script.sh`), not executed as child processes.
- **Shared Scope**: Variables defined here persist to subsequent scripts.
- **No `exit`**: `exit` kills the `install-all.sh` process. Use `return` or conditionals.
- **No `set -e`**: Avoid `set -e` as it will cause the parent installer to exit on failure.

## STRUCTURE
- `00-install-stow.sh`: **Destructive Setup**. Clears `~` to prevent Stow symlink conflicts.
- `01-secrets-helper.sh`: **Common Utility**. Provides Bitwarden auth and template processing functions.
- `04-install-bitwarden.sh`: Configures Bitwarden CLI server.
- `05-secrets.sh`: Processes global dotfile secrets.
- `install-claude.sh`: Installs Claude Code and Desktop, manages its templates.
- `install-overrides.sh`: Specific Hyprland configuration updates.
- `install-*.sh`: Package-specific installation and configuration.

## CONVENTIONS
- **Ordering**: Prefix with `00-`, `01-`, etc., for specific bootstrap order. Otherwise, alphabetical.
- **Secrets Management**: Use `process_bw_templates "<item>" "$REPO_DIR/templates/<subfolder>"` for secret-injected configs.
- **Safety**: Use `pacman -S --needed` or `yay --needed` for idempotency.
- **Verification**: Use `command -v <cmd>` to guard installation logic.

## ANTI-PATTERNS
- **Exit/Set -e**: Critical failures in sourcing mechanism. Use `return 1` for errors.
- **Interactive Prompts**: Ensure `yay` and other tools use non-interactive flags.
- **Hardcoded Secrets**: Never commit actual secrets; use templates in `../templates/`.
