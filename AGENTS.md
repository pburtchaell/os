# macOS Setup

Bash scripts for automating macOS system preferences, Dock layout, and dev tool installation.

Run `./setup.sh` for the interactive menu. Targets macOS Tahoe.

Run `./setup.sh --simulate` to walk the whole flow without changing the system.

Output helpers live in `scripts/utils.sh`. Messages use a small semantic set —
`log` (→), `success` (✓), `warn` (!), `error` (✗) — each taking an optional
indent level as a second argument: level 0 is top-level with the status icon;
level >0 nests the line under its heading with a `⎿` connector (2 spaces per
level) colored by status. `spin "Installing X..." cmd...` runs a sync action
behind gum's spinner and prints an indented ✓/✗ result. `confirm "Question?"`
is a gum yes/no prompt.

Interactive prompts (menus, confirmations, spinners) are powered by `gum`, with no bash fallback. `setup.sh` calls `ensure_gum` (in `scripts/utils.sh`) before the first menu: if `gum` isn't installed it downloads a temporary copy to a temp dir (printing `Getting ready...` — this one step can't show a gum spinner, since gum is the thing being fetched), puts it on `PATH`, and `cleanup` removes it on exit via the `EXIT`/`INT`/`TERM` trap. A pre-existing `gum` is used as-is and never removed. `spin` uses `gum spin` when attached to a terminal (`use_gum`) and otherwise runs the command headlessly with no spinner (e.g. CI), which is why the install logic stays testable.

Tests: `bats tests/` and `shellcheck setup.sh scripts/*.sh` (both run in CI). Install with `brew install bats-core shellcheck`.
