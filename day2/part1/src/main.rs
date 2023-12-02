use std::env;
use std::fs;

type Colors = (i32, i32, i32);

fn parse_cube(set: Vec<&str>) -> Colors {
    let mut cubes = (0, 0, 0);

    for cube in set {
        let (amount, color) = cube.split_once(' ').unwrap();
        match color {
            "red" => cubes.0 = amount.parse::<i32>().unwrap(),
            "green" => cubes.1 = amount.parse::<i32>().unwrap(),
            "blue" => cubes.2 = amount.parse::<i32>().unwrap(),
            _ => unreachable!(),
        }
    }

    cubes
}

fn parse_game(game: &str) -> Vec<Colors> {
    game.split("; ")
        .map(|set| parse_cube(set.split(", ").collect::<Vec<_>>()))
        .collect()
}

fn load_file(path: &String) -> Vec<(i32, Vec<Colors>)> {
    let contents = fs::read_to_string(path).expect("Error reading file");
    contents
        .split("\n")
        .map(|row| row.split(": ").collect::<Vec<_>>())
        .map(|row| {
            (
                row[0]
                    .split(" ")
                    .into_iter()
                    .last()
                    .unwrap()
                    .parse::<i32>()
                    .unwrap(),
                parse_game(row[1]),
            )
        })
        .collect()
}

fn solve(input: Vec<(i32, Vec<Colors>)>) -> i32 {
    input.into_iter().fold(0, |acc, game| {
        let (id, cubes) = game;
        let is_valid = cubes.into_iter().all(|cube| {
            if cube.0 > 12 || cube.1 > 13 || cube.2 > 14 {
                return false;
            }
            true
        });

        if is_valid {
            acc + id
        } else {
            acc
        }
    })
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        println!("No file provided");
        return;
    }

    let input = load_file(&args[1]);
    let result = solve(input);
    println!("{}", result);
}
