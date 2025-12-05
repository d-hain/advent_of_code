#import "Basic";
#import "File";
#import "Sort";
str :: #import "String";

main :: () {
    // input := read_entire_file("./example.txt");
    input := read_entire_file("./input.txt");
    split := str.split(input, "\n\n");
    fresh_ranges := str.split(split[0], "\n");
    ingredients := str.split(split[1], "\n");

    part1(fresh_ranges, ingredients);
    part2(fresh_ranges);
}

part1 :: (fresh_ranges: []string, ingredients: []string) {
    fresh_ingredients: [..]int;
    for range: fresh_ranges {
        s := str.split(range, "-");
        l, _, _ := str.to_integer(s[0]);
        r, _, _ := str.to_integer(s[1]);

        for ingredient: ingredients {
            id, _, _ := str.to_integer(ingredient);
            if id >= l && id <= r {
                found, _ := array_find(fresh_ingredients, id);
                if !found array_add(*fresh_ingredients, id);
            }
        }
    }

    print("% of the available ingredient IDs are fresh.\n", fresh_ingredients.count);
}

part2 :: (fresh_ranges: []string) {
    fresh_ranges_int: [..][2]int;
    for range: fresh_ranges {
        s := str.split(range, "-");
        l, _, _ := str.to_integer(s[0]);
        r, _, _ := str.to_integer(s[1]);

        array_add(*fresh_ranges_int, int.[l, r]);
    }

    merged := merge_ranges(fresh_ranges_int);

    fresh_ingredient_count := 0;
    for merged {
        fresh_ingredient_count += it[1] - it[0] + 1;
    }

    print("There are % fresh ingredient IDs.\n", fresh_ingredient_count);
}

merge_ranges :: (ranges: [][2]int) -> [][2]int {
    sorted := array_copy(ranges);
    quick_sort(sorted, (a, b) => a[0] - b[0]);
    result: [..][2]int;
    current := sorted[0];
    sorted.data += 1;
    sorted.count -= 1;

    for sorted {
        if it[0] <= current[1] {
            current[1] = max(current[1], it[1]);
        } else {
            array_add(*result, current);
            current = it;
        }
    }

    array_add(*result, current);
    return result;
}
