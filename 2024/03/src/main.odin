package main

import "core:fmt"
import "core:slice"
import "core:os"
import "core:math"
import "core:sort"
import "core:strconv"
import str "core:strings"

main :: proc() {
    memory := read_input()

    sum: u32 = 0

    for idx := 0; idx < len(memory); idx += 1 {
        if memory[idx] == 'm' &&
            memory[idx+1] == 'u' &&
            memory[idx+2] == 'l' &&
            memory[idx+3] == '('
        {
            internal_idx := idx + 3
            num1: Maybe(u32) = nil
            num2: Maybe(u32) = nil

            num1_builder := str.builder_make()
            num2_builder := str.builder_make()
            // No number is longer than 3 digits
            // but < 4 because of the comma
            num1_loop: for num1_idx := internal_idx + 1; num1_idx < internal_idx + 4 && num1_idx < len(memory); num1_idx += 1 {
                switch {
                case is_digit(cast(rune)memory[num1_idx]):
                    str.write_rune(&num1_builder, cast(rune)memory[num1_idx])

                case memory[num1_idx] == ',':
                    internal_idx += 1

                    num1_str := str.to_string(num1_builder)
                    if num1_str != "" {
                        num1 = cast(u32)strconv.atoi(num1_str)
                    }

                    break num1_loop
                }
            }

            num1_len: int
            if num1 != nil {
                buf: [3]byte
                num1_len = len(strconv.itoa(buf[:], cast(int)num1.?))
                internal_idx += num1_len

                // < 4 because of the ending brace
                num2_loop: for num2_idx := internal_idx + 1; num2_idx < internal_idx + 4 && num2_idx < len(memory); num2_idx += 1 {
                    switch {
                    case is_digit(cast(rune)memory[num2_idx]):
                        str.write_rune(&num2_builder, cast(rune)memory[num2_idx])

                    case memory[num2_idx] == ')':
                        internal_idx += 1

                        num2_str := str.to_string(num2_builder)
                        if num2_str != "" {
                            num2 = cast(u32)strconv.atoi(num2_str)
                        }

                        break num2_loop
                    }
                }
            }

            if num2 != nil {
                buf: [3]byte
                num2_len := len(strconv.itoa(buf[:], cast(int)num2.?))
                internal_idx += num2_len

                if memory[internal_idx] == ')' {
                    fmt.println("SAMC!:", cast(rune)num1.?, cast(rune)num2.?)
                    sum += num1.? * num2.?

                    idx = internal_idx
                }
            }
        }
    }

    fmt.println(sum)

    //fmt.println("Part 1:", part_1(reports))
    //fmt.println("Part 2:", part_2(reports))
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
