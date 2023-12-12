use std::collections::HashMap;

#[derive(Debug)]
enum Pipe {
    NS, // |
    EW, // -
    NE, // L
    NW, // J
    SW, // 7
    SE, // F
}

impl From<char> for Pipe {
    fn from(value: char) -> Self {
        match value {
            '|' => Self::NS,
            '-' => Self::EW,
            'L' => Self::NE,
            'J' => Self::NW,
            '7' => Self::SW,
            'F' => Self::SE,
            _ => unreachable!(),
        }
    }
}

struct Position {
    x: usize,
    y: usize,
}

fn main() {
    println!("AOC 2023 - Day 10");

    part1();
    part2();
}

fn part1() {
    println!("Part 1");

    let input = include_str!("example2.txt");
}

fn part2() {
    println!("Part 2");

    let input = include_str!("example2.txt");
}

fn get_map(input: &str) -> Vec<Vec<char>> {
    input.lines().map(|line| line.chars().collect()).collect()
}

fn get_starting_position(map: Vec<Vec<char>>) -> Position {
    for (y, line) in map.iter().enumerate() {
        for (x, char) in line.iter().enumerate() {
            if char == &'S' {
                return Position { x, y };
            }
        }
    }

    unreachable!("There should be an 'S' in the input");
}

/// NOTE: I hate myself
fn convert_map(map: Vec<Vec<char>>, starting_position: Position) -> Vec<Vec<Option<Pipe>>> {
    let mut map = map;

    // Get pipe under starting position 'S'
    let mut above_start = map[starting_position.y][starting_position.x];
    if starting_position.y != 0 {
        above_start = map[starting_position.y - 1][starting_position.x];
    }
    let mut right_start = map[starting_position.y][starting_position.x];
    if starting_position.x != map[0].len() - 1 {
        right_start = map[starting_position.y][starting_position.x + 1];
    }
    let mut under_start = map[starting_position.y][starting_position.x];
    if starting_position.y != map.len() - 1 {
        under_start = map[starting_position.y + 1][starting_position.x];
    }
    let mut left_start = map[starting_position.y][starting_position.x];
    if starting_position.x != 0 {
        left_start = map[starting_position.y][starting_position.x - 1];
    }

    let mut possible_pipes = HashMap::from([
        ('|', true),
        ('-', true),
        ('L', true),
        ('J', true),
        ('7', true),
        ('F', true),
    ]);
    if above_start == '|' || above_start == '7' || above_start == 'F' {
        possible_pipes.entry('-').and_modify(|entry| *entry = false);
        possible_pipes.entry('7').and_modify(|entry| *entry = false);
        possible_pipes.entry('F').and_modify(|entry| *entry = false);
    }
    if right_start == '-' || right_start == 'J' || right_start == '7' {
        possible_pipes.entry('|').and_modify(|entry| *entry = false);
        possible_pipes.entry('J').and_modify(|entry| *entry = false);
        possible_pipes.entry('7').and_modify(|entry| *entry = false);
    }
    if under_start == '|' || under_start == 'L' || under_start == 'J' {
        possible_pipes.entry('-').and_modify(|entry| *entry = false);
        possible_pipes.entry('L').and_modify(|entry| *entry = false);
        possible_pipes.entry('J').and_modify(|entry| *entry = false);
    }
    if left_start == '-' || left_start == 'L' || left_start == 'F' {
        possible_pipes.entry('|').and_modify(|entry| *entry = false);
        possible_pipes.entry('L').and_modify(|entry| *entry = false);
        possible_pipes.entry('F').and_modify(|entry| *entry = false);
    }

    // Set starting position pipe
    map[starting_position.y][starting_position.x] = *possible_pipes
        .iter()
        .filter(|(_, val)| val == &&true)
        .next()
        .unwrap()
        .0;

    map.iter()
        .map(|line| {
            line.iter()
                .map(|char| {
                    // dbg!(char);
                    if char == &'.' {
                        None
                    } else {
                        Some((*char).into())
                    }
                })
                .collect()
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part1() {
        let input = include_str!("example2.txt");

        let map = get_map(input);
        let starting_position = get_starting_position(map.clone());
        let map = convert_map(map, starting_position);

        dbg!(map);

        assert!(false);
    }

    #[test]
    fn test_part2() {
        let input = include_str!("example2.txt");

        assert!(false);
    }
}
