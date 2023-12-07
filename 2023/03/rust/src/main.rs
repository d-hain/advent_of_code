use std::collections::HashMap;

trait IsSymbol {
    fn is_symbol(&self) -> bool;
}

impl IsSymbol for char {
    fn is_symbol(&self) -> bool {
        !self.is_numeric() && !(self == &'.')
    }
}

fn main() {
    println!("AOC 2023 - Day 3");

    part1();
    part2();
}

fn part1() {
    println!("Part 1");

    let input = include_str!("example.txt");

    // Position => y, x
    // Map<Position, Character>
    let input_map: HashMap<(isize, isize), char> = input
        .lines()
        .enumerate()
        .flat_map(|(y, line)| {
            line.chars()
                .enumerate()
                .map(move |(x, char)| ((y as isize, x as isize), char))
        })
        .collect();

    let mut numbers: Vec<Vec<u32>> = Vec::new();
    for ((y, x), char) in input_map.iter() {
        if char.is_ascii_digit() {
            // TODO: watch video and get to own solution
        }
    }
}

// fn part1() {
//     println!("Part 1");

//     let input = include_str!("example.txt");

//     // find numbers and all their positions
//     //     Map<Number, Vec<Positions>>
//     // find symbols and their adjacent numbers

//     // Position => (y, x)
//     let mut number_positions: HashMap<u32, Vec<(u32, u32)>> = HashMap::new();
//     let mut input_map: Vec<Vec<char>> = Vec::new();

//     let mut str_number = "".to_owned();
//     let mut positions = Vec::new();
//     for (y, line) in input.lines().enumerate() {
//         input_map.push(Vec::new());

//         for (x, char) in line.chars().enumerate() {
//             input_map.get_mut(y).unwrap().push(char);

//             if char.is_numeric() {
//                 str_number.push(char);
//                 positions.push((y, x));
//             } else if !str_number.is_empty() {
//                 for position in positions.iter().cloned() {
//                     let number = str_number.parse::<u32>().unwrap();
//                     if let Some(existing_positions) = number_positions.get_mut(&number) {
//                         existing_positions.push(position);
//                     } else {
//                         number_positions.insert(number, vec![position]);
//                     }
//                 }
//                 str_number = "".to_owned();
//                 positions.clear()
//             }
//         }
//     }

//     #[cfg_attr(rustfmt, rustfmt_skip)]
//     let positions_to_check = vec![
//         (-1, -1), (-1, 0), (-1, 1),
//         (0, -1), (0, 1),
//         (1, -1), (1, 0), (1, 1),
//     ];
//     let mut part_numbers = Vec::new();

//     for number in number_positions.keys() {
//         for num_pos in number_positions.get(number).unwrap() {
//             let mut first_line = false;
//             let mut last_line = false;
//             let mut left_edge = false;
//             let mut right_edge = false;

//             if num_pos.1 == 0 {
//                 first_line = true;
//             }
//             if num_pos.1 == input_map.len() - 1 {
//                 last_line = true;
//             }
//             if num_pos.0 == 0 {
//                 left_edge = true;
//             }
//             if num_pos.0 == input_map[0].len() - 1 {
//                 right_edge = true;
//             }

//             // Check top side
//             'top: {
//                 if !first_line {
//                     if !left_edge {
//                         // X..
//                         // .n.
//                         // ...
//                         let char = input_map[num_pos.1 - 1][num_pos.0 - 1];
//                         if char.is_symbol() {
//                             part_numbers.push(number);
//                             break 'top;
//                         }
//                     }

//                     // .X.
//                     // .n.
//                     // ...
//                     let char = input_map[num_pos.1 - 1][num_pos.0];
//                     if char.is_symbol() {
//                         part_numbers.push(number);
//                         break 'top;
//                     }

//                     if !right_edge {
//                         // ..X
//                         // .n.
//                         // ...
//                         let char = input_map[num_pos.1 - 1][num_pos.0 + 1];
//                         if char.is_symbol() {
//                             part_numbers.push(number);
//                             break 'top;
//                         }
//                     }
//                 }
//             }

//             // Check left side
//             if !left_edge {
//                 // ...
//                 // Xn.
//                 // ...
//                 let char = input_map[num_pos.1][num_pos.0 - 1];
//                 if char.is_symbol() {
//                     part_numbers.push(number);
//                     break;
//                 }
//             }

//             // Check right side
//             if !right_edge {
//                 // ...
//                 // .nX
//                 // ...
//                 let char = input_map[num_pos.1][num_pos.0 + 1];
//                 if char.is_symbol() {
//                     part_numbers.push(number);
//                     break;
//                 }
//             }

//             // Check botton side
//             if !last_line {
//                 if !left_edge {
//                     // ...
//                     // .n.
//                     // X..
//                     let char = input_map[num_pos.1 + 1][num_pos.0 - 1];
//                     if char.is_symbol() {
//                         part_numbers.push(number);
//                         break;
//                     }
//                 }

//                 // ...
//                 // .n.
//                 // .X.
//                 let char = input_map[num_pos.1 + 1][num_pos.0];
//                 if char.is_symbol() {
//                     part_numbers.push(number);
//                     break;
//                 }

//                 if !right_edge {
//                     // ...
//                     // .n.
//                     // ..X
//                     let char = input_map[num_pos.1 + 1][num_pos.0 + 1];
//                     if char.is_symbol() {
//                         part_numbers.push(number);
//                         break;
//                     }
//                 }
//             }
//         }
//     }

//     // WARN: Example sum should be 5117
//     dbg!(&part_numbers);

//     println!(
//         "Sum of the part numbers: {}",
//         part_numbers.into_iter().sum::<u32>()
//     );
// }

fn part2() {
    println!("Part 2");

    let input = include_str!("example.txt");
}
