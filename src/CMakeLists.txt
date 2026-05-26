add_library(sample STATIC
    greeter.cpp
)

target_include_directories(sample PUBLIC
    $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
)

target_link_libraries(sample
    PRIVATE sample_warnings sample_sanitizers
)
