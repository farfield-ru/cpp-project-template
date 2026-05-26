cmake_minimum_required(VERSION 3.25)

project(sample
    VERSION 0.1.0
    DESCRIPTION "C++ project template (CMake + vcpkg + Ninja)"
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "" FORCE)
endif()

option(SAMPLE_ENABLE_SANITIZERS "Enable ASan + UBSan on GCC/Clang builds" OFF)
option(SAMPLE_BUILD_TESTS       "Build unit tests"                        ON)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
include(ProjectOptions)

if(SAMPLE_BUILD_TESTS)
    enable_testing()
endif()

add_subdirectory(src)
add_subdirectory(app)

if(SAMPLE_BUILD_TESTS)
    add_subdirectory(tests)
endif()
