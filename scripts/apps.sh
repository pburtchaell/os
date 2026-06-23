#!/bin/bash
# Description: Installs a selectable set of GUI applications via Homebrew Cask

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/utils.sh"
enable_simulate

space
log "Installing applications"

# Homebrew is required for cask installs
if ! command -v brew &>/dev/null && [ "${SIMULATE:-0}" != "1" ]; then
    error "Homebrew is required — run the development tools step first" 1
    exit 1
fi

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

log "Select applications to install:" 1
log "↑/↓ to move, space to select, enter to confirm" 1
space
select_multiple "${app_labels[@]}"

if [ ${#SELECTED_INDICES[@]} -eq 0 ]; then
    log "No applications selected" 1
else
    for idx in "${SELECTED_INDICES[@]}"; do
        IFS='|' read -r cask app label <<< "${cask_apps[$idx]}"
        if cask_installed "$cask" "$app"; then
            success "$label is already installed" 1
        elif ! spin "Installing $label..." brew install --cask "$cask"; then
            exit 1
        fi
    done
fi

success "Applications installed successfully"
exit 0
