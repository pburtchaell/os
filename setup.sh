#!/bin/bash
# Description: Configures macOS system preferences for productive development work

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/scripts/utils.sh"

###############################################################################
# Arguments                                                                   #
###############################################################################

SIMULATE=0
for arg in "$@"; do
    case "$arg" in
        -s|--simulate|--dry-run)
            SIMULATE=1
            ;;
        -h|--help)
            echo "Usage: ./setup.sh [--simulate]"
            echo ""
            echo "  -s, --simulate              Walk through the full flow without making any changes"
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
# Exported so the scripts/*.sh child scripts inherit simulate mode
export SIMULATE

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

echo "  $greeting, how can I help you setup your Mac today?"

# Menu options
options=(
    "Update macOS settings and apps with their preferred defaults"
    "Update macOS dock with its preferred apps and layout"
    "Install development tools (Brew, Oh My Zsh, Node, pnpm & Claude Code)"
    "All of the above"
    "Exit"
)

select_option "${options[@]}"
choice=$SELECTED_OPTION

# Handle exit option (last item in array)
if [ "$choice" -eq $((${#options[@]} - 1)) ]; then
    echo ""
    echo "Goodbye!"
    exit 0
fi

echo ""

# Request sudo only for options that need it (defaults and dev tools), and
# never in simulate mode
if [ "$SIMULATE" != "1" ] && { [ "$choice" -eq 0 ] || [ "$choice" -eq 2 ] || [ "$choice" -eq 3 ]; }; then
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
        # Run all
        bash "$SCRIPT_DIR/scripts/defaults.sh" || exit 1
        bash "$SCRIPT_DIR/scripts/dock.sh" || exit 1
        bash "$SCRIPT_DIR/scripts/dev.sh" || exit 1
        ;;
esac

# Mark setup as complete (skipped in simulate mode)
if [ "$SIMULATE" != "1" ]; then
    touch "$HOME/.osrc"
fi

echo ""
printf "  ${BOLD}Setup complete${NC} ${RED}♥${NC}\n"
exit 0
