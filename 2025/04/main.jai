#import "Basic";
#import "File";
#import "Deep_Copy";
str :: #import "String";

main :: () {
    // input := read_entire_file("./example.txt");
    input := read_entire_file("./input.txt");
    lines := str.split(input, "\n");
    lines.count -= 1;
    lines2 := array_copy(lines);

    part1(lines);
    part2(lines2);
}

part1 :: (lines: []string) {
    accessable_paper_rolls_count := 0;
    height := lines.count;
    width := lines[0].count;

    for y: 0..height - 1 {
        for x: 0..width - 1 {
            if lines[y][x] == "." then continue;

            if count_neighbours(lines, y, x) < 4 then accessable_paper_rolls_count += 1;
        }
    }

    print("% rolls of paper can be accesses by a forklift.\n", accessable_paper_rolls_count);
}

part2 :: (input: []string) {
    lines := input;
    removeable_paper_rolls_count := 0;
    height := lines.count;
    width := lines[0].count;

    removed_smth := true;
    new_lines := Deep_Copy(*lines, New(Deep_Copy_Config));
    while removed_smth {
        removed_smth = false;
        for y: 0..height - 1 {
            for x: 0..width - 1 {
                if lines[y][x] == "." then continue;

                if count_neighbours(lines, y, x) < 4 {
                    removeable_paper_rolls_count += 1;
                    removed_smth = true;
                    new_lines.*[y][x] = "x";
                }
            }
        }

        // print_grid(new_lines);
        // print("\n");
        for * new_lines.* it.* = str.replace(it.*, "x", ".");
        lines = new_lines.*;
    }

    print("% total rolls of paper can be removed by a forklift.\n", removeable_paper_rolls_count);
}

count_neighbours :: (lines: []string, y: int, x: int) -> int {
    height := lines.count;
    width := lines[0].count;
    neighbours_count := 0;

    // Top
    if (y - 1) >= 0 && lines[y - 1][x] == "@" then neighbours_count += 1;
    // Bottom
    if (y + 1) < height && lines[y + 1][x] == "@" then neighbours_count += 1;
    // Left
    if (x - 1) >= 0 && lines[y][x - 1] == "@" then neighbours_count += 1;
    // Right
    if (x + 1) < width && lines[y][x + 1] == "@" then neighbours_count += 1;
    // Top-left
    if (x - 1) >= 0 && (y - 1) >= 0 && lines[y - 1][x - 1] == "@" then neighbours_count += 1;
    // Top-right
    if (x + 1) < width && (y - 1) >= 0 && lines[y - 1][x + 1] == "@" then neighbours_count += 1;
    // Bottom-left
    if (x - 1) >= 0 && (y + 1) < height && lines[y + 1][x - 1] == "@" then neighbours_count += 1;
    // Bottom-right
    if (x + 1) < width && (y + 1) < height && lines[y + 1][x + 1] == "@" then neighbours_count += 1;

    return neighbours_count;
}

print_grid :: (lines: []string) {
    height := lines.count;
    width := lines[0].count;

    for y: 0..height - 1 {
        for x: 0..width - 1 {
            print("%", char_to_string(lines[y][x]));
        }
        print("\n");
    }
}

char_to_string :: (char: u8) -> string {
    s: string;
    s.count = 1;
    s.data = alloc(1);
    s[0] = char;
    return s;
}
