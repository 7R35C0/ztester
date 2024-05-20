//!
//! Tested only with zig version 0.12.0 on Linux Fedora 39.
//!

const std = @import("std");
const print = std.debug.print;

pub fn printMessage(message: []const u8) void {
    print("Hello {s}\n", .{message});
}
