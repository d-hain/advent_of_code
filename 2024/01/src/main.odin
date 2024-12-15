package main

import "core:fmt"
import "core:os"
import "core:math"
import "core:sort"
import str "core:strings"

main :: proc() {
    input := read_input()

    left, right := split_lists(input)

    fmt.println("Part 1:", part_1(left, right))
    fmt.println("Part 2:", part_2(left, right))
}

part_2 :: proc(left: [dynamic]i32, right: [dynamic]i32) -> i32 {
    similarity: i32 = 0

    // NOTE: I was confused why this works.
    //       But there are no duplicates in a list!!!
    for num_l in left {
        num_l_count: i32 = 0

        for num_r in right {
            if num_l == num_r {
                num_l_count += 1
            }
        }

        similarity += num_l * num_l_count
    }

    return similarity
}

part_1 :: proc(left: [dynamic]i32, right: [dynamic]i32) -> i32 {
    sort.quick_sort(left[:])
    sort.quick_sort(right[:])

    sum: i32 = 0
    for idx := 0; idx < len(left); idx += 1 {
        sum += cast(i32)abs(left[idx] - right[idx])
    }

    return sum
}

split_lists :: proc(input: string) -> (left: [dynamic]i32, right: [dynamic]i32) {
    lines := str.split_lines(cast(string)input)

    for line in lines {
        whitespace_count := 0
        number_builder_left := str.builder_make()
        number_builder_right := str.builder_make()

        for char in line {
            if is_digit(char) {
                if whitespace_count == 0 {
                    str.write_rune(&number_builder_left, char)
                } else {
                    str.write_rune(&number_builder_right, char)
                }
            }

            if char == ' ' {
                whitespace_count += 1
            }
        }

        number_str_left := str.to_string(number_builder_left)
        if number_str_left != "" {
            append(&left, str_to_int(number_str_left, i32))
        }

        number_str_right := str.to_string(number_builder_right)
        if number_str_left != "" {
            append(&right, str_to_int(number_str_right, i32))
        }
    }

    return
}

str_to_int :: proc(string: string, $int_type: typeid) -> int_type {
    number: int_type = 0

    zeroes := len(string) - 1
    for char in string {
        num := cast(int_type)char - 48
        number += num * cast(int_type)math.pow10_f64(cast(f64)zeroes)
        zeroes -= 1
    }

    return number
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
