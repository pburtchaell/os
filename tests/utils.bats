#!/usr/bin/env bats
# Unit tests for scripts/utils.sh

DRIVER="${BATS_TEST_DIRNAME}/fixtures/select_driver.sh"

setup() {
  source "${BATS_TEST_DIRNAME}/../scripts/utils.sh"
}

@test "success() prints its message" {
  run success "All good"
  [ "$status" -eq 0 ]
  [[ "$output" == *"All good"* ]]
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

@test "run_with_spinner() executes the command in normal mode" {
  sentinel="${BATS_TEST_TMPDIR}/ran"
  run_with_spinner "Working..." touch "$sentinel"
  [ -e "$sentinel" ]
}

@test "run_with_spinner() propagates a failing exit code" {
  run run_with_spinner "Working..." false
  [ "$status" -ne 0 ]
}

@test "run_step() skips execution in simulate mode but reports success" {
  SIMULATE=1
  sentinel="${BATS_TEST_TMPDIR}/ran"
  run run_step "Installing Thing..." touch "$sentinel"
  [ "$status" -eq 0 ]
  [ ! -e "$sentinel" ]
  [[ "$output" == *"Thing installed"* ]]
}

@test "select_multiple(): down, space, enter selects index 1" {
  run bash -c "printf '\\x1b[B \\n' | bash '$DRIVER' Alpha Bravo Charlie"
  [ "$status" -eq 0 ]
  [ "$output" = "1" ]
}

@test "select_multiple(): space, down, space, enter selects 0 and 1" {
  run bash -c "printf ' \\x1b[B \\n' | bash '$DRIVER' Alpha Bravo Charlie"
  [ "$status" -eq 0 ]
  [ "$output" = "0 1" ]
}

@test "select_multiple(): enter with no toggles selects nothing" {
  run bash -c "printf '\\n' | bash '$DRIVER' Alpha Bravo Charlie"
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}
