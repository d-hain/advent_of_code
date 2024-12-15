package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:slice"
import "core:unicode/utf8"
import str "core:strings"

operators := [?]rune { '+', '*' }

main :: proc() {
    input := read_input()
    input_str := cast(string)input

    lines := str.split_lines(input_str)
    lines = lines[:len(lines)-1] // Last line is empty

    for line in lines {
        test_value, numbers := parse_equation(line)
        fmt.println(test_value, numbers)

        operator_count := len(numbers) - 1
        possible_equation_count := operator_count * len(operators)

        equation_operators := generate_combinations(operators[:], len(numbers) - 1)
        defer delete(equation_operators)
        fmt.println(equation_operators)

        //result := numbers[0]
        //for number in numbers[0:] {
        //    result = result + number
        //}
        //fmt.println(result)
    }

    //fmt.println("Part 1:", part_1())
    //fmt.println("Part 2:", part_2())
}

part_2 :: proc() {
}

part_1 :: proc() {
}

generate_combinations :: proc(characters: []rune, length: int) -> (combinations: [dynamic][dynamic]rune) {
}

parse_equation :: proc(line: string) -> (test_value: uint, numbers: [dynamic]uint) {
    number_builder := str.builder_make()

    for char, idx in line {
        switch {
        case is_digit(char):
            str.write_rune(&number_builder, char)

        case char == ':':
            test_value_str := str.to_string(number_builder)
            if test_value_str != "" {
                test_value, _ = strconv.parse_uint(test_value_str)
            }
            str.builder_init(&number_builder)

        case char == ' ':
            number_str := str.to_string(number_builder)
            if number_str != "" {
                number, _ := strconv.parse_uint(number_str)
                append(&numbers, number)
            }
            str.builder_init(&number_builder)
        }

        // Last number
        if idx == len(line) -1 {
            number_str := str.to_string(number_builder)
            if number_str != "" {
                number, _ := strconv.parse_uint(number_str)
                append(&numbers, number)
            }
        }
    }

    return
}

is_digit :: proc(rune: rune) -> bool {
    switch rune {
    case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
        return true
    }

    return false
}

read_input :: proc() -> []u8 {
    input, err := os.read_entire_file_from_filename_or_err("example.txt")
    if err != nil {
        fmt.eprintln("Error reading \"input.txt\":", err)
        os.exit(1)
    }

    return input
}
