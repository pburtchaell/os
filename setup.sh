#!/bin/bash
# Description: Configures macOS system preferences for productive development work

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

###############################################################################
# Arrow key menu function                                                     #
###############################################################################

select_option() {
    local options=("$@")
    local selected=0
    local key

    # Hide cursor
    tput civis

    # Print menu
    print_menu() {
        for i in "${!options[@]}"; do
            if [ $i -eq $selected ]; then
                echo -e "  \033[1;32m> ${options[$i]}\033[0m"
            else
                echo "    ${options[$i]}"
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
                    ((selected--))
                    if [ $selected -lt 0 ]; then
                        selected=$((${#options[@]} - 1))
                    fi
                    ;;
                '[B') # Down arrow
                    ((selected++))
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
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⡿⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⢀⣠⣤⣤⣤⣀⣀⠈⠋⠉⣁⣠⣤⣤⣤⣀⡀⠀⠀"
echo "⠀⢠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀"
echo "⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠀"
echo "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀"
echo "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀"
echo "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀"
echo "⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⣀"
echo "⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁"
echo "⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁⠀"
echo "⠀⠀⠀⠈⠙⢿⣿⣿⣿⠿⠟⠛⠻⠿⣿⣿⣿⡿⠋⠀⠀⠀"
echo ""
echo "Hi! Let's configure your Mac for development."
echo ""

# Menu options
options=(
    "Run all (macOS defaults + Dock)"
    "macOS defaults only"
    "Dock layout only"
)

echo "What would you like to configure?"
echo ""

select_option "${options[@]}"
choice=$SELECTED_OPTION

echo ""
echo "Your password is needed to change some system settings."
echo ""

# Ask for administrator password upfront
sudo -v

# Keep sudo alive until the script finishes
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

case $choice in
    0)
        # Run all
        bash "$SCRIPT_DIR/macos/defaults.sh"
        bash "$SCRIPT_DIR/macos/dock.sh"
        ;;
    1)
        # macOS defaults only
        bash "$SCRIPT_DIR/macos/defaults.sh"
        ;;
    2)
        # Dock layout only
        bash "$SCRIPT_DIR/macos/dock.sh"
        ;;
esac

# Mark setup as complete
touch "$HOME/.osrc"

echo ""
echo "Setup complete!"

exit 0
