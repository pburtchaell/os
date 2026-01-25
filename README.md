# macOS setup

A simple script to configure macOS system preferences for productive development work.

## Getting started

Clone the repo and run the setup script:

```bash
git clone https://github.com/pburtchaell/os.git ~/.os
cd ~/.os
./setup.sh
```

The script will present an interactive menu to choose what to configure:

- **Run all** - Configure both macOS defaults and Dock layout
- **macOS defaults only** - System preferences only
- **Dock layout only** - Dock apps and settings only

## What it does

### macOS defaults

Configures system preferences for:

- **Finder**: Show hidden files, use list view, show file extensions, enable text selection in Quick Look
- **Safari**: Enable developer tools, disable search suggestions to Apple, set blank homepage
- **Menu bar**: Hide WiFi, Battery, Spotlight, and Siri from menu bar
- **Screenshots**: Save as PNG, disable drop shadows
- **Security**: Require password immediately after sleep
- **Keyboard**: Enable key repeat (disable press-and-hold)
- **Activity Monitor**: Show all processes, sort by CPU usage
- **TextEdit**: Use plain text mode with UTF-8 encoding
- **General**: Expand save/print panels, disable app resume, enable auto-updates

See [macos/defaults.sh](macos/defaults.sh) for the complete list of changes.

### Dock layout

Clears the Dock and adds your preferred apps:

- Messages
- Development apps (if installed): Chrome, GitHub Desktop, Cursor, Xcode, VS Code, Figma, ChatGPT, Claude, Ghostty
- Downloads folder
- Disables recent apps section

See [macos/dock.sh](macos/dock.sh) for details.

**Note**: Dock configuration requires [dockutil](https://github.com/kcrawford/dockutil). Install with `brew install dockutil`.

## Sources

- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
- [jaywcjlove/awesome-mac](https://github.com/jaywcjlove/awesome-mac)
