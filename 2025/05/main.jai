#import "Basic";
#import "File";
#import "Deep_Copy";
str :: #import "String";

main :: () {
    // input := read_entire_file("./example.txt");
    input := read_entire_file("./input.txt");
    split := str.split(input, "\n\n");
    fresh_ranges := str.split(split[0], "\n");
    ingredients := str.split(split[1], "\n");

    part1(fresh_ranges, ingredients);
    // part2(lines2);
}

part1 :: (fresh_ranges: []string, ingredients: []string) {
    fresh_ingredients: [..]int;
    for range: fresh_ranges {
        s := str.split(range, "-");
        l, _, _ := str.to_integer(s[0]);
        r, _, _ := str.to_integer(s[1]);

        for ingredient: ingredients {
            id, _, _ := str.to_integer(ingredient);
            // print("fresh?: %\n", ingredient);
            if id >= l && id <= r {
                // print("fresh!: %\n", ingredient);
                found, _ := array_find(fresh_ingredients, id);
                if !found array_add(*fresh_ingredients, id);
            }
        }
    }

    print("% of the available ingredient IDs are fresh.\n", fresh_ingredients.count);
}

part2 :: (input: []string) {
}

char_to_string :: (char: u8) -> string {
    s: string;
    s.count = 1;
    s.data = alloc(1);
    s[0] = char;
    return s;
}
