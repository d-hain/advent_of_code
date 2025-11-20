#import "Basic";
#import "File";
sort :: #import "Sort";
str :: #import "String";

main :: () {
    // input := read_entire_file("./example.txt");
    input := read_entire_file("./input.txt");
    lines := str.split(input, "\n");
    lines.count -= 1;

    // part1(lines);
    part2(lines);
}

part1 :: (lines: []string) {
    total_area := 0;
    for line: lines {
        dimensions := str.split(line, "x");
        sides := int.[
            str.string_to_int(dimensions[0]) * str.string_to_int(dimensions[1]),
            str.string_to_int(dimensions[1]) * str.string_to_int(dimensions[2]),
            str.string_to_int(dimensions[2]) * str.string_to_int(dimensions[0]),
        ];
        area := 2 * sides[0] + 2 * sides[1] + 2 * sides[2];
        sort.quick_sort(sides, (x) => x);
        extra := sides[0];
        total_area += area + extra;
    }

    print("Total square feet of wrapping paper: %\n", total_area);
}

part2 :: (lines: []string) {
    ribbon_length := 0;
    for line: lines {
        dimensions := str.split(line, "x");
        sides := int.[
            str.string_to_int(dimensions[0]) + str.string_to_int(dimensions[0]) + str.string_to_int(dimensions[1]) + str.string_to_int(dimensions[1]),
            str.string_to_int(dimensions[1]) + str.string_to_int(dimensions[1]) + str.string_to_int(dimensions[2]) + str.string_to_int(dimensions[2]),
            str.string_to_int(dimensions[2]) + str.string_to_int(dimensions[2]) + str.string_to_int(dimensions[0]) + str.string_to_int(dimensions[0]),
        ];
        sort.quick_sort(sides, (x) => x);
        extra := str.string_to_int(dimensions[0]) * str.string_to_int(dimensions[1]) * str.string_to_int(dimensions[2]);
        ribbon_length += sides[0] + extra;
    }

    print("Total feet of ribbon needed: %\n", ribbon_length);
}
