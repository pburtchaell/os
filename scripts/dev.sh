#!/bin/bash
# Description: Installs development tools (Homebrew, Oh My Zsh, Node, pnpm, Python, Claude Code, Mole)
#              and offers a selectable list of GUI applications (Homebrew Casks).
#
# Note: This script downloads and executes installers from the internet (Homebrew, Oh My Zsh, Claude Code).
# While these are official installation methods over HTTPS, review the scripts if concerned:
#   - Homebrew: https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
#   - Oh My Zsh: https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
#   - Claude Code: https://claude.ai/install.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/utils.sh"
enable_simulate

echo ""
info "Installing development tools"

###############################################################################
# Homebrew                                                                     #
###############################################################################

if command -v brew &>/dev/null; then
    success "Homebrew is already installed"
elif [ "${SIMULATE:-0}" = "1" ]; then
    step_start "Installing Homebrew..."
    step_done "Homebrew installed"
else
    step_start "Installing Homebrew..."
    # Use NONINTERACTIVE to prevent prompts since we handle sudo separately
    if NONINTERACTIVE=1 /bin/bash -c "$(curl --fail -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        step_done "Homebrew installed"
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
            step "Note: Add this to your shell profile for persistent PATH:"
            echo "      eval \"\$(/opt/homebrew/bin/brew shellenv)\""
        fi
    else
        step_skip "Homebrew installation failed"
        exit 1
    fi
fi

###############################################################################
# Oh My Zsh                                                                    #
###############################################################################

if [ -d "$HOME/.oh-my-zsh" ]; then
    success "Oh My Zsh is already installed"
elif [ "${SIMULATE:-0}" = "1" ]; then
    step_start "Installing Oh My Zsh..."
    step_done "Oh My Zsh installed"
else
    step_start "Installing Oh My Zsh..."
    # Use --unattended to prevent prompts; note this may modify ~/.zshrc
    if sh -c "$(curl --fail -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
        step_done "Oh My Zsh installed"
    else
        step_skip "Oh My Zsh installation failed"
        exit 1
    fi
fi

###############################################################################
# Node.js                                                                      #
###############################################################################

if command -v node &>/dev/null; then
    success "Node.js is already installed ($(node --version))"
else
    if ! run_step "Installing Node.js..." brew install node; then
        exit 1
    fi
fi

###############################################################################
# pnpm                                                                         #
###############################################################################

if command -v pnpm &>/dev/null; then
    success "pnpm is already installed ($(pnpm --version))"
else
    if ! run_step "Installing pnpm..." brew install pnpm; then
        exit 1
    fi
fi

###############################################################################
# Python                                                                       #
###############################################################################

if brew list python &>/dev/null; then
    success "Python is already installed ($(python3 --version))"
else
    if ! run_step "Installing Python..." brew install python; then
        exit 1
    fi
fi

###############################################################################
# Claude Code                                                                  #
###############################################################################

if command -v claude &>/dev/null; then
    success "Claude Code is already installed"
elif [ "${SIMULATE:-0}" = "1" ]; then
    step_start "Installing Claude Code..."
    step_done "Claude Code installed"
else
    step_start "Installing Claude Code..."
    # Native installer (https://claude.ai/install.sh)
    if bash -c "$(curl --fail -fsSL https://claude.ai/install.sh)"; then
        step_done "Claude Code installed"
    else
        step_skip "Claude Code installation failed"
        exit 1
    fi
fi

###############################################################################
# Mole                                                                         #
###############################################################################

if command -v mole &>/dev/null; then
    success "Mole is already installed"
else
    if ! run_step "Installing Mole..." brew install mole; then
        exit 1
    fi
fi

###############################################################################
# GUI applications (Homebrew Casks)                                           #
###############################################################################

# Offered apps, as "cask|/Applications/Name.app|Label"
cask_apps=(
    # Browsers
    "google-chrome|/Applications/Google Chrome.app|Google Chrome"
    "vivaldi|/Applications/Vivaldi.app|Vivaldi"
    "firefox|/Applications/Firefox.app|Firefox"
    # Dev & AI
    "ghostty|/Applications/Ghostty.app|Ghostty"
    "visual-studio-code|/Applications/Visual Studio Code.app|Visual Studio Code"
    "cursor|/Applications/Cursor.app|Cursor"
    "github|/Applications/GitHub Desktop.app|GitHub Desktop"
    "claude|/Applications/Claude.app|Claude Desktop"
    "superwhisper|/Applications/superwhisper.app|superwhisper"
    # Design & media
    "figma|/Applications/Figma.app|Figma"
    "cleanshot|/Applications/CleanShot X.app|CleanShot X"
    "imageoptim|/Applications/ImageOptim.app|ImageOptim"
    # Productivity
    "1password|/Applications/1Password.app|1Password"
    "paste|/Applications/Paste.app|Paste"
    "stats|/Applications/Stats.app|Stats"
    "dropbox|/Applications/Dropbox.app|Dropbox"
    "flux|/Applications/Flux.app|Flux"
    # Comms & media
    "discord|/Applications/Discord.app|Discord"
    "zoom|/Applications/zoom.us.app|Zoom"
    "spotify|/Applications/Spotify.app|Spotify"
    "sonos|/Applications/Sonos.app|Sonos"
    # Maker / 3D
    "bambu-studio|/Applications/BambuStudio.app|Bambu Studio"
    "openscad|/Applications/OpenSCAD.app|OpenSCAD"
    "raspberry-pi-imager|/Applications/Raspberry Pi Imager.app|Raspberry Pi Imager"
)

# Helper: is a cask already installed (app present or registered with brew)?
cask_installed() {
    local cask="$1" app="$2"
    [ -d "$app" ] || brew list --cask "$cask" &>/dev/null
}

# Build menu labels, flagging apps that are already installed
app_labels=()
for entry in "${cask_apps[@]}"; do
    IFS='|' read -r cask app label <<< "$entry"
    if cask_installed "$cask" "$app"; then
        app_labels+=("$label (installed)")
    else
        app_labels+=("$label")
    fi
done

echo ""
step "Select applications to install:"
step "↑/↓ to move, space to select, enter to confirm"
echo ""
select_multiple "${app_labels[@]}"

if [ ${#SELECTED_INDICES[@]} -eq 0 ]; then
    step "No applications selected"
else
    for idx in "${SELECTED_INDICES[@]}"; do
        IFS='|' read -r cask app label <<< "${cask_apps[$idx]}"
        if cask_installed "$cask" "$app"; then
            success "$label is already installed"
        elif ! run_step "Installing $label..." brew install --cask "$cask"; then
            exit 1
        fi
    done
fi

confirm "Development tools installed successfully"
exit 0
