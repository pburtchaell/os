#!/usr/bin/env bats
# Tests for setup.sh argument parsing (paths that exit before the menu)

SETUP_SH="${BATS_TEST_DIRNAME}/../setup.sh"

@test "--help prints usage and exits 0" {
  run bash "$SETUP_SH" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage"* ]]
  [[ "$output" == *"--simulate"* ]]
}

@test "an unknown flag exits non-zero with an error" {
  run bash "$SETUP_SH" --nope
  [ "$status" -ne 0 ]
  [[ "$output" == *"Unknown option"* ]]
}
