package main

import "core:fmt"
import "core:slice"
import "core:os"
import "core:math"
import "core:sort"
import str "core:strings"

main :: proc() {
    input := read_input()

    samx_xmas_count := 0

    // line length is always the same
    lines := str.split_lines(input)
    line_length := len(lines[0])

    input = str.join(lines, "")

    for idx := 0; idx < len(input); idx += 1 {
        begin := samx_xmas_count

        // XMAS
        if get(input, idx) == 'X' &&
            get(input, idx+1) == 'M' &&
            get(input, idx+2) == 'A' &&
            get(input, idx+3) == 'S'
        {
            samx_xmas_count += 1
            fmt.println(idx+1, "XMAS")
        }

        // SAMX - SAMX THE SAMX IS REAL. (can we get much higher. sooo hiiiiigh)
        if get(input, idx) == 'S' &&
            get(input, idx+1) == 'A' &&
            get(input, idx+2) == 'M' &&
            get(input, idx+3) == 'X'
        {
            samx_xmas_count += 1
            fmt.println(idx+1, "SAMX - SAMX THE SAMX IS REAL. (can we get much higher. sooo hiiiiigh)")
        }

        // X
        // M
        // A
        // S
        if get(input, idx) == 'X' &&
            get(input, idx+line_length) == 'M' &&
            get(input, idx+line_length*2) == 'A' &&
            get(input, idx+line_length*3) == 'S'
        {
            samx_xmas_count += 1
            fmt.println(idx+1, "XMAS Vert")
        }

        // S
        // A
        // M
        // X
        if get(input, idx) == 'S' &&
            get(input, idx+line_length) == 'A' &&
            get(input, idx+line_length*2) == 'M' &&
            get(input, idx+line_length*3) == 'X'
        {
            samx_xmas_count += 1
            fmt.println(idx+1, "SAMX Vert")
        }

        // X
        // . M
        // . . A
        // . . . S
        if get(input, idx) == 'X' &&
            get(input, idx+line_length+1) == 'M' &&
            get(input, idx+line_length*2+2) == 'A' &&
            get(input, idx+line_length*3+3) == 'S'
        {
            samx_xmas_count += 1
            fmt.println(idx+1, "XMAS down right")
        }

        // S
        // . A
        // . . M
        // . . . X
        if get(input, idx) == 'S' &&
            get(input, idx+line_length+1) == 'A' &&
            get(input, idx+line_length*2+2) == 'M' &&
            get(input, idx+line_length*3+3) == 'X'
        {
            samx_xmas_count += 1
            fmt.println(idx+1, "SAMX down right")
        }

        // . . . X
        // . . M
        // . A
        // S
        if get(input, idx) == 'X' &&
            get(input, idx+line_length-1) == 'M' &&
            get(input, idx+line_length*2-2) == 'A' &&
            get(input, idx+line_length*3-3) == 'S'
        {
            samx_xmas_count += 1
            fmt.println(idx+1, "XMAS down left")
        }

        // . . . S
        // . . A
        // . M
        // X
        if get(input, idx) == 'S' &&
            get(input, idx+line_length-1) == 'A' &&
            get(input, idx+line_length*2-2) == 'M' &&
            get(input, idx+line_length*3-3) == 'X'
        {
            samx_xmas_count += 1
            fmt.println(idx+1, "SAMX down left")
        }
    }

    fmt.println("SAMX:", samx_xmas_count)

    //fmt.println("Part 1:", part_1())
    //fmt.println("Part 2:", part_2())
}

part_2 :: proc() {
}

part_1 :: proc() {
}

get :: proc(input: string, idx: int) -> rune {
    if idx < len(input) {
        return cast(rune)input[idx]
    }

    return '§'
}

read_input :: proc() -> string {
    input, err := os.read_entire_file_from_filename_or_err("example.txt")
    if err != nil {
        fmt.eprintln("Error reading \"input.txt\":", err)
        os.exit(1)
    }

    return cast(string)input
}
