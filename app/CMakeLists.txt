add_executable(sample_app main.cpp)

target_link_libraries(sample_app
    PRIVATE sample sample_warnings sample_sanitizers
)
