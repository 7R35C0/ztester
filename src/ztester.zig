const std = @import("std");
const maxInteger = std.math.maxInt;
const maxFloat = std.math.floatMax;

pub fn main() void {
    _ = countDigitSwitcher(0);
    _ = countDigitSwitcher(0.0);

    _ = countDigitSwitcher(1_000_000);
    _ = countDigitSwitcher(-1_000_000);

    _ = countDigitSwitcher(1_000_000.0);
    _ = countDigitSwitcher(-1_000_000.0);

    _ = countDigitSwitcher(@as(u32, 0));
    _ = countDigitSwitcher(@as(f32, 0.0));

    _ = countDigitSwitcher(@as(i32, 1_000_000));
    _ = countDigitSwitcher(@as(i32, -1_000_000));

    _ = countDigitSwitcher(@as(f32, 1_000_000.0));
    _ = countDigitSwitcher(@as(f32, -1_000_000.0));

    _ = countDigitSwitcher(@as(f16, 1_000.0));
    _ = countDigitSwitcher(@as(f16, -1_000.0));

    // // compile errors
    // _ = countDigitSwitcher(340_282_366_920_938_463_463_374_607_431_768_211_455_000);
    // _ = countDigitSwitcher(-340_282_366_920_938_463_463_374_607_431_768_211_455_000);
    // _ = countDigitSwitcher(340_282_366_920_938_463_463_374_607_431_768_211_455.0);
    // _ = countDigitSwitcher(-340_282_366_920_938_463_463_374_607_431_768_211_455.0);
    // _ = countDigitSwitcher(@as(u256, 1_000_000));
    // _ = countDigitSwitcher(@as(i256, -1_000_000));
    // _ = countDigitSwitcher(@as(f64, 1_000_000.0));
    // _ = countDigitSwitcher(@as(f128, -1_000_000.0));
    // _ = countDigitSwitcher("1_000_000");
    // _ = countDigitSwitcher(@as([]const u8, "-1_000_000.0"));
}

pub fn countDigitSwitcher(number: anytype) usize {
    const range_number: [40]u128 = .{
        0,
        10,
        100,
        1_000,
        10_000,
        100_000,
        1_000_000,
        10_000_000,
        100_000_000,
        1_000_000_000,
        10_000_000_000,
        100_000_000_000,
        1_000_000_000_000,
        10_000_000_000_000,
        100_000_000_000_000,
        1_000_000_000_000_000,
        10_000_000_000_000_000,
        100_000_000_000_000_000,
        1_000_000_000_000_000_000,
        10_000_000_000_000_000_000,
        100_000_000_000_000_000_000,
        1_000_000_000_000_000_000_000,
        10_000_000_000_000_000_000_000,
        100_000_000_000_000_000_000_000,
        1_000_000_000_000_000_000_000_000,
        10_000_000_000_000_000_000_000_000,
        100_000_000_000_000_000_000_000_000,
        1_000_000_000_000_000_000_000_000_000,
        10_000_000_000_000_000_000_000_000_000,
        100_000_000_000_000_000_000_000_000_000,
        1_000_000_000_000_000_000_000_000_000_000,
        10_000_000_000_000_000_000_000_000_000_000,
        100_000_000_000_000_000_000_000_000_000_000,
        1_000_000_000_000_000_000_000_000_000_000_000,
        10_000_000_000_000_000_000_000_000_000_000_000,
        100_000_000_000_000_000_000_000_000_000_000_000,
        1_000_000_000_000_000_000_000_000_000_000_000_000,
        10_000_000_000_000_000_000_000_000_000_000_000_000,
        100_000_000_000_000_000_000_000_000_000_000_000_000,
        340_282_366_920_938_463_463_374_607_431_768_211_455,
    };

    switch (@typeInfo(@TypeOf(number))) {
        .Int, .ComptimeInt => {
            if (@bitSizeOf(@TypeOf(number)) > @bitSizeOf(u128) or (@bitSizeOf(@TypeOf(number)) == 0 and @abs(number) > maxInteger(u128))) {
                @compileError("unsupported type: " ++ @typeName(@TypeOf(number)) ++ " - countDigitSwitcher() is not implemented for a comptime_int greater than 128 bits");
            }
            for (range_number, 0..) |value, index| {
                if (@abs(number) < value or (@abs(number) == value and index == range_number.len - 1)) return index;
            }
        },
        .Float, .ComptimeFloat => {
            if (@bitSizeOf(@TypeOf(number)) > @bitSizeOf(f32) or (@bitSizeOf(@TypeOf(number)) == 0 and @abs(number) > maxFloat(f32))) {
                @compileError("unsupported type: " ++ @typeName(@TypeOf(number)) ++ " - countDigitSwitcher() is not implemented for a comptime_float greater than 32 bits");
            }

            for (range_number, 0..) |value, index| {
                if (@trunc(@abs(number)) < @as(f32, @floatFromInt(value))) return index;
            }
        },
        else => @compileError("unsupported type: " ++ @typeName(@TypeOf(number)) ++ " - countDigitSwitcher() is not implemented for " ++ @typeName(@TypeOf(number))),
    }

    return 0;

    // return error.UnreachableCode;
    // unreachable;
    // @compileError("unreachable code");
}

