#include "sample/greeter.hpp"

#include <iostream>
#include <string_view>

int main(int argc, char** argv) {
    std::string_view name = (argc > 1) ? std::string_view{argv[1]} : "world";
    std::cout << sample::greet(name) << '\n';
    return 0;
}
