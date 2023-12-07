use std::{cmp::Ordering, collections::HashMap};

#[derive(Debug)]
struct Hand {
    hand: Vec<Card>,
    hand_type: HandType,
    bid: usize,
}

impl Hand {
    fn new(hand: Vec<Card>, hand_type: HandType, bid: usize) -> Self {
        Self {
            hand,
            hand_type,
            bid,
        }
    }
}

#[derive(Debug, PartialEq, Eq, PartialOrd, Ord)]
enum HandType {
    FiveKind,
    FourKind,
    FullHouse,
    ThreeKind,
    TwoPair,
    OnePair,
    HighCard,
}

#[derive(Debug, Clone, Copy, Hash, PartialEq, Eq)]
struct Card(char);

// NOTE: Cannot impl PartialOrd because it changes with parts and
//       I don't want to use multiple files
impl Card {
    fn compare_cards_part1(&self, other: &Self) -> Option<Ordering> {
        use Ordering::*;

        if self.0 == other.0 {
            return Some(Equal);
        } else if self.0.is_ascii_digit() && other.0.is_ascii_digit() {
            return Some(
                self.0
                    .to_digit(10)
                    .unwrap()
                    .cmp(&other.0.to_digit(10).unwrap()),
            );
        }

        match (self.0, other.0) {
            ('A', 'K') => Some(Greater),
            ('A', 'Q') => Some(Greater),
            ('A', 'J') => Some(Greater),
            ('A', 'T') => Some(Greater),
            ('K', 'Q') => Some(Greater),
            ('K', 'J') => Some(Greater),
            ('K', 'T') => Some(Greater),
            ('Q', 'J') => Some(Greater),
            ('Q', 'T') => Some(Greater),
            ('J', 'T') => Some(Greater),
            (a, b) if !a.is_ascii_digit() && b.is_ascii_digit() => Some(Greater),

            ('K', 'A') => Some(Less),
            ('Q', 'A') => Some(Less),
            ('J', 'A') => Some(Less),
            ('T', 'A') => Some(Less),
            ('Q', 'K') => Some(Less),
            ('J', 'K') => Some(Less),
            ('T', 'K') => Some(Less),
            ('J', 'Q') => Some(Less),
            ('T', 'Q') => Some(Less),
            ('T', 'J') => Some(Less),
            (a, b) if a.is_ascii_digit() && !b.is_ascii_digit() => Some(Less),

            _ => unreachable!("Cards"),
        }
    }

    fn compare_cards_part2(&self, other: &Self) -> Option<Ordering> {
        use Ordering::*;

        // WARN: Not nice but I don't care anymore
        let mut other = other.0;
        if other == 'J' {
            other = '1';
        }
        let mut _self = self.0;
        if _self == 'J' {
            _self = '1';
        }

        if _self == other {
            return Some(Equal);
        } else if _self.is_ascii_digit() && other.is_ascii_digit() {
            return Some(
                _self
                    .to_digit(10)
                    .unwrap()
                    .cmp(&other.to_digit(10).unwrap()),
            );
        }

        match (_self, other) {
            ('A', 'K') => Some(Greater),
            ('A', 'Q') => Some(Greater),
            ('A', 'T') => Some(Greater),
            ('K', 'Q') => Some(Greater),
            ('K', 'T') => Some(Greater),
            ('Q', 'T') => Some(Greater),
            (a, b) if !a.is_ascii_digit() && b.is_ascii_digit() => Some(Greater),

            ('K', 'A') => Some(Less),
            ('Q', 'A') => Some(Less),
            ('T', 'A') => Some(Less),
            ('Q', 'K') => Some(Less),
            ('T', 'K') => Some(Less),
            ('T', 'Q') => Some(Less),
            (a, b) if a.is_ascii_digit() && !b.is_ascii_digit() => Some(Less),

            _ => unreachable!("Cards"),
        }
    }
}

impl TryFrom<char> for Card {
    type Error = &'static str;

    fn try_from(value: char) -> Result<Self, Self::Error> {
        match value {
            'A' => Ok(Self(value)),
            'K' => Ok(Self(value)),
            'Q' => Ok(Self(value)),
            'J' => Ok(Self(value)),
            'T' => Ok(Self(value)),
            '9' => Ok(Self(value)),
            '8' => Ok(Self(value)),
            '7' => Ok(Self(value)),
            '6' => Ok(Self(value)),
            '5' => Ok(Self(value)),
            '4' => Ok(Self(value)),
            '3' => Ok(Self(value)),
            '2' => Ok(Self(value)),
            _ => unreachable!(),
        }
    }
}

