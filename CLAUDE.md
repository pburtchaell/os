# CLAUDE.md

This is a macOS system setup automation project. It configures system preferences, Dock layout, and installs development tools via interactive Bash scripts.

## Structure

- `setup.sh` — Main entry point with interactive arrow-key menu
- `scripts/utils.sh` — Shared utilities (colors, logging, sudo management, spinners)
- `scripts/defaults.sh` — macOS system and app preferences via `defaults write`
- `scripts/dock.sh` — Dock app layout via `dockutil`
- `scripts/dev.sh` — Development tool installation (Homebrew, Oh My Zsh, Node, pnpm, Claude Code)

## Conventions

- All scripts use `set -e` for fail-fast error handling
- Scripts are sourced/invoked from `setup.sh` using absolute paths resolved via `SCRIPT_DIR`
- Console output uses hierarchical indentation with color-coded icons: `✓` (green/success), `→` (gray/info), `!` (yellow/warn), `✗` (red/error)
- Utility functions (`info`, `success`, `warn`, `error`, `step`, `run_step`, `run_with_spinner`) are defined in `scripts/utils.sh`
- Each dev tool installation checks if the tool is already present before installing
- macOS defaults are applied via `defaults write` commands; some require `sudo`
- The project targets macOS exclusively (currently macOS Tahoe)
