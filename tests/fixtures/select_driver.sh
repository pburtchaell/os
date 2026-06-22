#!/usr/bin/env bash
# Test fixture: drives select_multiple() so its result can be asserted.
#
# Options are passed as arguments; simulated keystrokes are read from stdin.
# Prints the resulting SELECTED_INDICES (space-separated) to stdout.
#
# Run in its own process (not sourced) so select_multiple's EXIT trap is
# contained and never interferes with the test runner.

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/scripts/utils.sh"

select_multiple "$@" >/dev/null 2>&1

# select_multiple installs a cursor-restoring EXIT trap; clear it so its escape
# codes don't reach stdout and pollute the asserted result.
trap - RETURN EXIT INT TERM

# shellcheck disable=SC2154  # SELECTED_INDICES is set by select_multiple
echo "${SELECTED_INDICES[*]}"
