#import "Basic";
#import "File";
str :: #import "String";

main :: () {
    // input := read_entire_file("./example.txt");
    input := read_entire_file("./input.txt");
    lines := str.split(input, "\n");
    lines.count -= 1;
    lines2 := array_copy(lines);

    part1(lines);
    // part2(lines2);
}

part1 :: (lines: []string) {
    height := lines.count - 1;
    width := lines[0].count - 1;

    for y: 0..height {
        for x: 0..width {
            char := lines[y][x];

            if char == "^" {
                if y - 1 >= 0 && lines[y - 1][x] != "|" then continue;

                if x - 1 >= 0 && lines[y][x - 1] == "." then lines[y][x - 1] = "|";
                if x + 1 <= width && lines[y][x + 1] == "." then lines[y][x + 1] = "|";
            }
        }

        for x: 0..width {
            char := lines[y][x];

            if char == {
            case "S"; #through;
            case "|";
                if y + 1 <= height && lines[y + 1][x] == "." {
                    lines[y + 1][x] = "|";
                }
            }
        }
    }

    split_count := 0;
    for y: 0..height {
        for x: 0..width {
            char := lines[y][x];
            if char == "^" && y - 1 >= 0 && lines[y - 1][x] == "|" then split_count += 1;
        }
    }

    for lines print("%\n", it);
    print("The beam was split % times.\n", split_count);
}

part2 :: (lines: []string) {

}

char_to_string :: (char: u8) -> string {
    s: string;
    s.count = 1;
    s.data = alloc(1);
    s[0] = char;
    return s;
}