//+===========================================================================================+
//+                                          Tests                                            +
//+===========================================================================================+

test "countDigitSwitcher()" {
    const minInteger = std.math.minInt;
    const minFloat = std.math.floatMin;
    const eqlTest = std.testing.expectEqual;

    const result = countDigitSwitcher;

    try eqlTest(1, result(0));
    try eqlTest(1, result(minInteger(u8)));
    try eqlTest(3, result(maxInteger(u8)));
    for (0..3) |index| {
        try eqlTest(index + 1, result(@as(u8, @intCast(std.math.pow(u128, 10, index)))));
    }

    try eqlTest(1, result(0));
    try eqlTest(1, result(minInteger(u16)));
    try eqlTest(5, result(maxInteger(u16)));
    for (0..5) |index| {
        try eqlTest(index + 1, result(@as(u16, @intCast(std.math.pow(u128, 10, index)))));
    }

    try eqlTest(1, result(0));
    try eqlTest(1, result(minInteger(u32)));
    try eqlTest(10, result(maxInteger(u32)));
    for (0..10) |index| {
        try eqlTest(index + 1, result(@as(u32, @intCast(std.math.pow(u128, 10, index)))));
    }

    try eqlTest(1, result(0));
    try eqlTest(1, result(minInteger(u64)));
    try eqlTest(20, result(maxInteger(u64)));
    for (0..20) |index| {
        try eqlTest(index + 1, result(@as(u64, @intCast(std.math.pow(u128, 10, index)))));
    }

    try eqlTest(1, result(0));
    try eqlTest(1, result(minInteger(u128)));
    try eqlTest(39, result(maxInteger(u128)));
    for (0..39) |index| {
        try eqlTest(index + 1, result(@as(u128, @intCast(std.math.pow(u128, 10, index)))));
    }

    try eqlTest(1, result(0));
    try eqlTest(3, result(minInteger(i8)));
    try eqlTest(3, result(maxInteger(i8)));
    for (0..3) |index| {
        try eqlTest(index + 1, result(0 - @as(i8, @intCast(std.math.pow(u128, 10, index)))));
    }
    for (0..3) |index| {
        try eqlTest(index + 1, result(@as(i8, @intCast(std.math.pow(u128, 10, index)))));
    }

    try eqlTest(1, result(0));
    try eqlTest(5, result(minInteger(i16)));
    try eqlTest(5, result(maxInteger(i16)));
    for (0..5) |index| {
        try eqlTest(index + 1, result(0 - @as(i16, @intCast(std.math.pow(u128, 10, index)))));
    }
    for (0..5) |index| {
        try eqlTest(index + 1, result(@as(i16, @intCast(std.math.pow(u128, 10, index)))));
    }

    try eqlTest(1, result(0));
    try eqlTest(10, result(minInteger(i32)));
    try eqlTest(10, result(maxInteger(i32)));
    for (0..10) |index| {
        try eqlTest(index + 1, result(0 - @as(i32, @intCast(std.math.pow(u128, 10, index)))));
    }
    for (0..10) |index| {
        try eqlTest(index + 1, result(@as(i32, @intCast(std.math.pow(u128, 10, index)))));
    }

    try eqlTest(1, result(0));
    try eqlTest(19, result(minInteger(i64)));
    try eqlTest(19, result(maxInteger(i64)));
    for (0..19) |index| {
        try eqlTest(index + 1, result(0 - @as(i64, @intCast(std.math.pow(u128, 10, index)))));
    }
    for (0..19) |index| {
        try eqlTest(index + 1, result(@as(i64, @intCast(std.math.pow(u128, 10, index)))));
    }

    try eqlTest(1, result(0));
    try eqlTest(39, result(minInteger(i128)));
    try eqlTest(39, result(maxInteger(i128)));
    for (0..39) |index| {
        try eqlTest(index + 1, result(0 - @as(i128, @intCast(std.math.pow(u128, 10, index)))));
    }
    for (0..39) |index| {
        try eqlTest(index + 1, result(@as(i128, @intCast(std.math.pow(u128, 10, index)))));
    }

    try eqlTest(1, result(0.0));
    try eqlTest(1, result(minFloat(f16)));
    try eqlTest(1, result(0.0 - minFloat(f16)));
    try eqlTest(5, result(maxFloat(f16)));
    try eqlTest(5, result(0.0 - maxFloat(f16)));
    for (0..5) |index| {
        try eqlTest(index + 1, result(0.0 - @as(f16, @floatFromInt(std.math.pow(u128, 10, index)))));
    }
    for (0..5) |index| {
        try eqlTest(index + 1, result(@as(f16, @floatFromInt(std.math.pow(u128, 10, index)))));
    }

    try eqlTest(1, result(0.0));
    try eqlTest(1, result(minFloat(f32)));
    try eqlTest(1, result(0.0 - minFloat(f32)));
    try eqlTest(39, result(maxFloat(f32)));
    try eqlTest(39, result(0.0 - maxFloat(f32)));
    for (0..39) |index| {
        try eqlTest(index + 1, result(0.0 - @as(f32, @floatFromInt(std.math.pow(u128, 10, index)))));
    }
    for (0..39) |index| {
        try eqlTest(index + 1, result(@as(f32, @floatFromInt(std.math.pow(u128, 10, index)))));
    }
}

