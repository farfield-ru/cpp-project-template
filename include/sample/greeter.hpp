#pragma once

#include <string>
#include <string_view>

namespace sample {

[[nodiscard]] std::string greet(std::string_view name);

}  // namespace sample
