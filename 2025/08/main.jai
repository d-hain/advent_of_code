#import "Basic";
#import "File";
#import "Hash_Table";
#import "Math";
#import "Sort";
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

Position :: struct {
    x, y, z: int;
}

operator == :: (a: Position, b: Position ) -> bool {
    return a.x == b.x && a.y == b.y && a.z == b.z;
}

position_hash :: (a: Position, b: Position) -> u32 {
    Hash :: #import "Hash";
    builder: String_Builder;
    print_to_builder(*builder, "%:%", a, b);
    return Hash.get_hash(builder_to_string(*builder));
}

part1 :: (lines: []string) {
    pair_distance: Table(u32, float64);
    for line: lines {
        box := parse_box(line);

        for line2: lines {
            box2 := parse_box(line2);
            if box == box2 then continue;

            distance := sqrt(
                  pow(cast(float64)box.x - box2.x, 2)
                + pow(cast(float64)box.y - box2.y, 2)
                + pow(cast(float64)box.z - box2.z, 2)
            );
            table_add(*pair_distance, position_hash(box, box2), distance);
        }
    }

    // TODO: Next Up: "sort" hash table then connect circuits
}

// part2 :: (lines: []string) {
// }

parse_box :: (line: string) -> Position {
    s := str.split(line, ",");
    x, _, _ := str.to_integer(s[0]);
    y, _, _ := str.to_integer(s[1]);
    z, _, _ := str.to_integer(s[2]);
    return .{x=x, y=y, z=z};
}

char_to_string :: (char: u8) -> string {
    s: string;
    s.count = 1;
    s.data = alloc(1);
    s[0] = char;
    return s;
}
