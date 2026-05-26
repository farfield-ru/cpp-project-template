#include "sample/greeter.hpp"

#include <string>

namespace sample {

std::string greet(std::string_view name) {
    std::string out;
    out.reserve(name.size() + 8);
    out.append("Hello, ");
    out.append(name);
    out.push_back('!');
    return out;
}

}  // namespace sample
