// This is my solution for both parts in Rust

use std::fs;

fn main() {
    let data = fs::read_to_string("src/calories.txt").unwrap();
    let calories: Vec<&str> = data.split('\n').collect();
    let mut elves: Vec<i32> = vec![];

    let mut cal_elf = 0;
    for cal in calories {
        if cal.trim().is_empty() {
            elves.push(cal_elf);
            cal_elf = 0;
            continue;
        }

        println!("{cal}");
        cal_elf += cal.trim().parse::<i32>().unwrap();
    }

    elves.sort();
    elves.reverse();
    println!("Solution 1: {}", elves[0]);

    println!("Solution 2: {}", elves[0..3].iter().sum::<i32>());
}
