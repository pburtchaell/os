# os

OS installs the tools I use on a daily basis for design and development work on macOS

## :warning: Warning

This is a work in progress!

Known Issues:

- [rvm does not install](https://github.com/pburtchaell/os/issues/3)
- [nvm does not install](https://github.com/pburtchaell/os/issues/2)
- [apps are not installed](https://github.com/pburtchaell/os/issues/4)

## Getting Started

To clone the repository and install everything, run this line in Terminal:

```
sh -c "`curl -fsSL https://raw.githubusercontent.com/pburtchaell/os/master/install.sh`"
```

You'll see an output a bit like this:

```
Cloning Git repository...
Cloning into '/Users/pburtchaell/.os'...
remote: Counting objects: 18, done.
remote: Compressing objects: 100% (14/14), done.
remote: Total 18 (delta 0), reused 16 (delta 0), pack-reused 0
Unpacking objects: 100% (18/18), done.
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

This script sets reasonable defaults and settings for macOS. This includes:

- Finder
- Mail
- Calendar
- Safari
- Terminal
- etc.

If you're curious, [you can read through it](/macos/setup.sh) to see everything.

### Apps

The following apps are installed via [Homebrew Cask](https://caskroom.github.io/):

- [Atom Editor](https://atom.io/) (Code editor of choice)
- Chrome
- Dropbox
- Firefox
- [GitHub Desktop](https://desktop.github.com/)
- Slack
- Spotify
- [Paw](https://paw.cloud/) (API tool and HTTP client)

### Design Tools

The following design tools/apps are installed via [Homebrew Cask](https://caskroom.github.io/):

- [Sketch](https://www.sketchapp.com/)
- [Adobe Creative Cloud](https://www.adobe.com/)
- [Framer Studio](https://framer.com/)
- [Origami Studio](https://origami.design/)

### Development Tools

#### Homebrew

[Homebrew](https://brew.sh/) is "the missing package manager for macOS." It enables me to install a lot of software from the command line. To see if an app can be installed with Homebrew Cask, [search here](https://caskroom.github.io/search).

#### Node

The stable version of Node is installed via nvm and set to the default.

The following tools are also installed:

- [nvm](https://github.com/creationix/nvm): Version manager for Node
- [Yarn](https://yarnpkg.com/en/): Fast dependency manager
- [Create React App](https://github.com/facebookincubator/create-react-app): React starter app
- [Create React Native App](https://github.com/react-community/create-react-native-app): React Native starter app
- [Gatsby](https://www.gatsbyjs.org/): React static site generator
- [Serve](https://github.com/zeit/serve): Static file server

#### Ruby

The stable version of Ruby is installed via rvm.

The following tools are also installed:

- [rvm](https://github.com/rvm/rvm): Ruby version manager
- [Bundler](https://bundler.io/): Ruby gems manager
- [Ruby on Rails](https://github.com/rails/rails): Web app framework
- [Foreman](https://github.com/ddollar/foreman): Manage Procfile based applications

#### Hyper

The latest version of [Hyper](https://github.com/zeit/hyper) is installed with Homebrew.

The following plugins are also installed:

- [hyperterm-atom-dark](https://www.npmjs.com/package/hyperterm-atom-dark): Theme based on the Atom One Dark theme
- [hyperlinks](https://www.npmjs.com/package/hyperlinks): Link URLs
- [hypercwd](https://www.npmjs.com/package/hypercwd): Open new tab with the same directory as the current tab

## But wait, that's not all!

The scripts can't handle everything, unfortunately. There's a few other things to do.

### Atom Editor

Install the following plugins:

- [linter]( https://atom.io/packages/linter)
- [linter-eslint](https://atom.io/packages/linter-eslint)
- [atom-quokka](https://atom.io/packages/atom-quokka): JS sandbox in the editor

Also make sure to setup [the GitHub integration](https://github.atom.io/) so you can see pull requests in the editor.

### Visual Studio Code

When paired with [Quokka.js](https://quokkajs.com/), VS Code is a great playground for JS.

1. Install [VS Code](https://code.visualstudio.com/)
2. Install Quokka.js extenstion
3. Install [Atom One Dark theme](https://github.com/akamud/vscode-theme-onedark) (to match Atom Editor and Hyper)
4. Install [Atom Keymap extenstion](https://github.com/Microsoft/vscode-atom-keybindings) (to use Atom Editor keymaps)

You need to install extensions directly in VS Code.

### macOS

- [Fliqlo](https://fliqlo.com/): flip clock screensaver

## Original Inspiration

I'd like to give a big thanks to the people to inspired me to write these scripts.

- [skwp/dotfiles](https://github.com/skwp/dotfiles)
- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)

## Reference

- [Shell Script Basics](https://developer.apple.com/library/content/documentation/OpenSource/Conceptual/ShellScripting/shell_scripts/shell_scripts.html)

---
Copyright 2016-2018 Patrick Burtchaell. Licensed MIT.
