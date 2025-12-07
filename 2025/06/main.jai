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
    part2(lines2);
}

Calculation :: struct {
    numbers: [..]int;
    symbol: u8;
}

part1 :: (lines: []string) {
    parse_numbers :: (line: *string, calculations: *[..]Calculation) {
        calc_idx := 0;
        added := false;
        digits: String_Builder;
        { // Hacky way to make my loop below parse correctly
            line.count += 1;
            line.*[line.count - 1] = " ";
        }

        for char: str.trim_left(line.*) {
            if is_digit(char) {
                append(*digits, char);
                added = false;
            } else if !added {
                if calculations.count == calc_idx then array_add(calculations, .{});

                number, _, _ := str.to_integer(builder_to_string(*digits));
                array_add(*calculations.*[calc_idx].numbers, number);

                calc_idx += 1;
                added = true;
            }
        }
    }

    calculations: [..]Calculation;
    for * line: lines {
        if it_index < lines.count - 1 {
            parse_numbers(line, *calculations);
        } else {
            parse_symbols(line, *calculations);
        }
    }

    print("The grand total of all calculations is: %\n", calculate_grand_total(calculations));
}

// Part 2 is way cleaner
part2 :: (lines: []string) {
    parse_numbers :: (lines: []string, calculations: *[..]Calculation) {
        calc_idx := 0;
        for x: 0..lines[0].count - 1 {
            digits: String_Builder;

            for y: 0..lines.count - 2 {
                char := lines[y][x];

                if is_digit(char) {
                    append(*digits, char);
                }
                if y == lines.count - 2 {
                    if calculations.count == calc_idx then array_add(calculations, .{});

                    number, success, _ := str.to_integer(builder_to_string(*digits));
                    if success then array_add(*calculations.*[calc_idx].numbers, number);
                    else calc_idx += 1;
                }
            }
        }
    }

    calculations: [..]Calculation;
    parse_numbers(lines, *calculations);
    parse_symbols(*lines[lines.count - 1], *calculations);

    print("The grand total of all calculations is: %\n", calculate_grand_total(calculations));
}

calculate_grand_total :: (calculations: []Calculation) -> int {
    grand_total := 0;

    for calc: calculations {
        result := 0;
        for calc.numbers {
            if calc.symbol == {
            case "*"; if result == 0 then result = 1; result *= it;
            case "+"; result += it;
            }
        }
        grand_total += result;
    }

    return grand_total;
}

parse_symbols :: (line: *string, calculations: *[..]Calculation) {
    calc_idx := 0;
    counted := false;

    for char: line.* {
        if char == {
        case "+"; #through;
        case "*";
            calculations.*[calc_idx].symbol = char;
            counted = false;
        case " ";
            if !counted {
                calc_idx += 1;
                counted = true;
            }
            continue;
        }
    }
}
