#include <algorithm>
#include <cctype>
#include <cstdint>
#include <fstream>
#include <numeric>
#include <iostream>
#include <ranges>
#include <stdexcept>
#include <string>
#include <vector>

std::vector<std::string> load_file(const char* filepath)
{
    auto output = std::vector<std::string>{};
    auto file = std::ifstream{filepath};

    auto input = std::string{};
    while (std::getline(file, input))
    {
        output.emplace_back(std::move(input));
    }

    return output;
}

std::int64_t solve(std::vector<std::string> input)
{
    return std::accumulate(std::cbegin(input), std::cend(input), std::int64_t{}, [](auto acc, const auto& elem) {
        constexpr auto digits = "0123456789";
        const auto first = elem[elem.find_first_of(digits)] - '0';
        const auto last = elem[elem.find_last_of(digits)] - '0';

        return acc + (first * 10) + last;
    });
}

int main(int argc, char** argv)
{
    if (argc < 2)
    {
        throw std::runtime_error("Provide filepath");
    }

    auto input = load_file(argv[1]);
    const auto result = solve(std::move(input));

    std::cout << result << "\n";
}
