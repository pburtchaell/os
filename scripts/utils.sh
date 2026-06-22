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
# Capability detection                                                        #
###############################################################################

# True when stdout is an interactive terminal and the `gum` CLI is on PATH.
# Used by spin to decide between gum's animated spinner and a plain
# headless run (e.g. piped output and the test suite, where stdout is captured).
# The interactive menus require gum unconditionally; ensure_gum guarantees it.
use_gum() {
    [ -t 1 ] && command -v gum &>/dev/null
}

###############################################################################
# gum bootstrap (temporary install)                                           #
###############################################################################

# All interactive prompts are powered by gum (https://github.com/charmbracelet/gum).
# Rather than install it permanently, the script fetches a temporary copy for the
# duration of the run and removes it on exit, so it leaves nothing behind.

# Pinned gum release used for the temporary install.
GUM_VERSION="0.17.0"

# Directory holding the temporary gum download; removed by cleanup() on exit.
GUM_TMPDIR=""

# Make the `gum` CLI available for the interactive prompts. If gum is already
# installed we use it as-is and leave it untouched. Otherwise we download a
# temporary copy for this run only — no Homebrew, no system changes — and put it
# first on PATH (inherited by the child scripts). cleanup() removes it on exit.
# Call this once, before the first prompt.
ensure_gum() {
    command -v gum &>/dev/null && return 0

    log "Getting ready..."

    local os arch name url
    os=$(uname -s)
    arch=$(uname -m)
    case "$arch" in
        arm64 | aarch64) arch="arm64" ;;
        x86_64 | amd64) arch="x86_64" ;;
        *) error "Unsupported architecture: $arch"; exit 1 ;;
    esac

    name="gum_${GUM_VERSION}_${os}_${arch}"
    url="https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/${name}.tar.gz"

    GUM_TMPDIR=$(mktemp -d)
    if ! curl -fsSL "$url" | tar -xz -C "$GUM_TMPDIR" 2>/dev/null; then
        error "Could not download gum from $url"
        exit 1
    fi
    if [ ! -x "$GUM_TMPDIR/$name/gum" ]; then
        error "gum binary missing after download"
        exit 1
    fi

    export PATH="$GUM_TMPDIR/$name:$PATH"
}

# Remove the temporary gum install, if any. Safe to call when none was made.
cleanup_gum() {
    [ -n "$GUM_TMPDIR" ] && rm -rf "$GUM_TMPDIR"
    GUM_TMPDIR=""
}

###############################################################################
# Message functions                                                           #
###############################################################################

# log / success / warn / error print a styled, single-line message.
#
# Pass an optional indent level as the second argument to nest the line under a
# heading: level 0 (default) is top-level and shows a status icon (→ ✓ ! ✗);
# level >0 indents 2 spaces per level and shows a ⎿ tree connector (colored by
# the message's status) in place of the icon.
#
#   log "Installing development tools"   ->  → Installing development tools
#   success "Homebrew installed" 1       ->    ⎿ Homebrew installed
_msg() {
    local color="$1" icon="$2" message="$3" indent="${4:-0}"
    if [ "$indent" -gt 0 ]; then
        printf "%*s${color}⎿${NC} %s\n" "$((indent * 2))" "" "$message"
    else
        printf "${color}${icon}${NC} %s\n" "$message"
    fi
}

log()     { _msg "$GRAY"   "" "$1" "${2:-0}"; }
success() { _msg "$GREEN"  "✓" "$1" "${2:-0}"; }
warn()    { _msg "$YELLOW" "!" "$1" "${2:-0}"; }
error()   { _msg "$RED"    "✗" "$1" "${2:-0}"; }

# confirm "Question?" — yes/no prompt via gum; returns 0 for yes, non-zero
# otherwise. Requires gum (guaranteed by ensure_gum at startup).
confirm() {
    gum confirm "$1"
}

###############################################################################
# Simulation (dry-run) mode                                                   #
###############################################################################

