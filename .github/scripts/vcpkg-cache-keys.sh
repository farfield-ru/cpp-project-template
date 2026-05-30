#!/usr/bin/env bash
# Emits the segments used to build the vcpkg cache keys in CI:
#   vcpkg_sha — pinned vcpkg submodule SHA, read from the parent repo's
#               tree (the gitlink). Bumps when vcpkg upgrades.
#   image     — runner image revision. ImageOS + ImageVersion are set by
#               GitHub on every hosted runner and bump on compiler/ABI
#               rotations, so this picks up runner upgrades automatically.
# Written to $GITHUB_OUTPUT so workflow steps can read them as
# `steps.<id>.outputs.vcpkg_sha` / `steps.<id>.outputs.image`.

set -eu

vcpkg_sha=$(git rev-parse HEAD:external/vcpkg)
image="${ImageOS:-$RUNNER_OS}-${ImageVersion:-unknown}"

{
  echo "vcpkg_sha=$vcpkg_sha"
  echo "image=$image"
} >> "$GITHUB_OUTPUT"

echo "vcpkg=$vcpkg_sha image=$image"
