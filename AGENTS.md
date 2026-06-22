# macOS Setup

Bash scripts for automating macOS system preferences, Dock layout, and dev tool installation.

Run `./setup.sh` for the interactive menu. Targets macOS Tahoe.

Run `./setup.sh --simulate` to walk the whole flow without changing the system.

Console output uses color-coded icons: ✓ (success), → (info), ! (warn), ✗ (error).
Utility functions are in `scripts/utils.sh`.

Tests: `bats tests/` and `shellcheck setup.sh scripts/*.sh tests/fixtures/*.sh` (both run in CI). Install with `brew install bats-core shellcheck`.
