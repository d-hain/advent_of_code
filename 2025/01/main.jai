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
    dial_is_zero_count := 0;
    dial := 50;
    for *line: lines {
        direction := line.*[0];
        line.data += 1;
        number, _, _ := str.to_integer(line.*);

        // print("% % ", dial, number);
        // print_character(direction);
        // print("\n");

        if direction == {
        case #char "L"; dial -= number;
        case #char "R"; dial += number;
        }
        while dial <  0 { dial += 100; }
        while dial > 99 { dial -= 100; }

        if dial == 0 then dial_is_zero_count += 1;
    }

    print("The actual password to open the door is: %\n", dial_is_zero_count);
}

part2 :: (lines: []string) {
    dial_is_zero_count := 0;
    dial := 50;
    for *line: lines {
        direction := line.*[0];
        line.data += 1;
        number, _, _ := str.to_integer(line.*);

        print("% % ", dial, number);
        print_character(direction);
        print(" %\n", dial_is_zero_count);

        if direction == {
        case #char "L"; dial -= number;
            // while number > 0 {
            //     number -= 1;
            //     dial -= 1;
            //
            //     if dial < 0 {
            //         dial += 100;
            //         dial_is_zero_count += 1;
            //     }
            // }
        case #char "R"; dial += number;
            // while number > 0 {
            //     number -= 1;
            //     dial += 1;
            //
            //     if dial > 99 {
            //         dial -= 100;
            //         dial_is_zero_count += 1;
            //     }
            // }
        }
        // TODO: WTF 5876 ist zu klein?!?!?!?!?!?!?
        while dial <  0 {
            dial += 100;
            dial_is_zero_count += 1;
        }
        while dial > 99 {
            dial -= 100;
            dial_is_zero_count += 1;
        }
    }

    print("The actual password to open the door (using method: 0x434C49434B) is: %\n", dial_is_zero_count);
}
