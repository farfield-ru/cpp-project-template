#include "sample/greeter.hpp"

#include <catch2/catch_test_macros.hpp>

TEST_CASE("greet produces a Hello, <name>! string", "[greeter]") {
    REQUIRE(sample::greet("world") == "Hello, world!");
    REQUIRE(sample::greet("Claude") == "Hello, Claude!");
}

TEST_CASE("greet handles empty names", "[greeter]") {
    REQUIRE(sample::greet("") == "Hello, !");
}
