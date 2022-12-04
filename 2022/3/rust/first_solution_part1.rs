trait StringPriority {
    fn priority(&self) -> u32;
}

impl StringPriority for String {
    fn priority(&self) -> u32 {
        let mut priority = *&self.chars().collect::<Vec<char>>()[0] as u32;

        if priority <= 90 && priority >= 65 {
            priority -= 38;
        } else if priority <= 122 && priority >= 97 {
            priority -= 96;
        }

        priority
    }
}

fn main() {
    let input = std::fs::read_to_string("../input.txt").unwrap();
    let lines = input.split("\n");

    let mut priorities_sum = 0;
    for line in lines {
        let (compartment1, compartment2) = line.split_at(line.len() / 2);

        let compartment1_chars = compartment1.chars().collect::<Vec<char>>();
        let compartment2_chars = compartment2.chars().collect::<Vec<char>>();

        for i in 0..compartment1_chars.len() {
            if compartment1_chars.contains(&compartment2_chars[i]) {
                priorities_sum += &compartment2_chars[i].to_string().priority();
                break;
            }
        }
    }

    println!("Part 1: {}", priorities_sum);
}
