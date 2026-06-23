#!/bin/bash
# Description: Installs selected development tools (Homebrew, Oh My Zsh, Node, pnpm, Python, Claude Code, Mole)
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

space
log "Installing development tools"

# Offered tools, as "key|Label"
dev_tools=(
    "homebrew|Homebrew"
    "ohmyzsh|Oh My Zsh"
    "node|Node.js"
    "pnpm|pnpm"
    "python|Python"
    "claude|Claude Code"
    "mole|Mole"
)

# Is a tool already installed?
tool_installed() {
    case "$1" in
        homebrew) command -v brew &>/dev/null ;;
        ohmyzsh)  [ -d "$HOME/.oh-my-zsh" ] ;;
        node)     command -v node &>/dev/null ;;
        pnpm)     command -v pnpm &>/dev/null ;;
        python)   brew list python &>/dev/null ;;
        claude)   command -v claude &>/dev/null ;;
        mole)     command -v mole &>/dev/null ;;
    esac
}

# Install a single tool. The curl-based installers are wrapped in `bash -c` so
# the download is deferred into spin (and therefore skipped in simulate mode).
install_tool() {
    case "$1" in
        homebrew)
            # NONINTERACTIVE prevents prompts since we handle sudo separately.
            # Single-quoted on purpose: the curl runs inside spin (deferred so
            # simulate skips it), not at expansion time.
            # shellcheck disable=SC2016
            spin "Installing Homebrew..." bash -c 'NONINTERACTIVE=1 /bin/bash -c "$(curl --fail -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"' || return 1
            # Add Homebrew to PATH for Apple Silicon Macs
            if [ "${SIMULATE:-0}" != "1" ] && [ -f "/opt/homebrew/bin/brew" ]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
                log "Add this to your shell profile for persistent PATH:" 1
                echo "eval \"\$(/opt/homebrew/bin/brew shellenv)\""
            fi
            ;;
        ohmyzsh)
            # --unattended prevents prompts; note this may modify ~/.zshrc.
            # Single-quoted on purpose (deferred curl); see Homebrew above.
            # shellcheck disable=SC2016
            spin "Installing Oh My Zsh..." bash -c 'sh -c "$(curl --fail -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
            ;;
        node)   spin "Installing Node.js..." brew install node ;;
        pnpm)   spin "Installing pnpm..." brew install pnpm ;;
        python) spin "Installing Python..." brew install python ;;
        claude) spin "Installing Claude Code..." bash -c 'curl --fail -fsSL https://claude.ai/install.sh | bash' ;;
        mole)   spin "Installing Mole..." brew install mole ;;
    esac
}

# Build labels (flag installed tools) and pre-select the ones not yet installed
tool_labels=()
PRESELECTED=()
for entry in "${dev_tools[@]}"; do
    IFS='|' read -r key label <<< "$entry"
    if tool_installed "$key"; then
        tool_labels+=("$label (installed)")
    else
        tool_labels+=("$label")
        PRESELECTED+=("$label")
    fi
done

log "Select development tools to install:" 1
log "↑/↓ to move, space to select, enter to confirm" 1
space
select_multiple "${tool_labels[@]}"

if [ ${#SELECTED_INDICES[@]} -eq 0 ]; then
    log "No development tools selected" 1
else
    for idx in "${SELECTED_INDICES[@]}"; do
        IFS='|' read -r key label <<< "${dev_tools[$idx]}"
        if tool_installed "$key"; then
            success "$label is already installed" 1
        elif ! install_tool "$key"; then
            exit 1
        fi
    done
fi

success "Development tools installed successfully"
exit 0
