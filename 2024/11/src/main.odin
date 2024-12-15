package main

import "core:fmt"
import "core:os"
import "core:c/libc"
import "core:strconv"
import str "core:strings"

main :: proc() {
    input := read_input()
    input_str := cast(string)input

    fmt.println("Part 1:", part_1(input_str))
    fmt.println("Part 2:", part_2(input_str))
}

part_2 :: proc(input_str: string) -> uint {
    blinks :: 75
    fmt.printfln("(%d Blinks)", blinks)

    return blink_a_lot(input_str, blinks)
}

part_1 :: proc(input_str: string) -> uint {
    blinks :: 25
    fmt.printfln("(%d Blinks)", blinks)

    return blink_a_lot(input_str, blinks)
}

blink_a_lot :: proc(input_str: string, blinks: uint) -> uint {
    stones := parse_stones(input_str)
    defer delete(stones)

    for _ in 0..<blinks {
        when ODIN_DEBUG {
            if libc.getchar() != '\n' {
                continue
            }
        }

        old_stones := make([dynamic]uint, len(stones), cap(stones))
        defer delete(old_stones)


        // Copy `stones` to `old_stones`
        copy(old_stones[:], stones[:])
        // Clear stones
        clear(&stones)

        for stone in old_stones {
            if stone == 0 {
                append(&stones, 1)
            } else if digit_count(stone) % 2 == 0 {
                left, right := split_digits(stone)

                append(&stones, left)
                append(&stones, right)
            } else {
                append(&stones, stone * 2024)
            }
        }
    }

    return len(stones)
}

split_digits :: proc(stone: uint) -> (uint, uint) {
    buf: [9999]u8
    stone_str := strconv.itoa(buf[:], cast(int)stone)
    stone_len := len(stone_str)

    if stone_len % 2 != 0 {
        msg_buf: [9999]u8
        msg := fmt.bprintfln(msg_buf[:], "Stone \"%v\" has to have an even number of digits to split them!", stone)
        panic(msg)
    }

    left, _ := strconv.parse_uint(stone_str[:stone_len/2])
    right, _ := strconv.parse_uint(stone_str[stone_len/2:])

    return left, right
}

digit_count :: proc(stone: uint) -> uint {
    buf: [9999]u8
    stone_str := strconv.itoa(buf[:], cast(int)stone)

    return len(stone_str)
}

parse_stones :: proc(input: string) -> (stones: [dynamic]uint) {
    stones_str := str.split(input, " ")

    for stone_str, idx in stones_str {
        stone, _ := strconv.parse_uint(stone_str)
        append(&stones, stone)
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
    input, err := os.read_entire_file_from_filename_or_err("input.txt")
    if err != nil {
        fmt.eprintln("Error reading \"input.txt\":", err)
        os.exit(1)
    }

    return input
}
