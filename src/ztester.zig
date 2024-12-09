//:========================================================================
//: Licensed under the [MIT License](LICENSE).
//:
//: Tested with zig version 0.13.0 on Linux Fedora 39.
//:========================================================================

const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    std.debug.print("\tresult: {}\n", .{add(1, 1)});
}

pub fn add(a: usize, b: usize) usize {
    return a + b;
}

test "ztester.add(5, 5)" {
    try std.testing.expect(add(5, 5) == 10);
}
