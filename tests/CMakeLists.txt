find_package(Catch2 3 CONFIG REQUIRED)
include(Catch)

add_executable(sample_tests greeter_test.cpp)

target_link_libraries(sample_tests
    PRIVATE sample Catch2::Catch2WithMain sample_warnings sample_sanitizers
)

catch_discover_tests(sample_tests)
