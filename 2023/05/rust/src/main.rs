use std::{collections::HashMap, ops::Range, str::SplitWhitespace};

#[derive(Debug, PartialEq, Eq)]
struct Seed {
    number: u64,
}

impl Seed {
    fn new(number: u64) -> Self {
        Self { number }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
struct XtoXMap {
    name: String,
    ranges: Vec<Ranges>,
}

impl XtoXMap {
    fn new(name: String, ranges: Vec<Ranges>) -> Self {
        Self { name, ranges }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
struct Ranges {
    destination_range: Range<u64>,
    source_range: Range<u64>,
}

impl Ranges {
    fn new(destination_range: Range<u64>, source_range: Range<u64>) -> Self {
        Self {
            destination_range,
            source_range,
        }
    }
}

fn main() {
    println!("AOC 2023 - Day 5");

    part1();
    part2();
}

fn part1() {
    println!("Part 1");

    let input = include_str!("input.txt");

    let seeds = get_seeds_part1(input);
    let maps = get_maps(input);

    println!(
        "Lowest location number: {}",
        get_lowest_location(&seeds, maps)
    );
}

fn part2() {
    println!("Part 2");

    let input = include_str!("input.txt");

    let seeds = get_seeds_part2(input);
    let maps = get_maps(input);

    println!(
        "Lowest location number: {}",
        get_lowest_location(&seeds, maps)
    );
}

fn get_lowest_location(seeds: &[Seed], maps: Vec<XtoXMap>) -> u64 {
    dbg!("Before", &maps);
    let maps = preprocess_maps(maps.to_vec());
    dbg!("After", &maps);

    let mut mapped_numbers = HashMap::new();
    for (idx, map) in maps.iter().enumerate() {
        if idx == 0 {
            mapped_numbers = map_numbers_to_map(
                &seeds.iter().map(|seed| seed.number).collect::<Vec<_>>(),
                map,
            );
            continue;
        }

        let numbers = mapped_numbers
            .values()
            .map(|value| *value)
            .collect::<Vec<_>>();
        mapped_numbers = map_numbers_to_map(&numbers, map);
    }

    *mapped_numbers
        .values()
        .min()
        .expect("There should at least be one number")
}

/// # Returns
///
/// all maps with the non-colliding ranges removed.
fn preprocess_maps(maps: Vec<XtoXMap>) -> Vec<XtoXMap> {
    let mut new_maps = Vec::new();
    let mut maps = maps.iter().peekable();

    while let Some(map) = maps.next() {
        let next_map = maps.peek();
        if next_map.is_none() {
            break;
        }
        let next_map = next_map.unwrap();

        let mut new_ranges = map.ranges;

        for (idx, ranges) in map.ranges.iter().enumerate() {
            for next_ranges in &next_map.ranges {
                // TODO: irgendwie so, aber das stimmt nicht ganz
                if !ranges_overlap(&ranges.destination_range, &next_ranges.source_range) {
                }
            }
        }

        new_maps.push();
    }

    new_maps
}

fn ranges_overlap(range1: &Range<u64>, range2: &Range<u64>) -> bool {
    range1.start <= range2.end && range2.start <= range1.end
}

/// # Returns
///
/// the numbers mapped to the numbers of the map.
fn map_numbers_to_map(numbers: &[u64], map: &XtoXMap) -> HashMap<u64, u64> {
    let mut mapped_numbers = HashMap::new();

    for ranges in &map.ranges {
        for number in numbers {
            if ranges.source_range.contains(number) {
                let index = number - ranges.source_range.start;
                let destination = ranges.destination_range.start + index;
                mapped_numbers.insert(*number, destination);
            }
        }
    }

    if numbers.len() != mapped_numbers.len() {
        for number in numbers {
            if !mapped_numbers.contains_key(number) {
                mapped_numbers.insert(*number, *number);
            }
        }
    }

    mapped_numbers
}

fn get_seeds_part2(input: &str) -> Vec<Seed> {
    let numbers = get_numbers_first_line(input).collect::<Vec<_>>();
    let pairs = numbers
        .chunks(2)
        .map(|pair| {
            pair.iter()
                .map(|number| number.parse().expect("Should be a number"))
                .collect::<Vec<_>>()
        })
        .collect::<Vec<_>>();

    pairs
        .iter()
        .flat_map(|pair| (pair[0]..(pair[0] + pair[1])).collect::<Vec<_>>())
        .map(|number| Seed::new(number))
        .collect()
}

fn get_seeds_part1(input: &str) -> Vec<Seed> {
    get_numbers_first_line(input)
        .map(|seed_number| seed_number.parse::<u64>().expect("Should be a number"))
        .map(Seed::new)
        .collect()
}

fn get_numbers_first_line(input: &str) -> SplitWhitespace {
    input
        .lines()
        .nth(0)
        .expect("First line should contain seeds")
        .split(": ")
        .last()
        .expect("Format of first line should be: \"seeds: X X X\"")
        .split_whitespace()
}

fn get_maps(input: &str) -> Vec<XtoXMap> {
    let mut map_sections = input.split("\n\n");
    // Skip first line (that's where the seeds are)
    map_sections.next();

    map_sections
        .map(|section| {
            let section = section.trim_end();
            let mut section_split = section.split("\n");
            let map_name = section_split
                .next()
                .expect("Should be the line with tne name of the map")
                .split_whitespace()
                .nth(0)
                .expect("Should be the name of the map");

            let ranges = section_split
                .map(|line| {
                    let line_ranges = line.split_whitespace().collect::<Vec<_>>();
                    let range_length = line_ranges
                        .last()
                        .expect("Range length")
                        .parse::<u64>()
                        .expect("Should be a number");

                    // Destination range
                    let dest_range_start = line_ranges
                        .get(0)
                        .expect("Destination range start")
                        .parse::<u64>()
                        .expect("Should be a number");
                    let destination_range = dest_range_start..(dest_range_start + range_length);

                    // Source range
                    let source_range_start = line_ranges
                        .get(1)
                        .expect("Source range start")
                        .parse::<u64>()
                        .expect("Should be a number");
                    let source_range = source_range_start..(source_range_start + range_length);

                    Ranges::new(destination_range, source_range)
                })
                .collect();

            XtoXMap::new(map_name.to_owned(), ranges)
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use std::vec;

    use crate::{get_maps, get_seeds_part1, map_numbers_to_map, Seed};

    #[test]
    fn test_map_numbers_to_map_part1() {
        let example_input = include_str!("example.txt");
        let seeds = get_seeds_part1(example_input);
        let maps = get_maps(example_input);

        let mapped_numbers = map_numbers_to_map(
            &seeds.iter().map(|seed| seed.number).collect::<Vec<_>>(),
            maps.get(0).expect("Should be the seed-to-soil map"),
        );

        #[cfg_attr(rustfmt, rustfmt_skip)]
        {
            assert_eq!(mapped_numbers.len(), 4, "Checking mapped numbers length.");
            assert_eq!(mapped_numbers.get(&79), Some(&81), "Checking correct soil numbers.");
            assert_eq!(mapped_numbers.get(&14), Some(&14), "Checking correct soil numbers.");
            assert_eq!(mapped_numbers.get(&55), Some(&57), "Checking correct soil numbers.");
            assert_eq!(mapped_numbers.get(&13), Some(&13), "Checking correct soil numbers.");
        }
    }

    #[test]
    fn test_get_seeds_part1() {
        let example_input = include_str!("example.txt");
        let real_seeds = vec![Seed::new(79), Seed::new(14), Seed::new(55), Seed::new(13)];

        let seeds = get_seeds_part1(example_input);

        assert_eq!(seeds, real_seeds, "Checking seeds.");
    }

    #[test]
    fn test_getting_maps() {
        let example_input = include_str!("example.txt");

        let maps = get_maps(example_input);

        #[cfg_attr(rustfmt, rustfmt_skip)]
        {
            assert_eq!(maps.len(), 7, "Checking maps length.");
            assert_eq!(maps[0].ranges[0].source_range, 98..100, "Checking seed-to-soil map.");
            assert_eq!(maps[1].ranges[1].destination_range, 37..39, "Checking soil-to-fertilizer map.");
            assert_eq!(maps[2].ranges[2].destination_range, 42..49, "Checking fertilizer-to-water map.");
            assert_eq!(maps[3].ranges[0].source_range, 18..25, "Checking water-to-light map.");
            assert_eq!(maps[4].ranges[2].source_range, 64..77, "Checking light-to-temperature map.");
            assert_eq!(maps[5].ranges[0].destination_range, 0..1, "Checking temperature-to-humidity map.");
            assert_eq!(maps[6].ranges[1].source_range, 93..97, "Checking humidity-to-location map.");
        }
    }
}
