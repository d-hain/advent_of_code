package main

import "core:fmt"
import "core:os"
import str "core:strings"

main :: proc() {
    input := read_input()
    input_str := cast(string)input

    //fmt.println("Part 1:", part_1())
    //fmt.println("Part 2:", part_2())
}

part_2 :: proc() {
}

part_1 :: proc() {
}

is_digit :: proc(rune: rune) -> bool {
    switch rune {
    case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
        return true
    }

    return false
}

read_input :: proc() -> []u8 {
    input, err := os.read_entire_file_from_filename_or_err("input.txt")
    if err != nil {
        fmt.eprintln("Error reading \"input.txt\":", err)
        os.exit(1)
    }

    return input
}
