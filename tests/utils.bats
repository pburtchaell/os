#!/usr/bin/env bats
# Unit tests for scripts/utils.sh
#
# The interactive prompts (select_option, select_multiple, the gum confirm) are
# powered by gum and read /dev/tty, so they can't be driven headlessly here;
# they aren't unit-tested. These tests cover the surrounding logic instead.

setup() {
  source "${BATS_TEST_DIRNAME}/../scripts/utils.sh"
}

@test "success() prints its message" {
  run success "All good"
  [ "$status" -eq 0 ]
  [[ "$output" == *"All good"* ]]
}

@test "use_gum() is false when stdout is not a terminal" {
  # Under `run`, stdout is captured (not a TTY), so spin must run commands
  # headlessly instead of showing gum's spinner — including in tests.
  run use_gum
  [ "$status" -ne 0 ]
}

@test "enable_simulate() does nothing when SIMULATE is unset" {
  enable_simulate
  [ "$(type -t defaults)" != "function" ]
}

@test "enable_simulate() shadows mutating commands when SIMULATE=1" {
  SIMULATE=1
  enable_simulate
  for cmd in defaults dockutil chflags killall sudo touch; do
    [ "$(type -t "$cmd")" = "function" ]
  done
}

@test "a shadowed command is a silent no-op that succeeds" {
  SIMULATE=1
  enable_simulate
  run defaults write com.apple.finder Foo -bool true
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "success() at indent level >0 shows the ⎿ connector" {
  run success "Nested" 1
  [ "$status" -eq 0 ]
  [[ "$output" == *"⎿"* ]]
  [[ "$output" == *"Nested"* ]]
}

@test "spin() runs the command in normal mode" {
  sentinel="${BATS_TEST_TMPDIR}/ran"
  spin "Working..." touch "$sentinel"
  [ -e "$sentinel" ]
}

@test "spin() propagates a failing exit code" {
  run spin "Working..." false
  [ "$status" -ne 0 ]
}

@test "spin() skips execution in simulate mode but reports success" {
  SIMULATE=1
  sentinel="${BATS_TEST_TMPDIR}/ran"
  run spin "Installing Thing..." touch "$sentinel"
  [ "$status" -eq 0 ]
  [ ! -e "$sentinel" ]
  [[ "$output" == *"Thing installed"* ]]
}
