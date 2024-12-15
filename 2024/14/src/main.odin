package main

import "core:fmt"
import "core:os"
import "core:time"
import "core:c/libc"
import "core:slice"
import "core:bytes"
import "core:strconv"
import str "core:strings"

Robot :: struct {
    position: [2]int,
    velocity: [2]int,
}

VISUALIZE :: #config(VISUALIZE, false) || ODIN_DEBUG

main :: proc() {
    input := read_input()
    input_str := cast(string)input

    fmt.println("Part 1: The Safety Factor is: ", part_1(input_str))
    fmt.println("Part 2: Click through it yourself and see:")
    part_2(input_str)
}

part_2 :: proc(input_str: string) {
    seconds :: 9999999999999
    simulate_robots(input_str, seconds, true)
}

part_1 :: proc(input_str: string) -> uint {
    seconds :: 100
    return simulate_robots(input_str, seconds)
}

simulate_robots :: proc(input_str: string, seconds: uint, is_part_2: bool = false) -> uint {
    robots := parse_robots(input_str)
    defer delete(robots)

    space: [2]int : {101, 103}

    when ODIN_DEBUG {
        fmt.println(space)
    }
    for s in 0..<seconds {
        if ODIN_DEBUG {
            if libc.getchar() != '\n' {
                continue
            }
        }
        if VISUALIZE || is_part_2 {
            if VISUALIZE && !is_part_2 {
                time.sleep(500000000) // 0.5s
            }
            libc.system("clear") // gotta love `system`

            fmt.println("After", s, "seconds:")
            draw_space(space, robots[:], is_part_2)
        }

        for &robot in robots {
            new_pos: [2]int

            new_pos = robot.velocity - (space - robot.position)
            if new_pos.x < 0 {
                if abs(new_pos.x) > space.x {
                    new_pos.x = space.x * 2 + new_pos.x
                } else {
                    new_pos.x = space.x + new_pos.x
                }
            }
            if new_pos.y < 0 {
                if abs(new_pos.y) > space.y {
                    new_pos.y = space.y * 2 + new_pos.y
                } else {
                    new_pos.y = space.y + new_pos.y
                }
            }

            robot.position = new_pos
        }
    }

    if VISUALIZE || is_part_2 {
        fmt.println("\nAfter", seconds, "seconds:")
        draw_space(space, robots[:], is_part_2)
    }

    fmt.print("\nEnd Result:")
    draw_space(space, robots[:])
    when ODIN_DEBUG {
        fmt.println(robots)
    }

    return calculate_safety_factor(space, robots[:])

}

calculate_safety_factor :: proc(space: [2]int, robots: []Robot) -> uint {
    // 0 1
    // 2 3
    quadrant_robot_count: [4]uint

    for robot in robots {
        switch {
        // Left
        case robot.position.x < space.x / 2:
            switch {
            // Top Left
            case robot.position.y < space.y / 2:
                quadrant_robot_count[0] += 1

            // Bottom Left
            case robot.position.y > space.y / 2:
                quadrant_robot_count[2] += 1
            }

        // Right
        case robot.position.x > space.x / 2:
            switch {
            // Top Right
            case robot.position.y < space.y / 2:
                quadrant_robot_count[1] += 1

            // Bottom Right
            case robot.position.y > space.y / 2:
                quadrant_robot_count[3] += 1
            }
        }
    }

    return quadrant_robot_count[0] * quadrant_robot_count[1] * quadrant_robot_count[2] * quadrant_robot_count[3]
}

draw_space :: proc(space: [2]int, robots: []Robot, is_part_2: bool = false) {
    buffer_len := space.x * space.y + space.y
    buffer := make([dynamic]u8, buffer_len)
    slice.fill(buffer[:], '.')

    for robot in robots {
        position := robot.position.y * space.x + robot.position.x + robot.position.y + 1
        if is_digit(cast(rune)buffer[position]) {
            buffer[position] = buffer[position] + 1
        } else {
            buffer[position] = '1'
        }
    }

    for idx in 0..<buffer_len {
        if idx % (space.x + 1) == 0 {
            buffer[idx] = '\n'
        }
    }

    b: bytes.Buffer
    bytes.buffer_init(&b, buffer[:])
    space_str := bytes.buffer_to_string(&b)

    if is_part_2 {
        // Found Tree Easter Egg
        if str.contains(space_str, "11111111") {
            fmt.println(space_str)
            time.sleep(10000000000) // 10s
            return
        }
    } else {
        fmt.println(space_str)
    }
}

parse_robots :: proc(input_str: string) -> (robots: [dynamic]Robot) {
    lines := str.split_lines(input_str)
    lines = lines[:len(lines)-1]

    for line in lines {
        robot: Robot

        split := str.split(line, " ")
        pos_str, vel_str := split[0][2:], split[1][2:]

        robot.position = get_x_y(pos_str)
        robot.velocity = get_x_y(vel_str)

        append(&robots, robot)
    }

    return
}

get_x_y :: proc(string: string) -> [2]int {
    split := str.split(string, ",")

    x, _ := strconv.parse_int(split[0])
    y, _ := strconv.parse_int(split[1])

    return { x, y }
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
