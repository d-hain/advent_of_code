package main

import "core:fmt"
import "core:slice"
import "core:os"
import "core:math"
import "core:sort"
import str "core:strings"

main :: proc() {
    input := read_input()

    reports := str.split_lines(input)
    reports = reports[:len(reports)-1] // Last one is empty

    fmt.println("Part 1:", part_1(reports))
    fmt.println("Part 2:", part_2(reports))
}

part_2 :: proc(reports: []string) -> int {
    safe_reports := 0

    for report in reports {
        levels := split_levels(report)
        defer delete(levels)

        if is_report_safe(levels) {
            safe_reports += 1
            continue
        }

        // Duplicate the report into all variants with 1 removed
        dupe_reports := make([dynamic][dynamic]u8)
        defer delete(dupe_reports)
        for u := 0; u < len(levels); u += 1 {
            new_report := slice.clone_to_dynamic(levels[:])
            ordered_remove(&new_report, u)
            append(&dupe_reports, new_report)
        }

        for report_dupe in dupe_reports {
            if is_report_safe(report_dupe) {
                safe_reports += 1
                break
            }
        }
    }

    return safe_reports
}

part_1 :: proc(reports: []string) -> int {
    safe_reports := 0

    for report in reports {
        levels := split_levels(report)
        defer delete(levels)

        if is_report_safe(levels) {
            safe_reports += 1
        }
    }

    return safe_reports
}

is_report_safe :: proc(levels: [dynamic]u8) -> bool {
    is_increasing := true
    is_decreasing := true
    prev_level := levels[0]
    for level in levels[1:] {
        if is_increasing && level > prev_level {
            if abs(cast(i32)prev_level - cast(i32)level) > 3 {
                is_increasing = false
                is_decreasing = false
                break
            }
            is_increasing = true
        } else {
                is_increasing = false
            }

        if is_decreasing && level < prev_level {
            if abs(cast(i32)prev_level - cast(i32)level) > 3 {
                is_increasing = false
                is_decreasing = false
                break
            }
            is_decreasing = true
        } else {
                is_decreasing = false
            }

        prev_level = level
    }

    return is_increasing || is_decreasing
}

split_levels :: proc(report: string) -> (levels: [dynamic]u8) {
    level_idx := 0
    level_builder := str.builder_make()

    for char in report {

        switch {
        case is_digit(char):
            str.write_rune(&level_builder, char)

        case char == ' ':
            level_str := str.to_string(level_builder)
            if level_str != "" {
                append(&levels, str_to_num(level_str, u8))
            }

            level_idx += 1
            level_builder = str.builder_make()
        }
    }

    level_str := str.to_string(level_builder)
    if level_str != "" {
        append(&levels, str_to_num(level_str, u8))
    }

    return
}

str_to_num :: proc(string: string, $num_type: typeid) -> num_type {
    number: num_type = 0

    zeroes := len(string) - 1
    for char in string {
        num := cast(num_type)char - 48
        number += num * cast(num_type)math.pow10_f64(cast(f64)zeroes)
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
