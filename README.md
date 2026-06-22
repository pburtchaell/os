# os

A simple script to configure macOS system preferences to my liking and install my favorite apps, services and frameworks. **Completely refactored in 2026 for macOS Tahoe compatibility and to cover my current stack for useful, productive AI, coding and design work.**

## Getting started

On a new Mac, run remotely with one command:

```bash
curl -fsSL psb.lol/setup.sh | bash
```

Or, from a local clone:

```bash
./setup.sh
```

The script will present a menu with configuration options:

- **macOS settings** - Configure system preferences and app defaults
- **Dock layout** - Set up Dock apps and settings
- **Development tools** - Install Homebrew, Oh My Zsh, Node, pnpm, Python, Claude Code, Mole and a selectable set of apps
- **All of the above** - Run everything

You can preview the whole flow without changing anything using `--simulate`:

```bash
./setup.sh --simulate
```

## What it does

### macOS system preferences

Configures more reasonable preferences for:

- **Finder**: Show hidden files, use list view, show path/status bar, show file extensions
- **Menu bar**: Hide WiFi, Battery, Spotlight, Siri, Focus Modes, Sound and Now Playing
- **Screenshots**: Save as PNG, disable drop shadows
- **Keyboard**: Enable key repeat (disable press-and-hold), faster repeat rate
- **Trackpad**: Faster tracking speed
- **General**: Expand save/print panels, disable app resume, enable auto-updates

As well as a few app preferences:

- **Safari**: Disable search suggestions to Apple, set blank homepage, disable password autofill
- **Chrome**: Disable swipe navigation, disable background mode, expand print dialog
- **TextEdit**: Use plain text mode with UTF-8 encoding
- **Activity Monitor**: Show all processes, sort by CPU usage

### Dock layout

Clears the default Dock apps and adds your preferred apps in a nice order:

- Finder
- Messages
- Chrome, ChatGPT & Claude
- GitHub Desktop, Ghostty, Cursor & Xcode
- Downloads folder
- Trash

### Development tools

Installs the following tools if not already present:

- **Homebrew** - Package manager for macOS
- **Oh My Zsh** - Framework for managing Zsh configuration
- **Node** - JavaScript runtime
- **pnpm** - Fast, disk space efficient package manager
- **Python** - General-purpose programming language
- **Claude Code** - Fast coding
- **Mole** - SSH tunnel manager

It then offers a checklist of GUI apps to install via Homebrew Cask (↑/↓ to move, space to select, enter to confirm):

- **Browsers**: Google Chrome, Vivaldi, Firefox
- **Dev & AI**: Ghostty, Visual Studio Code, Cursor, GitHub Desktop, Claude Desktop, superwhisper
- **Design & media**: Figma, CleanShot X, ImageOptim
- **Productivity**: 1Password, Paste, Stats, Dropbox, Flux
- **Comms & media**: Discord, Zoom, Spotify, Sonos
- **Maker / 3D**: Bambu Studio, OpenSCAD, Raspberry Pi Imager

## Development

The scripts are linted with [ShellCheck](https://www.shellcheck.net) and tested with [bats-core](https://github.com/bats-core/bats-core):

```bash
brew install bats-core shellcheck

shellcheck setup.sh scripts/*.sh tests/fixtures/*.sh
bats tests/
```

Tests live in `tests/` and cover the `utils.sh` helpers (multi-select menu, simulate mode, the install spinner), `setup.sh` argument parsing, and the cask list. Both checks run on every push via GitHub Actions (`.github/workflows/ci.yml`).

## Inspiration

Years ago, the original inspiration for this came from:

- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
- [jaywcjlove/awesome-mac](https://github.com/jaywcjlove/awesome-mac)
