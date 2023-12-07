use std::collections::HashSet;

fn main() {
    println!("Advent Of Code Day 6:\n");

    let input = std::fs::read_to_string("../input.txt").unwrap();

    println!("First Solution: ");
    FirstSolution::part1(&input);
    FirstSolution::part2(&input);
}

struct FirstSolution;

impl FirstSolution {
    fn part1(input: &str) {
       println!("Part 1: {}", Self::get_index_of_last_char_in_packet(input, 4).unwrap());
    }

    fn part2(input: &str) {
        println!("Part 2: {}", Self::get_index_of_last_char_in_packet(input, 14).unwrap());
    }
    
    fn get_index_of_last_char_in_packet(input: &str, packet_length: usize) -> Option<usize> {
        let mut input_mut: String = input.into();

        let mut last_packet_chars: Vec<char> = vec![];
        for char in input.chars().into_iter() {
            if last_packet_chars.len() > packet_length - 1 {
                last_packet_chars.remove(0);
            }
            last_packet_chars.push(char);

            let mut uniq = HashSet::new();
            if last_packet_chars.iter().all(|x| uniq.insert(x)) && last_packet_chars.len() > packet_length - 1 {
                return Some(input_mut.find(last_packet_chars[packet_length - 1]).unwrap() + 1)
            }
            input_mut = input_mut.replacen(char, ".", 1);
        }
        
        None
    }
}
