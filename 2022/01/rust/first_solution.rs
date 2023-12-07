let input = std::fs::read_to_string("src/input.txt").unwrap();
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
