#import "Basic";
#import "File";
#import "String";

main :: () {
    input := read_entire_file("./input.txt");

    // part1(input);
    part2(input);
}

part1 :: (input: string) {
    floor_nr := 0;
    for char: input {
        if char == {
        case #char "("; floor_nr += 1;
        case #char ")"; floor_nr -= 1;
        }
    }

    print("Floor Number: %\n", floor_nr);

}

part2 :: (input: string) {
    floor_nr := 0;
    char_pos := 0;
    for char: input {
        if char == {
        case #char "("; floor_nr += 1;
        case #char ")"; floor_nr -= 1;
        }

        char_pos += 1;

        if floor_nr <= -1 {
            print("Position of char: %\n", char_pos);
            return;
        }
    }
}
