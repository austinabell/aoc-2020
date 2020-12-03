const std = @import("std");
const input = @embedFile("input.txt");

pub fn main() !void {
    // var alloc = std.heap.GeneralPurposeAllocator(.{}){};
    // const input = try std.fs.cwd().readFileAlloc(&alloc.allocator, "input.txt", std.math.maxInt(usize));
    var lines = std.mem.tokenize(input, "\n");

    const increments = [5][2]usize{
        [_]usize{ 1, 1 },
        [_]usize{ 3, 1 },
        [_]usize{ 5, 1 },
        [_]usize{ 7, 1 },
        [_]usize{ 1, 2 },
    };
    var x: [5]usize = .{ 0, 0, 0, 0, 0 };
    var num_trees: [5]usize = .{ 0, 0, 0, 0, 0 };

    var y: usize = 0;
    while (lines.next()) |line| {
        for (num_trees) |*value, i| {
            if (y % increments[i][1] != 0) {
                continue;
            }
            while (x[i] >= line.len) {
                x[i] -= line.len;
            }

            if (line[x[i]] == '#') {
                value.* += 1;
            }

            x[i] += increments[i][0];
        }
        y += 1;
    }

    var product: usize = 1;
    for (num_trees) |sum, i| {
        // std.debug.print("sum of r {} d {} = {}\n", .{ increments[i][0], increments[i][1], sum });
        product *= sum;
    }
    std.debug.print("{}\n", .{product});
}
