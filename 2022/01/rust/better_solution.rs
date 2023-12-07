// To be honest it is basically the one from ThePrimeagen's Stream today
// Be sure that the file you are using is formatted using LF instead of Windows's CRLF

let input = std::fs::read_to_string("src/input.txt").unwrap();
let lines = input.split("\n\n");
let mut elves: Vec<u32> = lines
    .map(|line| line.split("\n")
        .flat_map(|num| num.parse::<u32>())
        .sum())
    .collect();

elves.sort_by(|a, b| b.cmp(a));

println!("Part 1: {}", elves[0]);
println!("Part 2: {}", elves.iter().take(3).sum::<u32>());