// for other architectures add a specific case
test "countDigitSwitcher() - 32/64 bits usize" {
    const builtin = @import("builtin");
    const minInteger = std.math.minInt;
    const eqlTest = std.testing.expectEqual;

    const result = countDigitSwitcher;

    switch (builtin.target.ptrBitWidth()) {
        32 => {
            try eqlTest(1, result(0));
            try eqlTest(1, result(minInteger(usize)));
            try eqlTest(10, result(maxInteger(usize)));
            for (0..10) |index| {
                try eqlTest(index + 1, result(@as(usize, @intCast(std.math.pow(u128, 10, index)))));
            }

            try eqlTest(result(0), result(0));
            try eqlTest(result(minInteger(u32)), result(minInteger(usize)));
            try eqlTest(result(maxInteger(u32)), result(maxInteger(usize)));
            for (0..10) |index| {
                try eqlTest(result(@as(u32, @intCast(std.math.pow(u128, 10, index)))), result(@as(usize, @intCast(std.math.pow(u128, 10, index)))));
            }
        },
        64 => {
            try eqlTest(1, result(0));
            try eqlTest(1, result(minInteger(usize)));
            try eqlTest(20, result(maxInteger(usize)));
            for (0..20) |index| {
                try eqlTest(index + 1, result(@as(usize, @intCast(std.math.pow(u128, 10, index)))));
            }

            try eqlTest(result(0), result(0));
            try eqlTest(result(minInteger(u64)), result(minInteger(usize)));
            try eqlTest(result(maxInteger(u64)), result(maxInteger(usize)));
            for (0..20) |index| {
                try eqlTest(result(@as(u64, @intCast(std.math.pow(u128, 10, index)))), result(@as(usize, @intCast(std.math.pow(u128, 10, index)))));
            }
        },
        else => return error.SkipZigTest,
    }
}

// for other architectures add a specific case
test "countDigitSwitcher() - 32/64 bits isize" {
    const builtin = @import("builtin");
    const minInteger = std.math.minInt;
    const eqlTest = std.testing.expectEqual;

    const result = countDigitSwitcher;

    switch (builtin.target.ptrBitWidth()) {
        32 => {
            try eqlTest(1, result(0));
            try eqlTest(10, result(minInteger(isize)));
            try eqlTest(10, result(maxInteger(isize)));
            for (0..10) |index| {
                try eqlTest(index + 1, result(0 - @as(isize, @intCast(std.math.pow(u128, 10, index)))));
            }
            for (0..10) |index| {
                try eqlTest(index + 1, result(@as(isize, @intCast(std.math.pow(u128, 10, index)))));
            }

            try eqlTest(result(0), result(0));
            try eqlTest(result(minInteger(i32)), result(minInteger(isize)));
            try eqlTest(result(maxInteger(i32)), result(maxInteger(isize)));
            for (0..10) |index| {
                try eqlTest(result(0 - @as(i32, @intCast(std.math.pow(u128, 10, index)))), result(0 - @as(isize, @intCast(std.math.pow(u128, 10, index)))));
            }
            for (0..10) |index| {
                try eqlTest(result(@as(i32, @intCast(std.math.pow(u128, 10, index)))), result(@as(isize, @intCast(std.math.pow(u128, 10, index)))));
            }
        },
        64 => {
            try eqlTest(1, result(0));
            try eqlTest(19, result(minInteger(isize)));
            try eqlTest(19, result(maxInteger(isize)));
            for (0..19) |index| {
                try eqlTest(index + 1, result(0 - @as(isize, @intCast(std.math.pow(u128, 10, index)))));
            }
            for (0..19) |index| {
                try eqlTest(index + 1, result(@as(isize, @intCast(std.math.pow(u128, 10, index)))));
            }

            try eqlTest(result(0), result(0));
            try eqlTest(result(minInteger(i64)), result(minInteger(isize)));
            try eqlTest(result(maxInteger(i64)), result(maxInteger(isize)));
            for (0..19) |index| {
                try eqlTest(result(0 - @as(i64, @intCast(std.math.pow(u128, 10, index)))), result(0 - @as(isize, @intCast(std.math.pow(u128, 10, index)))));
            }
            for (0..19) |index| {
                try eqlTest(result(@as(i64, @intCast(std.math.pow(u128, 10, index)))), result(@as(isize, @intCast(std.math.pow(u128, 10, index)))));
            }
        },
        else => return error.SkipZigTest,
    }
}
