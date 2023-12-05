import os
import std/strutils
import std/sequtils
import std/sugar

proc parse_mapping(input: string): seq[(int, int, int)] =
    return input.split("\n")[1 .. ^1].map(part => part.split(" ")).map(part => (
            part[0].parseInt, part[1].parseInt, part[2].parseInt))

proc find_in_mapping(mapping: seq[(int, int, int)], value: int): int =
    for map in mapping:
        if value in map[1] .. map[1] + map[2]:
            return map[0] + (value - map[1])

    return -1

proc map_to_next(mapping: seq[(int, int, int)], value: int): int =
    let destination = find_in_mapping(mapping, value)
    if destination == -1:
        return value
    else:
        return destination

proc map_seed(mappings: seq[seq[(int, int, int)]], seed: int): int =
    result = seed
    for mapping in mappings:
        result = map_to_next(mapping, result)

    return result

let filepath = paramStr(1)
let input = readFile(filepath).split("\n\n")

let seeds = input[0].split(" ")[1 .. ^1].map(seed => seed.parseInt)
let mappings = input[1 .. ^1].map(parse_mapping)

let result = seeds.map(seed => map_seed(mappings, seed)).min

echo result
