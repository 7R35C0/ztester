//:========================================================================
//: Licensed under the [MIT License](LICENSE).
//:
//: Tested with zig version 0.13.0 on Linux Fedora 39.
//:========================================================================

const std = @import("std");
const print = std.debug.print;

pub fn main() void {
    print("ztezter works!\n", .{});
}

//+========================================================================
//+ Tests
//+========================================================================

const expect = std.testing.expect;

//^--------------------------------------------------------------
//^ Just a dummy test
//^--------------------------------------------------------------

test "ztester() - dummy" {

    //+ Test dummy.
    {
        try expect(true);
    }
}

//^--------------------------------------------------------------
//^ Above imports
//^--------------------------------------------------------------

//+ Test all above imports.
test "algore" {
    std.testing.refAllDecls(@This());
}
