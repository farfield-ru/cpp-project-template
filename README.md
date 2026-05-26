# cpp-project-template

Opinionated C++20 project template wired up with **CMake (Ninja, presets +
workflows)**, **vcpkg** (manifest mode, vendored as a submodule), and a
**multi-OS / multi-compiler GitHub Actions CI** with a shared vcpkg binary
cache.

## What you get

- `sample` — a static library (`src/`, `include/sample/`)
- `sample_app` — an executable linking the library (`app/`)
- `sample_tests` — Catch2 unit tests registered with CTest (`tests/`)
- `CMakePresets.json` — configure / build / test / workflow presets for
  GCC, Clang, AppleClang, MSVC; Debug, Release, and ASan/UBSan variants
- `vcpkg.json` — manifest pinning Catch2 via the vendored builtin baseline
- `.github/workflows/ci.yml` — matrix CI across Linux (GCC + Clang),
  macOS (AppleClang), and Windows (MSVC), with `actions/cache` keyed on
  the vcpkg manifest

## Prerequisites

- CMake ≥ 3.25
- Ninja
- A C++20 compiler (GCC 11+, Clang 14+, MSVC 19.30+ / VS 2022, AppleClang 14+)
- Git (for the vcpkg submodule)

## Quick start

```bash
git clone --recurse-submodules https://github.com/farfield-ru/cpp-project-template.git
cd cpp-project-template

# pick the workflow that matches your platform:
cmake --workflow --preset ci-linux-gcc      # Linux (GCC)
cmake --workflow --preset ci-linux-clang    # Linux (Clang)
cmake --workflow --preset ci-macos          # macOS (AppleClang)
cmake --workflow --preset ci-windows        # Windows (MSVC, run in a VS dev shell)
```

Each workflow runs configure → build → test in one step. First run pulls
Catch2 through vcpkg; subsequent runs hit the local binary cache
(`~/.cache/vcpkg/archives` on Linux/macOS, `%LOCALAPPDATA%\vcpkg\archives` on
Windows) and are much faster.

### Granular presets

```bash
cmake --list-presets
cmake --preset linux-clang-asan
cmake --build --preset linux-clang-asan
ctest --preset linux-clang-asan
```

Sanitizer presets (`*-asan`) enable AddressSanitizer + UndefinedBehaviorSanitizer
via the `SAMPLE_ENABLE_SANITIZERS` CMake option. Skipped on MSVC.

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
cmake --preset linux-gcc-release \
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
├── vcpkg.json
└── vcpkg-configuration.json
```
