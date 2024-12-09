//:========================================================================
//: Licensed under the [MIT License](LICENSE).
//:
//: Tested with zig version 0.13.0 on Linux Fedora 39.
//:========================================================================

const std = @import("std");

const ztester = @import("ztester");

pub fn main() !void {
    std.debug.print("\tresult: {}\n", .{ztester.add(1, 1)});
}

test "ztester.add(1, 1)" {
    try std.testing.expect(ztester.add(1, 1) == 2);
}

test "ztester.add(2, 2)" {
    try std.testing.expect(ztester.add(2, 2) == 4);
}
