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
# Sudo functions                                                              #
###############################################################################

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
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
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
    
    # Start the command in background
    "${cmd[@]}" &>/dev/null &
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
        error "Failed to install"
        return 1
    fi
}
