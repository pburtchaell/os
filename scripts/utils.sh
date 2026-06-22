#!/bin/bash
# Description: Shared utility functions for setup scripts

###############################################################################
# Colors                                                                      #
###############################################################################

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
GRAY='\033[0;90m'
BOLD='\033[1m'
NC='\033[0m' # No Color

###############################################################################
# Message functions                                                           #
###############################################################################

# Level 1: Info/confirmation messages (2 spaces)
info() {
    echo -e "  ${GRAY}→${NC} $1"
}

confirm() {
    echo -e "  ${GREEN}✓${NC} $1"
}

# Level 2: Steps (4 spaces)
success() {
    echo -e "    ${GREEN}✓${NC} $1"
}

warn() {
    echo -e "    ${YELLOW}!${NC} $1"
}

error() {
    echo -e "    ${RED}✗${NC} $1"
}

step() {
    echo -e "    ${GRAY}→${NC} $1"
}

step_start() {
    printf "    ${GRAY}→${NC} %s" "$1"
}

step_done() {
    printf "\r\033[K    ${GREEN}✓${NC} %s\n" "$1"
}

step_skip() {
    printf "\r\033[K    ${YELLOW}!${NC} %s\n" "$1"
}

# Level 3: Sub-steps (6 spaces)
substep_start() {
    printf "      ${GRAY}→${NC} %s" "$1"
}

substep_done() {
    printf "\r\033[K      ${GREEN}✓${NC} %s\n" "$1"
}

substep_skip() {
    printf "\r\033[K      ${YELLOW}!${NC} %s\n" "$1"
}

###############################################################################
# Simulation (dry-run) mode                                                   #
###############################################################################

# When SIMULATE=1, replace mutating system commands with silent no-ops so the
# script's full UX can be walked through without changing the system. Read-only
# commands (command -v, brew list/info) are intentionally left intact, and the
# install spinner is handled separately in run_with_spinner below.
#
# Call this once at the top of any script that performs system changes.
enable_simulate() {
    [ "${SIMULATE:-0}" = "1" ] || return 0

    defaults() { :; }
    dockutil() { :; }
    chflags()  { :; }
    killall()  { :; }
    sudo()     { :; }
    touch()    { :; }
}

###############################################################################
# Sudo functions                                                              #
###############################################################################

# PID of the sudo keep-alive background process
SUDO_KEEPALIVE_PID=""

# Cleanup function to kill sudo keep-alive process
cleanup_sudo_keepalive() {
    if [ -n "$SUDO_KEEPALIVE_PID" ] && kill -0 "$SUDO_KEEPALIVE_PID" 2>/dev/null; then
        kill "$SUDO_KEEPALIVE_PID" 2>/dev/null
    fi
}

# Request sudo access with a nice message, or confirm if already cached
# Also starts a background process to keep sudo alive
request_sudo() {
    if sudo -n true 2>/dev/null; then
        echo -e "  Sudo access already available, no password needed"
    else
        echo -e "  Your password is needed to change some system settings."
        sudo -v -p "  Password: "
        printf "\r\033[K  ${GREEN}✓${NC} Password received, thanks\n"
    fi

    # Keep sudo alive until the script finishes
    (while true; do sudo -n true; sleep 60; done) 2>/dev/null &
    SUDO_KEEPALIVE_PID=$!

    # Ensure cleanup on script exit
    trap cleanup_sudo_keepalive EXIT INT TERM
}

###############################################################################
# Spinner function                                                            #
###############################################################################

# Spinner frames
SPINNER_FRAMES='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'

