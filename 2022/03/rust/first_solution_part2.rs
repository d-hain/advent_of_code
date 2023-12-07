#![feature(iter_array_chunks)]

use std::collections::HashMap;

fn main() {
    let input = std::fs::read_to_string("../input.txt").unwrap();
    let letters_priorities = ('a'..='z')
        .chain('A'..='Z')
        .enumerate()
        .map(|(idx, c)| (c, idx + 1))
        .collect::<HashMap<char, usize>>();

    let priorities_sum = input.lines().array_chunks::<3>().map(|[bag1, bag2, bag3]| {
        let badge_item = bag1
            .chars()
            .into_iter()
            .filter(|item| bag2.contains(*item) && bag3.contains(*item))
            .collect::<Vec<char>>()[0];

        letters_priorities.get(&badge_item).unwrap()
    }).sum::<usize>();

    println!("Part 2: {}", priorities_sum);
}
