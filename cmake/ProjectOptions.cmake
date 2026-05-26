add_library(sample_warnings INTERFACE)

if(MSVC)
    target_compile_options(sample_warnings INTERFACE
        /W4 /permissive- /Zc:__cplusplus /Zc:preprocessor /EHsc
    )
else()
    target_compile_options(sample_warnings INTERFACE
        -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Wnon-virtual-dtor
    )
endif()

add_library(sample_sanitizers INTERFACE)

if(SAMPLE_ENABLE_SANITIZERS)
    if(MSVC)
        message(WARNING "SAMPLE_ENABLE_SANITIZERS ignored on MSVC")
    else()
        target_compile_options(sample_sanitizers INTERFACE
            -fsanitize=address,undefined -fno-omit-frame-pointer
        )
        target_link_options(sample_sanitizers INTERFACE
            -fsanitize=address,undefined
        )
    endif()
endif()
