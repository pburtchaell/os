#!/bin/bash
# Description: Configures macOS system preferences for productive development work

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/scripts/utils.sh"

###############################################################################
# Arrow key menu function                                                     #
###############################################################################

select_option() {
    local options=("$@")
    local selected=0
    local key

    # Hide cursor and ensure it's restored on exit/interrupt
    tput civis
    trap 'tput cnorm' RETURN EXIT INT TERM

    # Print menu
    print_menu() {
        local last_index=$((${#options[@]} - 1))
        for i in "${!options[@]}"; do
            if [ $i -eq $selected ]; then
                if [ $i -eq $last_index ]; then
                    # Exit option selected - red
                    echo -e "    \033[1;31m> ${options[$i]}\033[0m"
                else
                    # Normal option selected - blue
                    echo -e "    \033[1;34m> ${options[$i]}\033[0m"
                fi
            else
                echo "      ${options[$i]}"
            fi
        done
    }

    # Clear menu lines
    clear_menu() {
        for _ in "${options[@]}"; do
            tput cuu1
            tput el
        done
    }

    print_menu

    while true; do
        # Read single character
        IFS= read -rsn1 key

        # Handle arrow keys (escape sequences)
        if [[ $key == $'\x1b' ]]; then
            read -rsn2 key
            case $key in
                '[A') # Up arrow
                    selected=$((selected - 1))
                    if [ $selected -lt 0 ]; then
                        selected=$((${#options[@]} - 1))
                    fi
                    ;;
                '[B') # Down arrow
                    selected=$((selected + 1))
                    if [ $selected -ge ${#options[@]} ]; then
                        selected=0
                    fi
                    ;;
            esac
        elif [[ $key == "" ]]; then
            # Enter key pressed
            break
        fi

        clear_menu
        print_menu
    done

    # Show cursor
    tput cnorm

    # Set global variable instead of return (to avoid set -e issues)
    SELECTED_OPTION=$selected
}

###############################################################################
# Main script                                                                 #
###############################################################################

echo ""
echo "      ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⠀⠀⠀⠀⠀⠀"
echo "      ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⡿⠀⠀⠀⠀⠀⠀"
echo "      ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀"
echo "      ⠀⠀⠀⢀⣠⣤⣤⣤⣀⣀⠈⠋⠉⣁⣠⣤⣤⣤⣀⡀⠀⠀"
echo "      ⠀⢠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀"
echo "      ⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠀"
echo "      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀"
echo "      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀"
echo "      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀"
echo "      ⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⣀"
echo "      ⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁"
echo "      ⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁⠀"
echo "      ⠀⠀⠀⠈⠙⢿⣿⣿⣿⠿⠟⠛⠻⠿⣿⣿⣿⡿⠋⠀⠀⠀"
# Get username and time-based greeting
username=$(whoami)
hour=$(date +%H)

if [ "$hour" -ge 5 ] && [ "$hour" -lt 12 ]; then
    greeting="Good morning $username"
elif [ "$hour" -ge 12 ] && [ "$hour" -lt 17 ]; then
    greeting="Good afternoon $username"
elif [ "$hour" -ge 17 ] && [ "$hour" -lt 21 ]; then
    greeting="Good evening $username"
else
    greeting="Hey $username, you night owl"
fi

echo ""
echo "  $greeting, how can I help you setup your Mac today?"
echo ""

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
if [ $choice -eq $((${#options[@]} - 1)) ]; then
    echo ""
    echo "  Goodbye!"
    exit 0
fi

echo ""

# Request sudo only for options that need it (defaults and dev tools)
if [ $choice -eq 0 ] || [ $choice -eq 2 ] || [ $choice -eq 3 ]; then
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

# Mark setup as complete
touch "$HOME/.osrc"

echo ""
echo -e "  ${BOLD}Setup complete${NC} ${RED}♥${NC}"
exit 0
