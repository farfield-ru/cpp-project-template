#!/usr/bin/env bash
# Emit a short stable hash of the .vcpkg-cache/ archive contents to
# $GITHUB_OUTPUT (key `hash`). Used as the suffix of the binary-archive
# cache key on save, so that:
#   * a new cache entry is created only when content actually changes
#     (the save step's `if:` skips when restored == current);
#   * each entry's key uniquely identifies its contents, which means
#     restoring the most recent matching key always gives the freshest
#     working set without ever silently serving stale bytes under a
#     still-matching primary key.
# Emits `empty` when the directory is missing or has no archive files
# so the save step can skip pointless zero-content entries.

set -eu

cache_dir=.vcpkg-cache

if [ ! -d "$cache_dir" ] || [ -z "$(find "$cache_dir" -type f \( -name '*.zip' -o -name '*.7z' \) -print -quit 2>/dev/null)" ]; then
  echo "hash=empty" >> "$GITHUB_OUTPUT"
  echo "hash=empty (no archives)"
  exit 0
fi

# Hash each archive's bytes, sort by path for determinism, then hash
# the combined manifest. First 16 hex chars are plenty for uniqueness
# within a single repo's cache namespace.
hash=$(
  find "$cache_dir" -type f \( -name '*.zip' -o -name '*.7z' \) -print0 |
    LC_ALL=C sort -z |
    xargs -0 sha256sum |
    sha256sum |
    cut -c1-16
)

echo "hash=$hash" >> "$GITHUB_OUTPUT"
echo "hash=$hash"
