import sys


class Card:
    def __init__(self, winning_numbers, scratched_numbers):
        self.winning_numbers = winning_numbers
        self.scratched_numbers = scratched_numbers

    def get_score(self):
        score = 0
        for i in range(0, len(self.winning_numbers.intersection(self.scratched_numbers))):
            score = pow(2, i)

        return score


def create_card(card):
    _, winning_numbers = card[0].split(": ")
    winning_numbers = set(map(int, winning_numbers.split()))
    scratched_numbers = set(map(int, card[1].split()))
    return Card(winning_numbers, scratched_numbers)


def load(path):
    with open(path, "r") as file:
        contents = file.read().split("\n")
        cards = list(map(lambda line: create_card(line.split(" | ")), contents))
        return cards


def solve(cards):
    return sum(map(lambda card: card.get_score(), cards))


def main():
    path = sys.argv[1]
    input = load(path)
    result = solve(input)
    print(result)


if __name__ == "__main__":
    main()
