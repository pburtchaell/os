#!/bin/bash
# Description: Configures macOS system preferences for productive development work

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/scripts/utils.sh"

###############################################################################
# Arguments                                                                   #
###############################################################################

# Default from the environment so `SIMULATE=1 ./setup.sh` / `VERBOSE=1 ./setup.sh`
# work too (e.g. through the remote bootstrap, which can't forward flags).
SIMULATE="${SIMULATE:-0}"
VERBOSE="${VERBOSE:-0}"
for arg in "$@"; do
    case "$arg" in
        -s|--simulate|--dry-run)
            SIMULATE=1
            ;;
        -v|--verbose)
            VERBOSE=1
            ;;
        -h|--help)
            echo "Usage: ./setup.sh [--simulate] [--verbose]"
            echo ""
            echo "  -s, --simulate              Walk through the full flow without making any changes"
            echo "  -v, --verbose               Stream installer output live instead of a spinner"
            echo "  -h, --help                  Show this help"
            exit 0
            ;;
        *)
            echo "Unknown option: $arg" >&2
            echo "Run './setup.sh --help' for usage." >&2
            exit 1
            ;;
    esac
done
# Exported so the scripts/*.sh child scripts inherit simulate/verbose mode
export SIMULATE VERBOSE

###############################################################################
# Menu function                                                               #
###############################################################################

# Single-select menu (gum). Requires gum (guaranteed by ensure_gum at startup).
# Maps the chosen label back to its index and sets SELECTED_OPTION. Cancelling
# (esc / ctrl-C) selects the final option, which is the "Exit" entry.
select_option() {
    local options=("$@")
    local chosen i

    if ! chosen=$(printf '%s\n' "${options[@]}" | gum choose); then
        SELECTED_OPTION=$((${#options[@]} - 1))
        return 0
    fi

    for i in "${!options[@]}"; do
        if [ "${options[$i]}" = "$chosen" ]; then
            SELECTED_OPTION=$i
            return 0
        fi
    done

    SELECTED_OPTION=$((${#options[@]} - 1))
}

###############################################################################
# Main script                                                                 #
###############################################################################

# All menus require gum; install a temporary copy if needed and make sure it
# (and the sudo keep-alive) is cleaned up on exit.
trap cleanup EXIT INT TERM
ensure_gum

# Time-based greeting
hour=$(date +%H)

if [ "$hour" -ge 5 ] && [ "$hour" -lt 12 ]; then
    greeting="Good morning"
elif [ "$hour" -ge 12 ] && [ "$hour" -lt 17 ]; then
    greeting="Good afternoon"
elif [ "$hour" -ge 17 ] && [ "$hour" -lt 21 ]; then
    greeting="Good evening"
else
    greeting="Hey night owl"
fi

echo "$greeting, how can I help?"
space

# Menu options
options=(
    "Update macOS settings and apps with their preferred defaults"
    "Update macOS dock with its preferred apps and layout"
    "Install development tools (Brew, Oh My Zsh, Node, pnpm & Claude Code)"
    "Install applications (Chrome, Figma, Spotify & more)"
    "All of the above"
    "Exit"
)

select_option "${options[@]}"
choice=$SELECTED_OPTION

# Handle exit option (last item in array)
if [ "$choice" -eq $((${#options[@]} - 1)) ]; then
    space
    echo "Goodbye!"
    exit 0
fi

space

# Request sudo only for options that need it (defaults, dev tools, apps, all),
# and never in simulate mode
if [ "$SIMULATE" != "1" ] && { [ "$choice" -eq 0 ] || [ "$choice" -eq 2 ] || [ "$choice" -eq 3 ] || [ "$choice" -eq 4 ]; }; then
    request_sudo
fi

case $choice in
    0)
        # macOS defaults only
        bash "$SCRIPT_DIR/scripts/defaults.sh" || exit 1
        ;;
    1)
        # Dock layout only
        bash "$SCRIPT_DIR/scripts/dock.sh" || exit 1
        ;;
    2)
        # Dev tools only
        bash "$SCRIPT_DIR/scripts/dev.sh" || exit 1
        ;;
    3)
        # Applications only
        bash "$SCRIPT_DIR/scripts/apps.sh" || exit 1
        ;;
    4)
        # Run all
        bash "$SCRIPT_DIR/scripts/defaults.sh" || exit 1
        bash "$SCRIPT_DIR/scripts/dock.sh" || exit 1
        bash "$SCRIPT_DIR/scripts/dev.sh" || exit 1
        bash "$SCRIPT_DIR/scripts/apps.sh" || exit 1
        ;;
esac

# Mark setup as complete (skipped in simulate mode)
if [ "$SIMULATE" != "1" ]; then
    touch "$HOME/.osrc"
fi

space
printf "${BOLD}Setup complete${NC} ${RED}♥${NC}\n"
exit 0
