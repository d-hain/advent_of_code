/// A, X => Rock
/// B, Y => Paper
/// C, Z => Scissors
fn part1(input: &str){
    let lines = input.split("\n");

    let mut total_score = 0;
    for line in lines {
        total_score += match line {
            "A X" => 4,
            "A Y" => 8,
            "A Z" => 3,
            "B X" => 1,
            "B Y" => 5,
            "B Z" => 9,
            "C X" => 7,
            "C Y" => 2,
            "C Z" => 6,
            _ => 0
        };
    }

    println!("Part 1: {}", total_score);
}

/// A, B, C => Rock, Paper, Scissors
/// X => You need to lose
/// Y => You need to draw
/// Z => You need to win
fn part2(input: &str){
    let lines = input.split("\n");

    let mut total_score = 0;
    for line in lines {
        total_score += match line {
            "A X" => 3,
            "A Y" => 4,
            "A Z" => 8,
            "B X" => 1,
            "B Y" => 5,
            "B Z" => 9,
            "C X" => 2,
            "C Y" => 6,
            "C Z" => 7,
            _ => 0
        };
    }

    println!("Part 2: {}", total_score);
}
