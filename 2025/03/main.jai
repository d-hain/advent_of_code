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

part1 :: (lines: []string) {
    total_joltage := 0;

    for bank: lines {
        batteries := int.[0, 0];
        battery1_idx := 0;

        for idx: 0..bank.count - 2 {
            joltage := char_to_int(bank[idx]);
            if joltage > batteries[0] {
                battery1_idx = idx;
                batteries[0] = joltage;
            }
        }
        for < battery, idx_rev: bank {
            if battery1_idx == idx_rev then break;

            joltage := char_to_int(bank[idx_rev]);
            if joltage > batteries[1] then batteries[1] = joltage;
        }

        builder: String_Builder;
        print_to_builder(*builder, "%", batteries[0]);
        print_to_builder(*builder, "%", batteries[1]);
        combined_joltage := str.to_integer(builder_to_string(*builder));
        total_joltage += combined_joltage;
    }

    print("The total Joltage of the 2 batteries is: %\n", total_joltage);
}

part2 :: (lines: []string) {
    total_joltage := 0;

    for bank: lines {
        batteries: [..]int;
        for bank array_add(*batteries, str.to_integer(char_to_string(it)));
        result := array_copy(batteries);

        for 0..batteries.count - 12 - 1 {
            removed := false;
            for result {
                // print("%: %\n", it, it_index);
                if it_index + 1 >= result.count {
                    removed = false;
                    break;
                }
                if it < result[it_index + 1] {
                    array_ordered_remove_by_index(*result, it_index);
                    removed = true;
                    break;
                }
            }
            if !removed then array_ordered_remove_by_index(*result, result.count - 1);
        }

        b: String_Builder;
        for result print_to_builder(*b, "%", it);
        res, _, _ := str.to_integer(builder_to_string(*b));
        total_joltage += res;
    }

    print("The total Joltage of the 12 batteries is: %\n", total_joltage);
}

char_to_int :: (char: u8) -> int {
    s := char_to_string(char);
    i, _, _ := str.to_integer(s);
    return i;
}

char_to_string :: (char: u8) -> string {
    s: string;
    s.count = 1;
    s.data = alloc(1);
    s[0] = char;
    return s;
}
