#!/usr/bin/env bats
# Tests for the GUI app (Homebrew Cask) list in scripts/dev.sh

DEV_SH="${BATS_TEST_DIRNAME}/../scripts/dev.sh"

# Source just the cask_apps=( ... ) array literal out of dev.sh
load_casks() {
  eval "$(sed -n '/^cask_apps=(/,/^)/p' "$DEV_SH")"
}

@test "cask_apps array is non-empty" {
  load_casks
  [ "${#cask_apps[@]}" -gt 0 ]
}

@test "every cask entry is a well-formed token|path|label triple" {
  load_casks
  for entry in "${cask_apps[@]}"; do
    IFS='|' read -r token path label <<< "$entry"
    [ -n "$token" ]
    [[ "$path" == /Applications/*.app ]]
    [ -n "$label" ]
  done
}

@test "cask tokens are unique" {
  load_casks
  tokens=()
  for entry in "${cask_apps[@]}"; do
    IFS='|' read -r token _ _ <<< "$entry"
    tokens+=("$token")
  done
  unique="$(printf '%s\n' "${tokens[@]}" | sort -u | wc -l | tr -d ' ')"
  [ "$unique" -eq "${#cask_apps[@]}" ]
}

@test "all cask tokens are valid Homebrew casks (skipped without brew)" {
  command -v brew >/dev/null || skip "brew not available"
  load_casks
  tokens=()
  for entry in "${cask_apps[@]}"; do
    IFS='|' read -r token _ _ <<< "$entry"
    tokens+=("$token")
  done
  run env HOMEBREW_NO_AUTO_UPDATE=1 brew info --cask "${tokens[@]}"
  [ "$status" -eq 0 ]
}
