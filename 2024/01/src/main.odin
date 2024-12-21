package main

import "core:fmt"
import "core:os"
import "core:sort"
import "core:strconv"
import str "core:strings"

main :: proc() {
    input := read_input()

    left, right := split_lists(cast(string)input)
    defer delete(left)
    defer delete(right)

    fmt.println("Part 1:", part_1(left, right))
    assert(part_1(left, right) == 2375403)
    fmt.println("Part 2:", part_2(left, right))
    assert(part_2(left, right) == 23082277)
}

part_2 :: proc(left: []int, right: []int) -> int {
    similarity: int = 0

    // NOTE: I was confused why this works.
    //       But there are no duplicates in a list!!!
    for num_l in left {
        num_l_count: int = 0

        for num_r in right {
            if num_l == num_r {
                num_l_count += 1
            }
        }

        similarity += num_l * num_l_count
    }

    return similarity
}

part_1 :: proc(left: []int, right: []int) -> int {
    sort.quick_sort(left[:])
    sort.quick_sort(right[:])

    sum: int = 0
    for idx := 0; idx < len(left); idx += 1 {
        sum += abs(left[idx] - right[idx])
    }

    return sum
}

split_lists :: proc(input: string) -> ([]int, []int) {
    lines := str.split_lines(input)
    lines = lines[:len(lines)-1]

    left := make([dynamic]int)
    right := make([dynamic]int)

    for line in lines {
        nums_str := str.split(line, "   ")

        append(&left, strconv.atoi(nums_str[0]))
        append(&right, strconv.atoi(nums_str[1]))
    }

    return left[:], right[:]
}

read_input :: proc() -> []u8 {
    input, err := os.read_entire_file_from_filename_or_err("input.txt")
    if err != nil {
        fmt.eprintln("Error reading \"input.txt\":", err)
        os.exit(1)
    }

    return input
}
