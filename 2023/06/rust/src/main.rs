#[derive(Debug)]
struct Race {
    time_ms: u64,
    distance_mm: u64,
}

impl Race {
    fn new(time: u64, record_distance: u64) -> Self {
        Self {
            time_ms: time,
            distance_mm: record_distance,
        }
    }
}

fn main() {
    println!("AOC - Day 6");

    part1();
    part2();
}

fn part1() {
    println!("Part 1");

    let input = include_str!("input.txt");

    let races = get_races(input);

    let mut win_possibilities = Vec::new();
    for race in races {
        win_possibilities.push(get_possible_wins(&race));
    }

    println!(
        "Win possibilities multiplied: {}",
        win_possibilities.iter().product::<u64>()
    );
}

fn part2() {
    println!("Part 2");

    let input = include_str!("input.txt");

    let race = get_race(input);

    let possible_wins = get_possible_wins(&race);

    println!("Possible wins: {}", possible_wins);
}

fn get_possible_wins(race: &Race) -> u64 {
    let mut possible_wins = 0;

    for button_hold_time_ms in 1..(race.time_ms - 1) {
        let boat_distance = button_hold_time_ms * (race.time_ms - button_hold_time_ms);

        if boat_distance > race.distance_mm {
            possible_wins += 1;
        }
    }

    possible_wins
}

fn get_race(input: &str) -> Race {
    Race::new(get_number(input, 0), get_number(input, 1))
}

fn get_number(input: &str, line_idx: usize) -> u64 {
    input
        .lines()
        .nth(line_idx)
        .unwrap()
        .split(":")
        .last()
        .unwrap()
        .replace(" ", "")
        .parse()
        .expect("Should be a number")
}

fn get_races(input: &str) -> Vec<Race> {
    get_numbers(input, 0)
        .zip(get_numbers(input, 1))
        .map(|(time, distance)| Race::new(time, distance))
        .collect()
}

fn get_numbers(input: &str, line_idx: usize) -> impl Iterator<Item = u64> + '_ {
    input
        .lines()
        .nth(line_idx)
        .unwrap()
        .split(":")
        .last()
        .unwrap()
        .split_whitespace()
        .map(|number| number.parse::<u64>().expect("Should be a number"))
}
