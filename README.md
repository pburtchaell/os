# os
This is a simple, reliable and safe script to:
* Install web dev tools like Node and npm on your Mac 
* Customize the macOS system preferences for productive design & web development work

## Getting Started
To install everything, run this line in your terminal:
```
sh -c "`curl -fsSL https://raw.githubusercontent.com/pburtchaell/os/master/install.sh`"
```

This will clone the repo from GitHub and run the script.

## What Happens on Your Mac
### 1. Homebrew
First things first. The script will install [Homebrew](https://brew.sh/), a useful package manager for macOS. Later on, Homebrew will be used to install Zsh, Node and other development tools.

### 2. Zsh
Second, your shell will be configured to use [Zsh](http://www.zsh.org/). macOS ships with Zsh, but it's outdated and not tied to Homebrew. By reinstalling Zsh with Homebrew, you'll get the latest version. [Oh My Zsh](https://ohmyz.sh/), a framework for customizing Zsh, will also be installed.

### 3. Node.js
Third, Homebrew will install the latest version of [Node.js](https://nodejs.org/en/). 

### 4. macOS System Preferences
Fourth, the script changes macOS system preferences for more productive design & development work on your Mac. See the [macos/setup.sh](/macos/setup.sh) script for a complete list of changes!

## Apps to Install
* [VS Code](https://code.visualstudio.com/)

## Sources
* [jaywcjlove/awesome-mac](https://github.com/jaywcjlove/awesome-mac)

## Inspiration
* [skwp/dotfiles](https://github.com/skwp/dotfiles)
* [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