fn main() {
    println!("AOC 2023 - Day 7");

    part1();
    part2();
}

fn part1() {
    println!("Part 1");

    let input = include_str!("input.txt");

    let mut hands = parse_input(input, true);
    hands.sort_by(|a, b| compare_hands(a, b, true));

    let total_winnings = hands
        .iter()
        .rev()
        .enumerate()
        .map(|(idx, hand)| {
            let rank = idx + 1;
            rank * hand.bid
        })
        .sum::<usize>();

    println!("Total winnings: {}", total_winnings);
}

fn part2() {
    println!("Part 2");

    let input = include_str!("input.txt");

    let mut hands = parse_input(input, false);
    hands.sort_by(|a, b| compare_hands(a, b, false));

    let total_winnings = hands
        .iter()
        .rev()
        .enumerate()
        .map(|(idx, hand)| {
            let rank = idx + 1;
            rank * hand.bid
        })
        .sum::<usize>();

    println!("Total winnings: {}", total_winnings);
}

fn parse_input(input: &str, part1: bool) -> Vec<Hand> {
    input
        .lines()
        .map(|line| {
            let mut split = line.split_whitespace();
            let cards = split.next().expect("The hands cards");
            let bid = split
                .next()
                .expect("The bid")
                .parse()
                .expect("Should be a number");

            let cards = cards
                .chars()
                .map(|char| char.try_into().expect("A valid card"))
                .collect::<Vec<_>>();

            if part1 {
                Hand::new(cards.clone(), get_hand_type_part1(&cards), bid)
            } else {
                Hand::new(cards.clone(), get_hand_type_part2(&cards), bid)
            }
        })
        .collect()
}

fn get_hand_type_part1(cards: &[Card]) -> HandType {
    let mut amounts = HashMap::new();
    for card in cards {
        if let Some(card_amount) = amounts.get_mut(card) {
            *card_amount += 1;
        } else {
            amounts.insert(card, 1);
        }
    }

    match amounts.len() {
        1 => HandType::FiveKind,
        2 if amounts.iter().any(|(_, amount)| amount == &4) => HandType::FourKind,
        2 if amounts.iter().any(|(_, amount)| amount == &3) => HandType::FullHouse,
        3 if amounts.iter().any(|(_, amount)| amount == &3) => HandType::ThreeKind,
        3 if amounts.iter().filter(|(_, amount)| amount == &&2).count() == 2 => HandType::TwoPair,
        4 => HandType::OnePair,
        _ => HandType::HighCard,
    }
}

fn get_hand_type_part2(cards: &[Card]) -> HandType {
    use HandType::*;

    let hand_type = get_hand_type_part1(cards);
    let joker_count = cards.iter().filter(|card| card.0 == 'J').count();

    match hand_type {
        FiveKind => FiveKind,
        FourKind if joker_count >= 1 => FiveKind,
        FullHouse if joker_count >= 2 => FiveKind,
        ThreeKind if joker_count > 0 => FourKind,
        TwoPair if joker_count == 1 => FullHouse,
        TwoPair if joker_count == 2 => FourKind,
        OnePair if joker_count > 0 => ThreeKind,
        HighCard if joker_count > 0 => OnePair,
        _ => hand_type,
    }
}

fn compare_hands(a: &Hand, b: &Hand, part1: bool) -> Ordering {
    if a.hand_type > b.hand_type {
        return Ordering::Greater;
    } else if a.hand_type == b.hand_type {
        for (card_a, card_b) in a.hand.iter().zip(b.hand.iter()) {
            if card_a == card_b {
                continue;
            }

            // NOTE: This makes no sense to me, but somehow it is right
            if part1 {
                if card_a.compare_cards_part1(card_b) == Some(Ordering::Greater) {
                    return Ordering::Less;
                } else if card_a.compare_cards_part1(card_b) == Some(Ordering::Less) {
                    return Ordering::Greater;
                }
            } else {
                if card_a.compare_cards_part2(card_b) == Some(Ordering::Greater) {
                    return Ordering::Less;
                } else if card_a.compare_cards_part2(card_b) == Some(Ordering::Less) {
                    return Ordering::Greater;
                }
            }
        }

        unreachable!("There should be no equal hands")
    }

    return Ordering::Less;
}
