import sys


class Card:
    def __init__(self, winning_numbers, scratched_numbers):
        self.winning_numbers = winning_numbers
        self.scratched_numbers = scratched_numbers


def create_card(card):
    card_id, winning_numbers = card[0].split(": ")
    winning_numbers = set(map(int, winning_numbers.split()))
    scratched_numbers = set(map(int, card[1].split()))
    return (int(card_id.split()[-1]), Card(winning_numbers, scratched_numbers))


def load(path):
    with open(path, "r") as file:
        contents = file.read().split("\n")
        cards = dict(map(lambda line: create_card(line.split(" | ")), contents))
        return cards


def solve(cards):
    copies = dict(map(lambda card_id: (card_id, 0), cards.keys()))
    for card_id, card in cards.items():
        current_copies = copies[card_id]
        copies[card_id] += 1
        for id in range(
            1, len(card.winning_numbers.intersection(card.scratched_numbers)) + 1
        ):
            copies[id + card_id] += (1 + current_copies)

    return sum(copies.values())


def main():
    path = sys.argv[1]
    input = load(path)
    result = solve(input)
    print(result)


if __name__ == "__main__":
    main()
