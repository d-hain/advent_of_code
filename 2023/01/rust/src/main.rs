fn main() {
    println!("AOC 2023 - Day 1");

    part1();
    part2();
}

fn part1() {
    println!("Part 1");

    let input = include_str!("input.txt");

    println!("Calibration sum: {}", get_calibration_sum(input.lines()));
}

fn part2() {
    println!("Part 2");

    let input = include_str!("input.txt");

    // one, two, three, four, five, six, seven, eight, nine, zero

    // NOTE: I hate this... but it works and I don't care
    let mut new_input = "".to_owned();
    for line in input.lines() {
        let mut prev_char = None;

        for (idx, char) in line.chars().enumerate() {
            let next_char = line.chars().nth(idx + 1);

            match char {
                't' => {
                    new_input.push(char);
                    new_input.push(char);
                }
                'n' => {
                    if prev_char != Some('i') && prev_char != Some('o') {
                        new_input.push(char);
                    }
                    new_input.push(char);
                }
                'o' => {
                    if prev_char != Some('f') {
                        new_input.push(char);
                    }
                    new_input.push(char);
                }
                'e' => {
                    if prev_char != Some('z')
                        && next_char != Some('v')
                        && next_char != Some('n')
                        && next_char != Some('e')
                    {
                        new_input.push(char);
                    }
                    new_input.push(char);
                }
                _ => new_input.push(char),
            }

            prev_char = Some(char);
        }
        new_input.push('\n');
    }

    let mut replaced_input = "".to_owned();
    for line in new_input.lines() {
        replaced_input.push_str(
            &line
                .replace("one", "1")
                .replace("two", "2")
                .replace("three", "3")
                .replace("four", "4")
                .replace("five", "5")
                .replace("six", "6")
                .replace("seven", "7")
                .replace("eight", "8")
                .replace("nine", "9")
                .replace("zero", "0")
        );
        replaced_input.push('\n');
    }

    println!("Calibration sum: {}", get_calibration_sum(replaced_input.lines()));
}

fn get_calibration_sum(input: impl Iterator<Item = impl ToString>) -> u32 {
    let numbers = input
        .map(|line| {
            line.to_string()
                .chars()
                .filter(|c| c.is_numeric())
                .collect::<String>()
        })
        .collect::<Vec<String>>();
    let actual_numbers = numbers
        .into_iter()
        .map(|number| {
            if number.len() == 1 {
                return format!("{}{}", number, number);
            }
            return format!(
                "{}{}",
                number.chars().nth(0).unwrap(),
                number.clone().pop().unwrap()
            );
        })
        .map(|number| number.parse::<u32>().unwrap())
        .collect::<Vec<u32>>();

    return actual_numbers.iter().sum::<u32>();
}
