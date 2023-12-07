fn main() {
    println!("AOC 2023 - Day 2");

    part1();
    part2();
}

fn part1() {
    println!("Part 1");

    let input = include_str!("input.txt");

    let mut all_games = Vec::new();
    let mut non_winning_games = Vec::new();

    for game in input.lines() {
        let split_game = game.split(": ").collect::<Vec<&str>>();
        let game_id = split_game[0].replace("Game ", "").parse::<u32>().unwrap();
        all_games.push(game_id);

        let game_data = split_game[1];
        let game_data = game_data.replace(";", ",");

        let cubes = game_data.split(", ").collect::<Vec<&str>>();
        for cube in cubes {
            let split_cube = cube.split(" ").collect::<Vec<&str>>();
            let amount = split_cube[0].parse::<u32>().unwrap();
            let color = split_cube[1];

            if color == "red" {
                if amount > 12 {
                    non_winning_games.push(game_id);
                    break;
                }
            }
            if color == "green" {
                if amount > 13 {
                    non_winning_games.push(game_id);
                    break;
                }
            }
            if color == "blue" {
                if amount > 14 {
                    non_winning_games.push(game_id);
                    break;
                }
            }
        }
    }

    let possible_games_sum = all_games
        .iter()
        .filter(|game| !non_winning_games.contains(game))
        .sum::<u32>();

    println!("Possible Game ID sum: {}", possible_games_sum);
}

fn part2() {
    println!("Part 2");

    let input = include_str!("input.txt");

    let mut game_powers_sum = 0;

    for game in input.lines() {
        let split_game = game.split(": ").collect::<Vec<&str>>();
        let game_data = split_game[1];
        let game_data = game_data.replace(";", ",");

        let cubes = game_data.split(", ").collect::<Vec<&str>>();
        let mut max_red_cubes = 0;
        let mut max_green_cubes = 0;
        let mut max_blue_cubes = 0;
        for cube in cubes {
            let split_cube = cube.split(" ").collect::<Vec<&str>>();
            let amount = split_cube[0].parse::<u32>().unwrap();
            let color = split_cube[1];

            if color == "red" {
                if amount > max_red_cubes {
                    max_red_cubes = amount;
                }
            }
            if color == "green" {
                if amount > max_green_cubes {
                    max_green_cubes = amount;
                }
            }
            if color == "blue" {
                if amount > max_blue_cubes {
                    max_blue_cubes = amount;
                }
            }
        }

        game_powers_sum += max_red_cubes * max_green_cubes * max_blue_cubes;
    }

    println!("Sum of all game powers: {}", game_powers_sum);
}
