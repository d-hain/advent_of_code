#[derive(Debug)]
struct Card {
    winning_numbers: Vec<u32>,
    numbers_you_have: Vec<u32>,
}

fn main() {
    println!("AOC 2023 - Day 4");

    part1();
    part2();
}

fn part1() {
    println!("Part 1");

    let input = include_str!("input.txt");

    // Get all cards
    let cards = get_cards(input);

    // Calculate points
    let mut card_points: Vec<u32> = Vec::new();
    for card in cards {
        let mut points = 0;
        for winning_number in card.winning_numbers {
            if card.numbers_you_have.contains(&winning_number) {
                if points == 0 {
                    points = 1;
                } else {
                    points *= 2;
                }
            }
        }
        card_points.push(points);
    }

    println!(
        "Total points of all cards: {}",
        card_points.into_iter().sum::<u32>()
    );
}

fn part2() {
    println!("Part 2");

    let input = include_str!("input.txt");

    // Get all cards
    let cards = get_cards(input);

    let winning_numbers_count = cards
        .iter()
        .map(|card| {
            card.winning_numbers
                .iter()
                .filter(|winning_number| card.numbers_you_have.contains(&winning_number))
                .count()
        })
        .collect::<Vec<_>>();

    // This magic was blatantly copied from:
    // https://github.com/adriandelgado/advent-of-code/blob/main/src/y2023/d04.rs
    let mut copies: Vec<u32> = input.lines().map(|_| 1).collect();
    for (card_id, win_num_count) in winning_numbers_count.iter().enumerate() {
        let [curr_copy_amount, next_cards @ ..] = &mut copies[card_id..=(card_id + win_num_count)] else {
            unreachable!()
        };
        next_cards.iter_mut().for_each(|c| *c += *curr_copy_amount);
    }

    println!(
        "Total amount of scratchcards: {}",
        copies.into_iter().sum::<u32>()
    );
}

fn get_cards(input: &str) -> Vec<Card> {
    input
        .lines()
        .map(|line| {
            let line_right = line.split(": ").last().unwrap();

            let mut right_split = line_right.split(" | ");
            let winning_numbers = right_split
                .next()
                .unwrap()
                .split_whitespace()
                .map(|number| number.parse::<u32>().unwrap())
                .collect::<Vec<u32>>();
            let numbers_you_have = right_split
                .last()
                .unwrap()
                .split_whitespace()
                .map(|number| number.parse::<u32>().unwrap())
                .collect::<Vec<u32>>();

            Card {
                winning_numbers,
                numbers_you_have,
            }
        })
        .collect()
}
