import java.io.File

enum class Figure {
    FiveOfAKind,
    FourOfAKind,
    FullHouse,
    ThreeOfAKind,
    TwoPairs,
    OnePair,
    HighestCard
}

val figuresWeights = mapOf(
    Figure.FiveOfAKind to 7,
    Figure.FourOfAKind to 6,
    Figure.FullHouse to 5,
    Figure.ThreeOfAKind to 4,
    Figure.TwoPairs to 3,
    Figure.OnePair to 2,
    Figure.HighestCard to 1
)

val cardWeights = mapOf(
    'A' to 14,
    'K' to 13,
    'Q' to 12,
    'J' to 11,
    'T' to 10,
    '9' to 9,
    '8' to 8,
    '7' to 7,
    '6' to 6,
    '5' to 5,
    '4' to 4,
    '3' to 3,
    '2' to 2,
    'J' to 1
)

typealias Game = Pair<String, Int>

fun readFile(path: String): List<String> {
    return File(path).readText().split("\n")
}

fun makeGame(line: List<String>): Game {
    val hand = line[0]
    val bid = line[1].toInt()
    return Game(hand, bid)
}

fun getFigureWeight(hand: String): Int {
    val cards = hand.toList()
    val jokers = cards.count { card -> card == 'J' }
    val distinctCards = cards.filter { card -> card != 'J' }.distinct()

    when (jokers) {
        1 -> {
            if (distinctCards.count() == 1) {
                return figuresWeights.get(Figure.FiveOfAKind)!!
            } else if (distinctCards.count() == 2) {
                if (cards.count { card -> card == distinctCards[0] } == 3 ||
                    cards.count { card -> card == distinctCards[1] } == 3) {
                    return figuresWeights.get(Figure.FourOfAKind)!!
                } else {
                    return figuresWeights.get(Figure.FullHouse)!!
            }
            } else if (distinctCards.count() == 3) {
                return figuresWeights.get(Figure.ThreeOfAKind)!!
            } else {
                return figuresWeights.get(Figure.OnePair)!!
            }
        }
        2 -> {
            if (distinctCards.count() == 1) {
                return figuresWeights.get(Figure.FiveOfAKind)!!
            } else if (distinctCards.count() == 2) {
                return figuresWeights.get(Figure.FourOfAKind)!!
            } else {
                return figuresWeights.get(Figure.ThreeOfAKind)!!
            }
        }
        3 -> {
            if (distinctCards.count() == 1) {
                return figuresWeights.get(Figure.FiveOfAKind)!!
            } else {
                return figuresWeights.get(Figure.FourOfAKind)!!
            }
        }
        4 -> return figuresWeights.get(Figure.FiveOfAKind)!!
        5 -> return figuresWeights.get(Figure.FiveOfAKind)!!
        else -> {
            when (distinctCards.count()) {
                1 -> return figuresWeights.get(Figure.FiveOfAKind)!!
                2 -> {
                    if (cards.count { card -> card == distinctCards[0] } == 4 ||
                        cards.count { card -> card == distinctCards[1] } == 4) {
                        return figuresWeights.get(Figure.FourOfAKind)!!
                    } else {
                        return figuresWeights.get(Figure.FullHouse)!!
                    }
                }
                3 -> {
                    if (cards.count { card -> card == distinctCards[0] } == 3 ||
                        cards.count { card -> card == distinctCards[1] } == 3 ||
                        cards.count { card -> card == distinctCards[2] } == 3) {
                        return figuresWeights.get(Figure.ThreeOfAKind)!!
                    } else {
                        return figuresWeights.get(Figure.TwoPairs)!!
                    }
                }
                4 -> return figuresWeights.get(Figure.OnePair)!!
                5 -> return figuresWeights.get(Figure.HighestCard)!!
                else -> throw Exception("Invalid hand")
            }
        }
    }
}

fun compareCardByCard(hand1: String, hand2: String): Int {
    val cards1 = hand1.toList()
    val cards2 = hand2.toList()

    for (i in 0..4) {
        val card1 = cards1[i]
        val card2 = cards2[i]

        if (cardWeights.get(card1)!! > cardWeights.get(card2)!!) {
            return 1
        } else if (cardWeights.get(card1)!! < cardWeights.get(card2)!!) {
            return -1
        }
    }

    throw Exception("Invalid hands")
}

fun compare(hand1: String, hand2: String): Int {
    val figure1 = getFigureWeight(hand1)
    val figure2 = getFigureWeight(hand2)

    if (figure1 > figure2) {
        return 1
    } else if (figure1 < figure2) {
        return -1
    } else {
        return compareCardByCard(hand1, hand2)
    }
}

val contents = readFile(args[0])

val winnings =
    contents.map{ line -> makeGame(line.split(" ")) }
    .sortedWith { lhs, rhs -> compare(lhs.first, rhs.first) }
    .fold(Pair<Int, Int>(0, 1)) { acc, game -> Pair(acc.first + (acc.second * game.second), acc.second + 1) }
    .first

println(winnings)
