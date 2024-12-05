package main

import "core:fmt"
import "core:slice"
import "core:os"
import "core:math"
import "core:sort"
import str "core:strings"

main :: proc() {
    input := read_input()

    fmt.println("I do not have the time for AoC today. I will do this problem later... hopefully!")

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

read_input :: proc() -> string {
    input, err := os.read_entire_file_from_filename_or_err("input.txt")
    if err != nil {
        fmt.eprintln("Error reading \"input.txt\":", err)
        os.exit(1)
    }

    return cast(string)input
}
