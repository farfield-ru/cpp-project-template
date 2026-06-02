#!/usr/bin/env bash
# Verify every tracked C/C++ source file in the project is formatted
# according to the repo's `.clang-format`. Runs `clang-format --dry-run
# --Werror`, which exits non-zero with diagnostics when any file would
# be reformatted but never touches the working tree. Paths excluded by
# `.clang-format-ignore` (e.g. the vcpkg submodule) are skipped by
# clang-format itself.

set -eu

clang_format="${CLANG_FORMAT:-clang-format}"

mapfile -t files < <(git ls-files -- \
    '*.c' '*.cc' '*.cpp' '*.cxx' \
    '*.h' '*.hh' '*.hpp' '*.hxx' \
    ':!external/**')

if [ ${#files[@]} -eq 0 ]; then
    echo "No C/C++ source files found."
    exit 0
fi

echo "Checking ${#files[@]} file(s) with $("$clang_format" --version)"
"$clang_format" --dry-run --Werror "${files[@]}"
