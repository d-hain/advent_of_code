#import "Basic";
#import "File";
str :: #import "String";

main :: () {
    input := read_entire_file("./example.txt");
    // input := read_entire_file("./input.txt");
    lines := str.split(input, "\n");
    lines.count -= 1;
    lines2 := array_copy(lines);

    part1(lines);
    // part2(lines2);
}

Button :: struct {
    indexes: [..]int;
}

Machine :: struct {
    light_end_positions: [..]bool;
    buttons: [..]Button;
    joltages: [..]int;
}

parse_machines :: (lines: []string) -> []Machine {
    machines: [..]Machine;

    for line: lines {
        s := str.split(line, " ");
        machine: Machine;

        for char: s[0] {
            if char == {
            case ".";
                array_add(*machine.light_end_positions, false);
            case "#";
                array_add(*machine.light_end_positions, true);
            }
        }
        array_ordered_remove_by_index(*s, 0);

        joltage_str := pop(*s);
        joltage_str.data += 1;
        joltage_str.count -= 2;
        joltages := str.split(joltage_str, ",");
        for joltages {
            joltage, _, _ := str.to_integer(it);
            array_add(*machine.joltages, joltage);
        }

        for * s {
            it.data += 1;
            it.count -= 2;
            nums := str.split(it.*, ",");

            light_idxs: [..]int;
            for nums {
                light_idx, _, _ := str.to_integer(it);
                array_add(*light_idxs, light_idx);
            }

            array_add(*machine.buttons, .{light_idxs});
        }

        array_add(*machines, machine);
    }

    return machines;
}

part1 :: (lines: []string) {
    machines := parse_machines(lines);

    fewest_presses := 0;
    for machine: machines {
        for buttons: button_combinations(machine.buttons) {
            print("%\n", buttons);
            lights: [..]bool;
            array_resize(*lights, machine.light_end_positions.count);

            presses := 0;
            for buttons {
                press_button(*lights, it);
                presses += 1;
                if array_compare(lights, machine.light_end_positions) {
                    fewest_presses += presses;
                    break buttons;
                }
            }
        }
    }

    print("The fewest button presses to configure the indicators correctly are: %\n", fewest_presses);
}

// part2 :: (lines: []string) {
// }

button_combinations :: (buttons: []Button) -> [][]Button {
    combinations: [..][]Button;

    // TODO: AAAAAAAAAAAAAAA

    return combinations;
}

pow :: (base: int, exp: int) -> int {
    result := 1;
    while exp > 0 {
        if exp % 2 == 1 then result *= base;
        base *= base;
        exp /= 2;
    }
    return result;
}

array_compare :: (a: []bool, b: []bool) -> bool {
    for a if it != b[it_index] return false;
    return true;
}

press_button :: (lights: *[]bool, button: Button) {
    for idx: button.indexes {
        lights.*[idx] = !lights.*[idx];
    }
}

char_to_string :: (char: u8) -> string {
    s: string;
    s.count = 1;
    s.data = alloc(1);
    s[0] = char;
    return s;
}
