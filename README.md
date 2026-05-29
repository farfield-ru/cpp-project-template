# cpp-project-template

Opinionated C++20 project template wired up with **CMake (Ninja, presets +
workflows)**, **vcpkg** (manifest mode, vendored as a submodule), and a
**multi-OS / multi-compiler GitHub Actions CI** with a shared vcpkg binary
cache.

## What you get

- `sample` — a static library (`src/`, `include/sample/`)
- `sample_app` — an executable linking the library (`app/`)
- `sample_tests` — Catch2 unit tests registered with CTest (`tests/`)
- `CMakePresets.json` — host-OS-scoped configure / build / test / workflow
  presets (`linux`, `macos`, `windows`) with `*-debug`, `*-release`, and
  `*-asan` variants. The compiler is **not** baked into preset names —
  set `CC` / `CXX` (or `CMAKE_C_COMPILER` / `CMAKE_CXX_COMPILER`) to pick
  one. Sanitizer presets are the one exception: they pin clang.
- `vcpkg.json` — manifest pinning Catch2 via the vendored builtin baseline
- `.github/workflows/ci.yml` — matrix CI across Linux (GCC + Clang),
  macOS (AppleClang), and Windows (MSVC). Uses `lukka/get-cmake` for a
  single cross-platform CMake + Ninja install, two `actions/cache` entries
  (vcpkg binary archives and the bootstrapped `vcpkg` executable), and
  GCC/Clang/MSVC/CMake problem matchers under `.github/matchers/` for
  inline compiler-error annotations on PRs

## Prerequisites

- CMake ≥ 3.25
- Ninja
- A C++20 compiler (GCC 11+, Clang 14+, MSVC 19.30+ / VS 2022, AppleClang 14+)
- Git (for the vcpkg submodule)
- **Linux only:** `patchelf` from the system package manager
  (`sudo apt-get install patchelf`). The Linux presets set
  `VCPKG_FORCE_SYSTEM_BINARIES=1` so vcpkg uses the system `patchelf`
  (its bundled one is outdated) along with system CMake/Ninja.

## Quick start

```bash
git clone --recurse-submodules https://github.com/farfield-ru/cpp-project-template.git
cd cpp-project-template

# Linux — defaults to gcc if CC/CXX aren't set
cmake --workflow --preset ci-linux

# Linux with clang
CC=clang CXX=clang++ cmake --workflow --preset ci-linux

# macOS (AppleClang)
cmake --workflow --preset ci-macos

# Windows — run in a Visual Studio "Developer Command Prompt"
cmake --workflow --preset ci-windows
```

Each workflow runs configure → build → test in one step. First run pulls
Catch2 through vcpkg; subsequent runs hit the project-local binary cache at
`.vcpkg-cache/` (pinned by the configure presets and ignored by git), so a
`rm -rf build/` does not force a rebuild of the dependencies. Only presets
matching the host OS are visible on a given machine, so `cmake --list-presets`
stays uncluttered.

To relocate the cache (e.g. to share it across checkouts), override
`VCPKG_DEFAULT_BINARY_CACHE` via a `CMakeUserPresets.json` rather than via
the shell — CMake applies the preset's `environment` on top of inherited
shell env when invoking vcpkg.

### Granular presets

```bash
cmake --list-presets
cmake --preset linux-debug              # gcc by default; CC=clang for clang
cmake --build --preset linux-debug
ctest --preset linux-debug

cmake --preset linux-asan               # always clang (ASan/UBSan)
cmake --build --preset linux-asan
ctest --preset linux-asan
```

Sanitizer presets (`*-asan`) enable AddressSanitizer + UndefinedBehaviorSanitizer
via the `SAMPLE_ENABLE_SANITIZERS` CMake option and pin the compiler to
clang. No `windows-asan` preset (MSVC sanitizer setup is different).

## Adding a dependency

1. Edit `vcpkg.json` and add the port name to `"dependencies"`.
2. Re-run the configure step — vcpkg will resolve and install it.
3. In CMake, use the upstream's `find_package(...)` / target.

```jsonc
// vcpkg.json
"dependencies": [
  { "name": "catch2", "version>=": "3.5.0" },
  "fmt"
]
```

```cmake
# tests/CMakeLists.txt (example)
find_package(fmt CONFIG REQUIRED)
target_link_libraries(sample_tests PRIVATE fmt::fmt)
```

## Using a system-installed vcpkg

The presets default to the vendored `external/vcpkg`. To use a different
vcpkg installation, override the toolchain on the command line:

```bash
cmake --preset linux-release \
  -DCMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake
```

## Using this as a template

1. Create a new repo from this one (GitHub "Use this template" or
   `gh repo create --template farfield-ru/cpp-project-template`).
2. Rename `sample` → your project name in `CMakeLists.txt`, `vcpkg.json`,
   the `sample::` namespace, and the target names.
3. Replace the contents of `src/`, `include/`, `app/`, `tests/`.
4. Update `LICENSE` and this README.

## Layout

```
.
├── .github/workflows/ci.yml
├── CMakeLists.txt
├── CMakePresets.json
├── cmake/ProjectOptions.cmake
├── external/vcpkg/                # submodule
├── include/sample/greeter.hpp
├── src/{CMakeLists.txt,greeter.cpp}
├── app/{CMakeLists.txt,main.cpp}
├── tests/{CMakeLists.txt,greeter_test.cpp}
└── vcpkg.json
```
