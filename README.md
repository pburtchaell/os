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

You can also opt-in to install: 
* [nvm](https://github.com/creationix/nvm), a version manager for Node
* [Yarn](https://yarnpkg.com/en/), an alternative to npm for installing dependencies

### 4. macOS System Preferences
Fourth, the script changes macOS system preferences for more productive design & development work on your Mac. See the [macos/setup.sh](/macos/setup.sh) script for a complete list of changes!

## Apps You Should Install 
### Hyper
[Hyper](https://hyper.is/), customized with the [Atom One Dark theme](https://www.npmjs.com/package/hyperterm-atom-dark), is my terminal. It's fast, customizable and looks great. I like that I can use the same theme (Atom One Dark) in both Hyper and Visual Studio Code. There's two plugins I recommend:
* [hyperlinks](https://www.npmjs.com/package/hyperlinks): Open URLs from terminal
* [hypercwd](https://www.npmjs.com/package/hypercwd): Open new tab with the same directory as the current tab

### Visual Studio Code
[Visual Studio Code](https://code.visualstudio.com/), again with the [Atom One Dark theme](https://github.com/akamud/vscode-theme-onedark) theme, is the terminal I use for my web development work.

[Quokka.js](https://quokkajs.com/) is a nice scratchpad for iterating through ideas in Visual Studio Code, but I also like using the [Framer X code playground]().

## My Inspiration
* [skwp/dotfiles](https://github.com/skwp/dotfiles)
* [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)

## My Reference
* [Shell Script Basics](https://developer.apple.com/library/content/documentation/OpenSource/Conceptual/ShellScripting/shell_scripts/shell_scripts.html) (Apple)