# When SIMULATE=1, replace mutating system commands with silent no-ops so the
# script's full UX can be walked through without changing the system. Read-only
# commands (command -v, brew list/info) are intentionally left intact, and the
# install spinner is handled separately in spin below.
#
# Call this once at the top of any script that performs system changes.
#
# The shadow functions below are invoked indirectly (when the real commands run
# later), so shellcheck's reachability analysis can flag them as unreachable
# (SC2317) on some versions. They are intentional, so silence it for this block.
# shellcheck disable=SC2317
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

# Combined exit handler: stop the sudo keep-alive and remove any temporary gum.
# Both halves are no-ops when their resource was never set up, so this is safe to
# install as the single EXIT/INT/TERM trap.
cleanup() {
    cleanup_sudo_keepalive
    cleanup_gum
}

# Request sudo access with a nice message, or confirm if already cached
# Also starts a background process to keep sudo alive
request_sudo() {
    if sudo -n true 2>/dev/null; then
        log "Sudo access already available, no password needed"
    else
        log "Your password is needed to change some system settings."
        sudo -v -p "Password: "
        success "Password received, thanks"
    fi

    # Keep sudo alive until the script finishes
    (while true; do sudo -n true; sleep 60; done) 2>/dev/null &
    SUDO_KEEPALIVE_PID=$!

    # Ensure cleanup on script exit (sudo keep-alive + any temporary gum)
    trap cleanup EXIT INT TERM
}

###############################################################################
# Spinner function                                                            #
###############################################################################

# spin "Installing X..." command [args...]
# Runs the command behind gum's animated spinner (or headlessly when stdout is
# not a terminal, e.g. CI / piped output). On completion prints an indented ✓/✗
# line and returns the command's exit status. In simulate mode the command is
# skipped but the result line is still shown.
#
# "Installing X..." is rendered as "X installed" on success.
spin() {
    local message="$1"; shift
    local label="$message" rc log_file

    if [[ "$message" =~ ^Installing[[:space:]](.+)\.\.\.$ ]]; then
        label="${BASH_REMATCH[1]} installed"
    fi

    if [ "${SIMULATE:-0}" = "1" ]; then
        use_gum && gum spin --spinner dot --title "$message" -- sleep 0.4
        success "$label" 1
        return 0
    fi

    if use_gum; then
        if gum spin --spinner dot --title "$message" --show-error -- "$@"; then
            success "$label" 1
            return 0
        else
            rc=$?
            error "Failed: $message" 1
            return "$rc"
        fi
    fi

    # Headless (piped output / CI): run the command, surface output on failure.
    log_file=$(mktemp)
    if "$@" &>"$log_file"; then
        rm -f "$log_file"
        success "$label" 1
        return 0
    else
        rc=$?
        [ -s "$log_file" ] && cat "$log_file" >&2
        rm -f "$log_file"
        error "Failed: $message" 1
        return "$rc"
    fi
}

###############################################################################
# Multi-select menu                                                           #
###############################################################################

# Multi-select checkbox menu (gum): ↑/↓ to move, space to toggle, enter to
# confirm. Requires gum (guaranteed by ensure_gum at startup).
# Usage: select_multiple "Option 1" "Option 2" ...
# Result: sets the SELECTED_INDICES array to the chosen option indices (may be
# empty if nothing was selected).
#
# `gum choose` prints the chosen labels (one per line); map them back to option
# indices to preserve the SELECTED_INDICES contract. Iterating options (not the
# chosen lines) keeps original order and is robust against duplicate labels.
select_multiple() {
    local options=("$@")
    SELECTED_INDICES=()

    local chosen
    if ! chosen=$(printf '%s\n' "${options[@]}" | gum choose --no-limit); then
        # Esc / ctrl-C cancels the selection — treat as nothing selected.
        return 0
    fi
    [ -z "$chosen" ] && return 0

    local i opt line
    for i in "${!options[@]}"; do
        opt="${options[$i]}"
        while IFS= read -r line; do
            if [ "$line" = "$opt" ]; then
                SELECTED_INDICES+=("$i")
                break
            fi
        done <<< "$chosen"
    done
}
