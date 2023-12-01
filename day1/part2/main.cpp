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
        const auto spelled_digits = std::vector<std::string>{
            "one",
            "two",
            "three",
            "four",
            "five",
            "six",
            "seven",
            "eight",
            "nine",
        };

        auto all_digits = std::vector<std::int64_t>{};

        for (auto i = 0U; i < elem.size(); ++i)
        {
            const auto c = elem[i];
            if (std::isdigit(c))
            {
                all_digits.push_back(c - '0');
            }

            std::ranges::for_each(
                spelled_digits,
                [&elem, &all_digits, i, numeric_digit = 1](const auto& spelled_digit) mutable {
                    if (elem.size() >= i + spelled_digit.size())
                    {
                        if (elem.substr(i, spelled_digit.size()) == spelled_digit)
                        {
                            all_digits.push_back(numeric_digit);
                        }
                    }
                    ++numeric_digit;
            });
        }

        return acc + (all_digits.front() * 10) + all_digits.back();
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
