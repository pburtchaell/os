#!/usr/bin/env bats
# Smoke tests for simulate mode: the child scripts must run to completion
# without touching the system (mutating commands are shadowed by
# enable_simulate, so these are safe to run anywhere).

DEFAULTS_SH="${BATS_TEST_DIRNAME}/../scripts/defaults.sh"
DOCK_SH="${BATS_TEST_DIRNAME}/../scripts/dock.sh"

@test "defaults.sh completes in simulate mode" {
  # Answer 'n' to the reboot prompt
  run env SIMULATE=1 bash "$DEFAULTS_SH" <<< $'n\n'
  [ "$status" -eq 0 ]
  [[ "$output" == *"macOS preferences configured successfully"* ]]
}

@test "dock.sh completes in simulate mode" {
  run env SIMULATE=1 bash "$DOCK_SH" </dev/null
  [ "$status" -eq 0 ]
  [[ "$output" == *"Dock configured successfully"* ]]
}
