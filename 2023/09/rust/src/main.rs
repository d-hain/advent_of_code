fn main() {
    println!("AOC 2023 - Day 9");

    part1();
    part2();
}

fn part1() {
    println!("Part 1");

    let input = include_str!("input.txt");

    let value_histories = get_histories(input);
    let difference_histories = calculate_difference_histories(value_histories.clone());
    let histories = combine_histories(value_histories, difference_histories);

    let mut next_values = Vec::new();
    for history in histories {
        let mut rev_history = history.iter().rev();
        // Skip Zeros
        let _ = rev_history.next();
        let mut last_value_prev_history = 0;
        for step in rev_history.clone() {
            let next_value = step.last().unwrap() + last_value_prev_history;
            last_value_prev_history = next_value;

            if step == rev_history.clone().last().unwrap() {
                next_values.push(next_value);
            }
        }
    }

    println!("Sum of the next extrapolated values: {}", next_values.iter().sum::<i32>());
}

fn part2() {
    println!("Part 2");

    let input = include_str!("input.txt");

    let value_histories = get_histories(input);
    let difference_histories = calculate_difference_histories(value_histories.clone());
    let histories = combine_histories(value_histories, difference_histories);

    let mut previous_values = Vec::new();
    for history in histories {
        let mut rev_history = history.iter().rev();
        // Skip Zeros
        let _ = rev_history.next();
        let mut first_value_prev_history = 0;
        for step in rev_history.clone() {
            let previous_value = step.first().unwrap() - first_value_prev_history;
            first_value_prev_history = previous_value;

            if step == rev_history.clone().last().unwrap() {
                previous_values.push(previous_value);
            }
        }
    }

    println!("Sum of the previous extrapolated values: {}", previous_values.iter().sum::<i32>());
}

fn get_histories(input: &str) -> Vec<Vec<i32>> {
    input
        .lines()
        .map(|line| {
            line.split_whitespace()
                .map(|number| number.parse().expect("A valid number"))
                .collect()
        })
        .collect()
}

fn combine_histories(value_histories: Vec<Vec<i32>>, difference_histories: Vec<Vec<Vec<i32>>>) -> Vec<Vec<Vec<i32>>> {
    value_histories
        .iter()
        .enumerate()
        .map(|(idx, values)| {
            let mut history = Vec::new();

            history.push(values.to_owned());
            for difference_history in difference_histories.get(idx).unwrap().clone() {
                history.push(difference_history);
            }

            history
        })
        .collect::<Vec<_>>()
}

fn calculate_difference_histories(value_histories: Vec<Vec<i32>>) -> Vec<Vec<Vec<i32>>> {
    fn calculate_difference_history(values: Vec<i32>) -> Vec<i32> {
        let mut difference_history = Vec::new();

        for two_values in values.windows(2) {
            difference_history.push(two_values[1] - two_values[0]);
        }

        difference_history
    }

    let mut difference_histories = Vec::new();
    for values in value_histories {
        let mut entry = Vec::new();
        let mut difference_history = calculate_difference_history(values);
        entry.push(difference_history.clone());

        while !difference_history.iter().all(|number| number == &0) {
            difference_history = calculate_difference_history(difference_history);
            entry.push(difference_history.clone());
        }
        difference_histories.push(entry);
    }

    difference_histories
}
