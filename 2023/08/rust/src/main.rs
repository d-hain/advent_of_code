use std::collections::HashMap;

type Nodes = HashMap<String, (String, String)>;

fn main() {
    println!("AOC 2023 - Day 8");

    part1();
    part2();
}

fn part1() {
    println!("Part 1");

    let input = include_str!("input.txt");

    let instructions = get_instructions(input);
    let nodes = get_nodes(input);

    println!(
        "Required steps to ZZZ: {}",
        walk_nodes(instructions, nodes).unwrap()
    );
}

fn part2() {
    println!("Part 2");

    let input = include_str!("input.txt");

    let instructions = get_instructions(input);
    let nodes = get_nodes(input);
    let starting_nodes = find_starting_nodes(nodes.clone());

    println!(
        "Required steps to all nodes ending with \"Z\": {}",
        walk_nodes_parallel(instructions, nodes, starting_nodes).unwrap()
    );
}

fn get_instructions(input: &str) -> Vec<char> {
    input
        .lines()
        .nth(0)
        .expect("Line with the instructions")
        .chars()
        .collect()
}

fn get_nodes(input: &str) -> Nodes {
    input
        .lines()
        .skip(2)
        .map(|node| {
            let mut split = node.split("=");

            let node_identifier = split.nth(0).unwrap().trim().to_owned();

            let mut next_nodes = split.last().unwrap().split(", ");
            let left_node = next_nodes.nth(0).unwrap().replace(" (", "");
            let right_node = next_nodes.last().unwrap().replace(")", "");

            (node_identifier, (left_node, right_node))
        })
        .collect()
}

fn get_next_node(instruction: char, next_nodes: (String, String)) -> String {
    match instruction {
        'R' => next_nodes.1,
        'L' => next_nodes.0,
        _ => unreachable!(),
    }
}

fn walk_nodes(instructions: Vec<char>, nodes: Nodes) -> Option<u32> {
    let mut required_steps = 0;

    let mut next_node = "".to_owned();
    for (idx, instruction) in instructions.into_iter().cycle().enumerate() {
        if idx == 0 {
            next_node = get_next_node(
                instruction,
                nodes
                    .get("AAA")
                    .expect("Node AAA should always exist")
                    .clone(),
            );
            required_steps += 1;
            continue;
        }

        if next_node == "ZZZ".to_owned() {
            return Some(required_steps);
        }

        next_node = get_next_node(
            instruction,
            nodes.get(&next_node).expect("An existing node").clone(),
        );
        required_steps += 1;
    }

    None
}

fn find_starting_nodes(nodes: Nodes) -> Nodes {
    let mut starting_nodes = HashMap::new();
    for node in nodes.keys() {
        if node.ends_with("A") {
            starting_nodes.insert(node.to_owned(), nodes.get(node).unwrap().to_owned());
        }
    }

    starting_nodes
}

fn walk_nodes_parallel(
    instructions: Vec<char>,
    nodes: Nodes,
    starting_nodes: Nodes,
) -> Option<u32> {
    let mut required_steps = 0;

    // WARN: To make this performant I'd have to know how graphs work.
    //       This does work, but for it to give me the correct solution I would have to let it run
    //       for about 68 days straight. Which I won't do.
    let mut next_nodes = Vec::new();
    for (idx, instruction) in instructions.into_iter().cycle().enumerate() {
        if idx == 0 {
            let mut new_next_nodes = Vec::new();
            for starting_node in starting_nodes.values() {
                new_next_nodes.push(get_next_node(instruction, starting_node.to_owned()));
            }
            next_nodes = new_next_nodes;
            required_steps += 1;
            continue;
        }

        if next_nodes.iter().all(|node| node.ends_with("Z")) {
            return Some(required_steps);
        }

        let mut new_next_nodes = Vec::new();
        for node in next_nodes {
            new_next_nodes.push(get_next_node(
                instruction,
                nodes.get(&node).unwrap().to_owned(),
            ));
        }
        next_nodes = new_next_nodes;
        required_steps += 1;
    }

    None
}

#[cfg(test)]
mod tests {
    use crate::*;

    #[test]
    fn test_part1_example1() {
        let input = include_str!("example1_part1.txt");

        let instructions = get_instructions(input);
        let nodes = get_nodes(input);

        let required_steps = walk_nodes(instructions, nodes);

        assert_eq!(required_steps, Some(2));
    }

    #[test]
    fn test_part1_example2() {
        let input = include_str!("example2_part1.txt");

        let instructions = get_instructions(input);
        let nodes = get_nodes(input);

        let required_steps = walk_nodes(instructions, nodes);

        assert_eq!(required_steps, Some(6));
    }

    #[test]
    fn test_part2_example() {
        let input = include_str!("example_part2.txt");

        let instructions = get_instructions(input);
        let nodes = get_nodes(input);
        let starting_nodes = find_starting_nodes(nodes.clone());

        let required_steps = walk_nodes_parallel(instructions, nodes, starting_nodes);

        assert_eq!(required_steps, Some(6));
    }
}
