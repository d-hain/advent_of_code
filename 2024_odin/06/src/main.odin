package main

import "core:fmt"
import "core:slice"
import "core:os"
import "core:math"
import "core:sort"
import "core:c/libc"
import "core:time"
import str "core:strings"

Direction :: enum {
    Up,
    Down,
    Left,
    Right,
}

VISUALIZE :: #config(VISUALIZE, false) || ODIN_DEBUG

main :: proc() {
    input := read_input()
    input_str := cast(string)input
    // +1 because of newlines
    line_length := len(str.split_lines(input_str)[0]) + 1

    //fmt.println("Part 1: Finished with", part_1(input, input_str, line_length), "steps.")
    fmt.println("Part 2: Possible obstruction positions: ", part_2(input, input_str, line_length))
}

part_2 :: proc(input: []u8, input_str: string, line_length: int) -> int {
    input := input
    input_str := input_str
    obstruction_positions := 0

    start_input := str.clone_from_bytes(input)

    // Brute force is da way
    for idx := 0; idx < len(input); idx += 1 {
        if input[idx] != '.' {
            continue
        }

        input[idx] = '#'

        if is_guard_trapped(input, input_str, line_length, obstruction_positions, idx) {
            obstruction_positions += 1
        }

        input = transmute([]u8)str.clone(start_input)
        input_str = cast(string)input
    }

    return obstruction_positions
}

// Moves the guard and returns true if he is trapped. maybe idk
is_guard_trapped :: proc(input: []u8, input_str: string, line_length, obstruction_positions, iteration: int, max_steps := 10000) -> bool {
    guard_dir: Direction
    guard_steps := 0

    loop: for guard_idx := str.index(input_str, "^"); guard_idx != -1; guard_idx = str.index(input_str, "^") {
        if guard_steps >= max_steps {
            return true
        }

        when ODIN_DEBUG {
            if libc.getchar() != '\n' {
                continue
            }
        }
        when VISUALIZE {
            time.sleep(1000000) // 0.001s
            libc.system("clear") // gotta love `system`
        }

        up := guard_idx - line_length
        down := guard_idx + line_length
        right := guard_idx + 1
        left := guard_idx - 1

        switch guard_dir {
        case .Up:
            if up < 0 {
                break loop
            } else if input[up] == '#' {
                // Move 90° right
                input[right] = '^'
                guard_dir = .Right
                dbgln("move up: right")
            } else {
                input[up] = '^'
                dbgln("move up")
            }

        case .Down:
            if down > len(input) {
                break loop
            } else if input[down] == '#' {
                // Move 90° right
                input[left] = '^'
                guard_dir = .Left
                dbgln("move down: left")
            } else {
                input[down] = '^'
                dbgln("move down")
            }

        case .Right:
            if right > len(input) {
                break loop
            } else if input[right] == '\n' {
                break loop
            } else if input[right] == '#' {
                // Move 90° right
                input[down] = '^'
                guard_dir = .Down
                dbgln("move right: down")
            } else {
                input[right] = '^'
                dbgln("move right")
            }

        case .Left:
            if left < 0 {
                break loop
            } else if input[left] == '\n' {
                break loop
            } else if input[left] == '#' {
                // Move 90° right
                input[up] = '^'
                guard_dir = .Up
                dbgln("move left: up")
            } else {
                input[left] = '^'
                dbgln("move left")
            }
        }

        input[guard_idx] = 'X'

        when VISUALIZE {
            fmt.println(input_str, "Idx:", guard_idx, ", Dir:", guard_dir, ", Obstruction positions:", obstruction_positions, ", Iteration:", iteration)
        }

        guard_steps += 1
    }

    return false
}

part_1 :: proc(input: []u8, input_str: string, line_length: int) -> int {
    guard_dir: Direction
    guard_steps := 0

    loop: for guard_idx := str.index(input_str, "^"); guard_idx != -1; guard_idx = str.index(input_str, "^") {
        when ODIN_DEBUG {
            if libc.getchar() != '\n' {
                continue
            }
        }
        when VISUALIZE {
            time.sleep(1000000) // 0.001s
            libc.system("clear") // gotta love `system`
        }

        up := guard_idx - line_length
        down := guard_idx + line_length
        right := guard_idx + 1
        left := guard_idx - 1

        switch guard_dir {
        case .Up:
            if up < 0 {
                break loop
            } else if input[up] == '#' {
                if input[right] == '.' {
                    guard_steps += 1
                }

                // Move 90° right
                input[right] = '^'
                guard_dir = .Right
                dbgln("move up: right")
            } else {
                if input[up] == '.' {
                    guard_steps += 1
                }

                input[up] = '^'
                dbgln("move up")
            }

        case .Down:
            if down > len(input) {
                break loop
            } else if input[down] == '#' {
                if input[left] == '.' {
                    guard_steps += 1
                }

                // Move 90° right
                input[left] = '^'
                guard_dir = .Left
                dbgln("move down: left")
            } else {
                if input[down] == '.' {
                    guard_steps += 1
                }

                input[down] = '^'
                dbgln("move down")
            }

        case .Right:
            if right > len(input) {
                break loop
            } else if input[right] == '\n' {
                break loop
            } else if input[right] == '#' {
                if input[down] == '.' {
                    guard_steps += 1
                }

                // Move 90° right
                input[down] = '^'
                guard_dir = .Down
                dbgln("move right: down")
            } else {
                if input[right] == '.' {
                    guard_steps += 1
                }

                input[right] = '^'
                dbgln("move right")
            }

        case .Left:
            if left < 0 {
                break loop
            } else if input[left] == '\n' {
                break loop
            } else if input[left] == '#' {
                if input[up] == '.' {
                    guard_steps += 1
                }

                // Move 90° right
                input[up] = '^'
                guard_dir = .Up
                dbgln("move left: up")
            } else {
                if input[left] == '.' {
                    guard_steps += 1
                }

                input[left] = '^'
                dbgln("move left")
            }
        }

        input[guard_idx] = 'X'

        when VISUALIZE {
            fmt.println(input_str, "Idx:", guard_idx, ", Dir:", guard_dir, ", Steps:", guard_steps)
        }
    }

    // Last step off off the map
    guard_steps += 1

    return guard_steps
}

dbgln :: proc(args: ..any, sep: string = " ", flush: bool = true) {
    when ODIN_DEBUG {
        fmt.println(..args, sep = sep, flush = flush)
    }
}

read_input :: proc() -> []u8 {
    input, err := os.read_entire_file_from_filename_or_err("input.txt")
    if err != nil {
        fmt.eprintln("Error reading \"input.txt\":", err)
        os.exit(1)
    }

    return input
}
