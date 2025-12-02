#import "Basic";
#import "File";
str :: #import "String";

main :: () {
    // input := read_entire_file("./example.txt");
    input := read_entire_file("./input.txt");
    ranges := str.split(input, ",");
    ranges.count -= 1;
    ranges2 := array_copy(ranges);

    part1(ranges);
    part2(ranges2);
}

part1 :: (ranges: []string) {
    invalid_ids_sum := 0;
    for range: ranges {
        sides := str.split(range, "-");
        start := str.to_integer(sides[0]);
        end := str.to_integer(sides[1]);

        for num: start..end {
            num_str := int_to_string(num);
            l := str.slice(num_str, 0, num_str.count / 2);
            r := str.slice(num_str, num_str.count / 2, num_str.count);

            if l.count != r.count then continue;
            if l == r then invalid_ids_sum += num;
        }
    }

    print("The sum of all invalid IDs is: %\n", invalid_ids_sum);
}

part2 :: (ranges: []string) {
}

int_to_string :: (number: int) -> string {
        builder: String_Builder;
        init_string_builder(*builder);
        print_to_builder(*builder, "%", number);
        return builder_to_string(*builder);
}
