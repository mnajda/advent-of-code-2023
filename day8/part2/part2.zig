const std = @import("std");

const Node = struct {
    left: []const u8,
    right: []const u8,
};

pub fn readFile(allocator: std.mem.Allocator, filepath: []u8) ![]u8 {
    const file = try std.fs.cwd().openFile(filepath, .{ .mode = .read_only });
    defer file.close();

    const stat = try file.stat();
    const fileSize = stat.size;

    const contents = try file.reader().readAllAlloc(allocator, fileSize);
    return contents;
}

pub fn parseNodes(allocator: std.mem.Allocator, lines: std.ArrayList([]const u8)) !std.StringArrayHashMap(Node) {
    var nodes = std.StringArrayHashMap(Node).init(allocator);

    for (lines.items) |line| {
        var parts = std.mem.split(u8, line, " = ");
        const node_name = parts.next().?;

        var directions = std.mem.split(u8, parts.next().?, ", ");
        var left = directions.next().?[1..];
        var right = directions.next().?;
        right = right[0 .. right.len - 1];

        try nodes.put(node_name, Node{ .left = left, .right = right });
    }

    return nodes;
}

pub fn solve(allocator: std.mem.Allocator, instructions: []const u8, nodes: std.StringArrayHashMap(Node)) !std.ArrayList(u64) {
    var starting_nodes = std.ArrayList([]const u8).init(allocator);
    defer starting_nodes.deinit();

    for (nodes.keys()) |key| {
        if (std.mem.endsWith(u8, key, "A")) {
            try starting_nodes.append(key);
        }
    }

    var steps = std.ArrayList(u64).init(allocator);

    for (starting_nodes.items) |node| {
        var current_node = nodes.get(node).?;
        var current_steps: u64 = 0;

        while (true) {
            var chosen_node: []const u8 = "";
            for (instructions) |instruction| {
                if (instruction == 'L') {
                    chosen_node = current_node.left;
                    current_node = nodes.get(current_node.left).?;
                } else if (instruction == 'R') {
                    chosen_node = current_node.right;
                    current_node = nodes.get(current_node.right).?;
                }

                current_steps += 1;

                if (std.mem.endsWith(u8, chosen_node, "Z")) {
                    break;
                }
            }

            if (std.mem.endsWith(u8, chosen_node, "Z")) {
                try steps.append(current_steps);
                break;
            }
        }
    }

    return steps;
}

pub fn gcd(lhs: u64, rhs: u64) u64 {
    var a = lhs;
    var b = rhs;
    while (b != 0) {
        var temp = b;
        b = @mod(a, b);
        a = temp;
    }
    return a;
}

pub fn lcm(lhs: u64, rhs: u64) u64 {
    return (lhs * rhs) / gcd(lhs, rhs);
}

pub fn lcm_range(lhs: []u64) u64 {
    var result = lhs[0];
    for (lhs[1..]) |value| {
        result = lcm(result, value);
    }
    return result;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const filepath = args[1];

    const contents = try readFile(allocator, filepath);
    defer allocator.free(contents);

    var lines = std.ArrayList([]const u8).init(allocator);
    defer lines.deinit();
    var readIter = std.mem.tokenizeSequence(u8, contents, "\n");
    const instructions = readIter.next().?;
    while (readIter.next()) |line| {
        try lines.append(line);
    }

    var nodes = try parseNodes(allocator, lines);
    defer nodes.deinit();

    var steps = try solve(allocator, instructions, nodes);
    defer steps.deinit();

    const result = lcm_range(steps.items);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}
