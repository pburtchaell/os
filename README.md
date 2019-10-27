# os

Installs the tools I use on a daily basis for design and development work on macOS.

## Getting Started

To clone the repository and install everything, run this line in Terminal:

```
sh -c "`curl -fsSL https://raw.githubusercontent.com/pburtchaell/os/master/install.sh`"
```

You'll see an output a bit like this:

```
Cloning Git repository...
Setting up Homebrew...
Checking for Homewbrew updates...
Updating Homebrew...
Installing Homebrew packages...
Tapping into Homebrew casks...
Would you like to install nvm and Node (y/n): y
Installing commonly used npm packages...
Would you like to install Create React Native App (y/n): y
Would you like to install Create React App (y/n): y
Would you like to install Gatsby (y/n): y
Would you like to install rvm and Ruby (y/n): y
...
```

## What's Included

### macOS Setup

This script changes the macOS settings and preferences to my taste. Read [macos/setup.sh](/macos/setup.sh) to see.

### Development Tools

#### Homebrew

[Homebrew](https://brew.sh/) is "the missing package manager for macOS."
#### Node

The stable version of Node is installed via nvm and set to the default.

The following tools are also installed:

- [nvm](https://github.com/creationix/nvm): Version manager for Node
- [Yarn](https://yarnpkg.com/en/): Fast dependency manager

#### Hyper

The latest version of [Hyper](https://github.com/zeit/hyper) is installed with Homebrew.

The following plugins are also installed:

- [hyperterm-atom-dark](https://www.npmjs.com/package/hyperterm-atom-dark): Theme based on the Atom One Dark theme
- [hyperlinks](https://www.npmjs.com/package/hyperlinks): Link URLs
- [hypercwd](https://www.npmjs.com/package/hypercwd): Open new tab with the same directory as the current tab

## But wait, that's not all!

### Visual Studio Code

When paired with [Quokka.js](https://quokkajs.com/), VS Code is a great playground for JS.

1. Install [VS Code](https://code.visualstudio.com/)
2. Install Quokka.js extenstion
3. Install [Atom One Dark theme](https://github.com/akamud/vscode-theme-onedark) (to match Atom Editor and Hyper)
4. Install [Atom Keymap extenstion](https://github.com/Microsoft/vscode-atom-keybindings) (to use Atom Editor keymaps)

You need to install extensions directly in VS Code.

## Original Inspiration

I'd like to give a big thanks to the people to inspired me to write these scripts.

- [skwp/dotfiles](https://github.com/skwp/dotfiles)
- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)

## Reference

- [Shell Script Basics](https://developer.apple.com/library/content/documentation/OpenSource/Conceptual/ShellScripting/shell_scripts/shell_scripts.html)

---
Copyright 2016-2018 Patrick Burtchaell. Licensed MIT.
