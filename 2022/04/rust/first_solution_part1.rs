use std::ops::RangeInclusive;
use nom::{
    bytes::complete::tag,
    character::complete,
    character::complete::newline,
    sequence::separated_pair,
    multi::separated_list1,
    *,
};

fn main() {
    let input = std::fs::read_to_string("../input.txt").unwrap();
    let (_, ranges) = parse_input_lines(&input).unwrap();

    let fully_overlap_count = ranges
        .iter()
        .filter(|(range_a, range_b)| {
            range_a
                .clone()
                .into_iter()
                .all(|num| range_b.contains(&num))
                || range_b
                .clone()
                .into_iter()
                .all(|num| range_a.contains(&num))
        })
        .count();

    println!("Part 1: {}", fully_overlap_count);
}

fn parse_sections(input: &str) -> IResult<&str, RangeInclusive<u32>> {
    let (input, (start, end)) = separated_pair(complete::u32, tag("-"), complete::u32)(input)?;

    Ok((input, start..=end))
}

fn parse_input_lines(input: &str) -> IResult<&str, Vec<(RangeInclusive<u32>, RangeInclusive<u32>)>> {
    let (input, ranges) = separated_list1(newline, separated_pair(parse_sections, tag(","), parse_sections))(input)?;

    Ok((input, ranges))
}
