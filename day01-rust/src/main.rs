use std::num::ParseIntError;

fn get_two_sum(values: &[u64], other: Option<u64>) -> Option<u64> {
    let mut li = 0;
    let mut ri = values.len() - 1;

    while ri > li {
        let left = values[li];
        let right = values[ri];
        match left + right + other.unwrap_or_default() {
            0..=2019 => li += 1,
            2020 => {
                if let Some(val) = other {
                    return Some(left * right * val);
                } else {
                    return Some(left * right);
                }
            }
            _ => ri -= 1,
        }
    }

    None
}

fn sum_2020_two_values(input: &str) -> Result<u64, String> {
    let mut values: Vec<u64> = input
        .lines()
        .map(|l| l.parse())
        .collect::<Result<_, ParseIntError>>()
        .map_err(|e| e.to_string())?;

    // Sort to iterate both ends of the vector toward the center
    values.sort_unstable();

    Ok(get_two_sum(&values, None).ok_or("No two values in the string sum to 2020")?)
}

fn sum_2020_three_values(input: &str) -> Result<u64, String> {
    let mut values: Vec<u64> = input
        .lines()
        .map(|l| l.parse())
        .collect::<Result<_, ParseIntError>>()
        .map_err(|e| e.to_string())?;

    // Sort to iterate both ends of the vector toward the center
    values.sort_unstable();

    let mut ri = values.len() - 1;

    while ri > 2 {
        if let Some(val) = get_two_sum(&values[..ri], Some(values[ri])) {
            return Ok(val);
        }
        ri -= 1;
    }

    Err("No three values in the string sum to 2020".to_string())
}

fn main() {
    let val = sum_2020_two_values(include_str!("../input.txt")).unwrap();
    println!("two: {}", val);
    let val = sum_2020_three_values(include_str!("../input.txt")).unwrap();
    println!("three: {}", val);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn day01test() {
        let input = "1721\n979\n366\n299\n675\n1456";
        assert_eq!(sum_2020_two_values(input).unwrap(), 514579);
    }
    #[test]
    fn day01testp2() {
        let input = "1721\n979\n366\n299\n675\n1456";
        assert_eq!(sum_2020_three_values(input).unwrap(), 241861950);
    }
}