# Run a command with a spinner
# Usage: run_with_spinner "Installing package..." command arg1 arg2
run_with_spinner() {
    local message="$1"
    shift
    local cmd=("$@")

    # In simulate mode, show the spinner briefly but never run the command
    if [ "${SIMULATE:-0}" = "1" ]; then
        local n
        for ((n = 0; n < 8; n++)); do
            printf "\r  ${BLUE}%s${NC} %s" "${SPINNER_FRAMES:$((n % ${#SPINNER_FRAMES})):1}" "$message"
            sleep 0.05
        done
        printf "\r\033[K"
        return 0
    fi

    # Create temp file for capturing output
    local log_file
    log_file=$(mktemp)

    # Start the command in background, capturing output for debugging
    "${cmd[@]}" &>"$log_file" &
    local pid=$!

    local i=0
    local delay=0.1

    # Show spinner while command runs
    while kill -0 $pid 2>/dev/null; do
        local frame="${SPINNER_FRAMES:$i:1}"
        printf "\r  ${BLUE}%s${NC} %s" "$frame" "$message"
        i=$(( (i + 1) % ${#SPINNER_FRAMES} ))
        sleep $delay
    done

    # Wait for command to finish and get exit code
    wait $pid
    local exit_code=$?

    # Clear the spinner line
    printf "\r\033[K"

    # On failure, show the captured output for debugging
    if [ $exit_code -ne 0 ] && [ -s "$log_file" ]; then
        echo -e "    ${GRAY}--- Command output ---${NC}" >&2
        cat "$log_file" >&2
        echo -e "    ${GRAY}----------------------${NC}" >&2
    fi

    rm -f "$log_file"
    return $exit_code
}

# Run a command with spinner and show success/failure
# Usage: run_step "Installing package..." command arg1 arg2
# The message "Installing X..." becomes "X installed" on success
run_step() {
    local message="$1"
    shift
    
    # Transform "Installing X..." to "X installed" for success message
    local success_message="$message"
    if [[ "$message" =~ ^Installing[[:space:]](.+)\.\.\.$  ]]; then
        local name="${BASH_REMATCH[1]}"
        success_message="$name installed"
    fi
    
    if run_with_spinner "$message" "$@"; then
        success "$success_message"
        return 0
    else
        error "Failed: $message"
        return 1
    fi
}

###############################################################################
# Multi-select menu                                                           #
###############################################################################

# Multi-select checkbox menu: ↑/↓ to move, space to toggle, enter to confirm.
# Usage: select_multiple "Option 1" "Option 2" ...
# Result: sets the SELECTED_INDICES array to the chosen option indices (may be
# empty if nothing was selected).
select_multiple() {
    local options=("$@")
    local count=${#options[@]}
    local cursor=0
    local key
    local i
    local -a checked
    for ((i = 0; i < count; i++)); do
        checked[i]=0
    done

    # Hide cursor and ensure it's restored on exit/interrupt
    tput civis
    trap 'tput cnorm' RETURN EXIT INT TERM

    print_menu() {
        for i in "${!options[@]}"; do
            local box="[ ]"
            if [ "${checked[$i]}" -eq 1 ]; then
                box="[x]"
            fi
            if [ "$i" -eq "$cursor" ]; then
                echo -e "    \033[1;34m> ${box} ${options[$i]}\033[0m"
            else
                echo -e "      ${box} ${options[$i]}"
            fi
        done
    }

    clear_menu() {
        for _ in "${options[@]}"; do
            tput cuu1
            tput el
        done
    }

    print_menu

    while true; do
        IFS= read -rsn1 key

        if [[ $key == $'\x1b' ]]; then
            read -rsn2 key
            case $key in
                '[A') # Up arrow
                    cursor=$((cursor - 1))
                    if [ $cursor -lt 0 ]; then
                        cursor=$((count - 1))
                    fi
                    ;;
                '[B') # Down arrow
                    cursor=$((cursor + 1))
                    if [ "$cursor" -ge "$count" ]; then
                        cursor=0
                    fi
                    ;;
            esac
        elif [[ $key == " " ]]; then
            # Space toggles the current item
            if [ "${checked[cursor]}" -eq 1 ]; then
                checked[cursor]=0
            else
                checked[cursor]=1
            fi
        elif [[ $key == "" ]]; then
            # Enter confirms the selection
            break
        fi

        clear_menu
        print_menu
    done

    # Show cursor
    tput cnorm

    SELECTED_INDICES=()
    for ((i = 0; i < count; i++)); do
        if [ "${checked[$i]}" -eq 1 ]; then
            SELECTED_INDICES+=("$i")
        fi
    done
}
