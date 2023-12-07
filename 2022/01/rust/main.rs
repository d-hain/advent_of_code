fn main() {
    println!("Advent Of Code Day 1:\n");

    let input = std::fs::read_to_string("src/input.txt").unwrap();

    println!("First Solution: ");
    first_solution(&input);

    println!("\nBetter Solution: ");
    better_solution(&input);
}

fn first_solution(input: &str) {
    let lines: Vec<&str> = input.split('\n').collect();
    let mut elves: Vec<u32> = vec![];

    let mut cal_elf = 0;
    for line in lines {
        if line.trim().is_empty() {
            elves.push(cal_elf);
            cal_elf = 0;
            continue;
        }

        cal_elf += line.trim().parse::<u32>().unwrap();
    }

    elves.sort();
    elves.reverse();

    println!("Part 1: {}", elves[0]);
    println!("Part 2: {}", elves[0..3].iter().sum::<u32>());
}

/// To be honest it is basically the one from ThePrimeagen's Stream today
/// Be sure that the file you are using is formatted using LF instead of Windows's CRLF
fn better_solution(input: &str) {
    let lines = input.split("\n\n");
    let mut elves: Vec<u32> = lines
        .map(|line| line.split("\n")
            .flat_map(|num| num.parse::<u32>())
            .sum())
        .collect();

    elves.sort_by(|a, b| b.cmp(a));

    println!("Part 1: {}", elves[0]);
    println!("Part 2: {}", elves.iter().take(3).sum::<u32>());
}
