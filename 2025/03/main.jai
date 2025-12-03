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

    print("The total Joltage of the batteries is: %\n", total_joltage);
}

part2 :: (lines: []string) {
}

char_to_int :: (x: u8) -> int {
    s: string;
    s.count = 1;
    s.data = alloc(1);
    s[0] = x;
    i, _, _ := str.to_integer(s);

    return i;
}

// int_to_string :: (number: int) -> string {
//         builder: String_Builder;
//         init_string_builder(*builder);
//         print_to_builder(*builder, "%", number);
//         return builder_to_string(*builder);
// }
