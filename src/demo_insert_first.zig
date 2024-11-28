//:========================================================================
//: Licensed under the [MIT License](LICENSE).
//:
//: Tested with zig version 0.13.0 on Linux Fedora 39.
//:========================================================================

const std = @import("std");
const print = std.debug.print;

const ztester = @import("ztester.zig");

const Node = ztester.Node;
const List = ztester.List;

pub fn main() !void {

    //^ Variables are defined at the end of file, see the `Helpers` section

    print("\n//+=========================================================", .{});
    print("\n//+ Print defaults", .{});
    print("\n//+=========================================================", .{});
    {
        print("\n\n//~ Data -----------------------------------------", .{});

        print("\n\tdat0:\t{*}", .{&dat0});
        print("\n\tdat1:\t{*}", .{&dat1});
        print("\n\tdat2:\t{*}", .{&dat2});
        print("\n\tdat3:\t{*}", .{&dat3});
        print("\n\tdat4:\t{*}", .{&dat4});

        print("\n", .{});
        print("\n\tdat0:\t{}", .{dat0});
        print("\n\tdat1:\t{}", .{dat1});
        print("\n\tdat2:\t{}", .{dat2});
        print("\n\tdat3:\t{}", .{dat3});
        print("\n\tdat4:\t{}", .{dat4});

        print("\n\n//~ Node -----------------------------------------", .{});

        print("\n\tnod0:\t{*}", .{&nod0});
        print("\n\tnod1:\t{*}", .{&nod1});
        print("\n\tnod2:\t{*}", .{&nod2});
        print("\n\tnod3:\t{*}", .{&nod3});
        print("\n\tnod4:\t{*}", .{&nod4});

        print("\n", .{});
        print("\n\tnod0:\t{}", .{nod0});
        print("\n\tnod1:\t{}", .{nod1});
        print("\n\tnod2:\t{}", .{nod2});
        print("\n\tnod3:\t{}", .{nod3});
        print("\n\tnod4:\t{}", .{nod4});

        print("\n\n//~ List -----------------------------------------", .{});

        print("\n\tlist:\t{*}", .{&list});
        print("\n\tlist:\t{}", .{list});
        list.printNode("list", cnt);

        print("\n\n//~ Head -----------------------------------------", .{});

        print("\n\thead:\t{*}", .{list.head});
        print("\n\thead:\t{?}", .{list.head});

        print("\n\n//~ hasNode() ------------------------------------", .{});

        print("\n\thas0:\t{}", .{list.hasNode(&nod0)});
        print("\n\thas1:\t{}", .{list.hasNode(&nod1)});
        print("\n\thas2:\t{}", .{list.hasNode(&nod2)});
        print("\n\thas3:\t{}", .{list.hasNode(&nod3)});
        print("\n\thas4:\t{}", .{list.hasNode(&nod4)});

        print("\n", .{});
    }

    print("\n//+=========================================================", .{});
    print("\n//+ list.init(&nod0);", .{});
    print("\n//+=========================================================", .{});
    {
        printState(.Before);

        list.init(&nod0);

        printState(.After);
    }

    print("\n//+=========================================================", .{});
    print("\n//+ list.insertFirst(&nod0);", .{});
    print("\n//+=========================================================", .{});
    {
        printState(.Before);

        list.insertFirst(&nod0);

        printState(.After);
    }

    print("\n//+=========================================================", .{});
    print("\n//+ list.insertFirst(&nod1);", .{});
    print("\n//+=========================================================", .{});
    {
        printState(.Before);

        list.insertFirst(&nod1);

        printState(.After);
    }

    print("\n//+=========================================================", .{});
    print("\n//+ list.insertFirst(&nod2);", .{});
    print("\n//+=========================================================", .{});
    {
        printState(.Before);

        list.insertFirst(&nod2);

        printState(.After);
    }

    print("\n//+=========================================================", .{});
    print("\n//+ list.insertFirst(&nod3);", .{});
    print("\n//+=========================================================", .{});
    {
        printState(.Before);

        list.insertFirst(&nod3);

        printState(.After);
    }

    print("\n//+=========================================================", .{});
    print("\n//+ list.insertFirst(&nod4);", .{});
    print("\n//+=========================================================", .{});
    {
        printState(.Before);

        list.insertFirst(&nod4);

        printState(.After);
    }

    print("\n//+=========================================================", .{});
    print("\n//+ if `node` exists, do nothing", .{});
    print("\n//+=========================================================", .{});
    {
        printState(.Before);

        list.insertFirst(&nod3);
        list.insertFirst(&nod4);
        list.insertFirst(&nod0);
        list.insertFirst(&nod2);
        list.insertFirst(&nod4);

        printState(.After);
    }
}

//+--------------------------------------------------------------
//+ Helpers
//+--------------------------------------------------------------

var dat0: u16 = 16;
var dat1: i32 = 32;
var dat2: f64 = 64;
var dat3: f32 = 32;
var dat4: f16 = 16;

var nod0 = Node{ .data = &dat0 };
var nod1 = Node{ .data = &dat1 };
var nod2 = Node{ .data = &dat2 };
var nod3 = Node{ .data = &dat3 };
var nod4 = Node{ .data = &dat4 };

var list = List{};

const cnt = 10;

const State = enum {
    Before,
    After,
};

fn printState(state: State) void {
    switch (state) {
        .Before => print("\n\n//~ Before ---------------------------------------", .{}),
        .After => print("\n\n//~ After ----------------------------------------", .{}),
    }

    print("\n\tnod0:\t{*}", .{&nod0});
    print("\n\tnod1:\t{*}", .{&nod1});
    print("\n\tnod2:\t{*}", .{&nod2});
    print("\n\tnod3:\t{*}", .{&nod3});
    print("\n\tnod4:\t{*}", .{&nod4});

    print("\n\n\tlist:\t{*}", .{&list});
    list.printNode("list", cnt);

    print("\n\n\thead:\t{*}", .{list.head});

    print("\n", .{});
    print("\n\thas0:\t{}", .{list.hasNode(&nod0)});
    print("\n\thas1:\t{}", .{list.hasNode(&nod1)});
    print("\n\thas2:\t{}", .{list.hasNode(&nod2)});
    print("\n\thas3:\t{}", .{list.hasNode(&nod3)});
    print("\n\thas4:\t{}", .{list.hasNode(&nod4)});

    print("\n", .{});
}
