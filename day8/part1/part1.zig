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

pub fn parseNodes(allocator: std.mem.Allocator, lines: std.ArrayList([]const u8)) !std.StringHashMap(Node) {
    var nodes = std.StringHashMap(Node).init(allocator);

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

pub fn solve(instructions: []const u8, nodes: std.StringHashMap(Node)) u32 {
    var steps: u32 = 0;
    var current = nodes.get("AAA").?;

    while (true) {
        var chosen_node: []const u8 = "";
        for (instructions) |instruction| {
            if (instruction == 'L') {
                chosen_node = current.left;
                current = nodes.get(current.left).?;
            } else if (instruction == 'R') {
                chosen_node = current.right;
                current = nodes.get(current.right).?;
            }

            steps += 1;

            if (std.mem.eql(u8, chosen_node, "ZZZ")) {
                break;
            }
        }

        if (std.mem.eql(u8, chosen_node, "ZZZ")) {
            break;
        }
    }

    return steps;
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

    const result = solve(instructions, nodes);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{result});
}
