//:========================================================================
//: Licensed under the [MIT License](LICENSE).
//:
//: Tested with zig version 0.13.0 on Linux Fedora 39.
//:
//: Sources: WIP
//:========================================================================

//! These functions make no assertions about the data types stored in list.
//!
//! This intrusive linked list does not store data in the list, there is no
//! memory for the actual data in list.
//!
//! Some important aspects about implementation:
//! * a clear separation is made between data and nodes (lists)
//! * for a node (list) the actual data type does not matter
//! * the same data can be part of different nodes (lists)
//! * the list itself is a double circular linked list

const std = @import("std");
const print = std.debug.print;

pub const Node = struct {
    data: *anyopaque,
    prev: ?*Node = null,
    next: ?*Node = null,
};

pub const List = struct {
    head: ?*Node = null,

    /// Initializes an empty list.
    ///
    /// The resulting list is a double circular linked list.
    //^ WIP: without `init`, some functions may return bad results or errors.
    pub fn init(self: *List, node: *Node) void {
        if (self.head == null) {
            node.prev = node;
            node.next = node;

            self.head = node;
        }
    }

    /// Insert the `node` in list, `after` another node.
    ///
    /// Links `after` to `node` and `node` to `after.next`.
    /// If `node` is equal with `after`, do nothing.
    /// If `node` exists or `after` does not exist in list, do nothing.
    /// For an empty list, initialize the list with `after` node.
    pub fn insertAfter(self: *List, node: *Node, after: *Node) void {
        if (node == after) return;

        if (self.head == null) self.init(after);

        if (self.hasNode(node)) return;

        var curr = self.head.?;

        while (curr != after) : (curr = curr.next.?) {}

        node.next = curr.next;
        node.prev = curr;

        node.next.?.prev = node;
        node.prev.?.next = node;
    }

    /// Insert the `node` in list, `before` another node.
    ///
    /// Links `before.prev` to `node` and `node` to `before`.
    /// If `node` is equal with `before`, do nothing.
    /// If `node` exists or `before` does not exist in list, do nothing.
    /// For an empty list, initialize the list with `before` node.
    //^ the nodes are inserted counterclockwise, keep this in mind when
    //^ viewing printed nodes
    pub fn insertBefore(self: *List, node: *Node, before: *Node) void {
        if (node == before) return;

        if (self.head == null) self.init(before);

        if (self.find(before.prev.?)) |prev| {
            self.insertAfter(node, prev);
        }
    }

    /// Insert the `node` at first position in list.
    ///
    /// Links `list.head.prev` to `node` and `node` to `list.head`.
    /// The `node` will become the new `list.head`, this change will
    /// invalidate the list head pointer.
    /// For an empty list, initialize the list with `node`.
    pub fn insertFirst(self: *List, node: *Node) void {
        if (self.head == null) {
            self.init(node);

            return;
        }

        self.insertAfter(node, self.head.?.prev.?);

        self.head = node;
    }

    /// Insert the `node` at last position in list.
    ///
    /// Links `list.head.prev` to `node` and `node` to `list.head`.
    /// For an empty list, initialize the list with `node`.
    pub fn insertLast(self: *List, node: *Node) void {
        if (self.head == null) {
            self.init(node);

            return;
        }

        self.insertAfter(node, self.head.?.prev.?);
    }

    //: make a head shift function to a given node from list
    //: even a temporary change to the head can speed up code for multiple
    //: operations in the vicinity of that node, in very long lists

    /// Remove the `node` from list.
    ///
    /// The removed node will become a single unlinked node, reset the node.
    /// If `node` does not exist in list, do nothing.
    /// If `node` is equal with `list.head`, `list.head.next` will become
    /// the `list.head`, this change will invalidate the list head pointer.
    /// For a single node list, results an empty list.
    pub fn remove(self: *List, node: *Node) void {
        if (self.head == null) return;

        //^ a list with a single node
        if (self.head == node and self.head.?.prev == node and self.head.?.next == node) {
            self.head = null;

            node.prev = null;
            node.next = null;

            return;
        }

        if (self.head == node) {
            self.head = self.head.?.next;
        }

        if (self.find(node)) |curr| {
            curr.next.?.prev = curr.prev.?;
            curr.prev.?.next = curr.next.?;

            node.prev = null;
            node.next = null;
        }
    }

    /// Return the `node`, if `node` is in list, otherwise `null`.
    ///
    /// Search for `node` both clockwise and counterclockwise in list, to
    /// ensure that `node` has been correctly inserted or removed from list.
    /// Does not modify the list or nodes.
    /// For a simple assertion, use `hasNode`.
    pub fn find(self: *List, node: *Node) ?*Node {
        if (self.head == null) return null;

        var curr = self.head.?;

        while (curr.next.? != self.head.? and curr != node) : (curr = curr.next.?) {}

        if (curr == node) {
            //? a way to avoid this reset and while loop to speed up code
            //? for a large list
            //: redo the tests for `curr`, last time without optionals, it
            //: was a failure
            curr = self.head.?;

            while (curr.prev.? != self.head.? and curr != node) : (curr = curr.prev.?) {}

            if (curr == node) return curr;
        }

        return null;
    }

    /// Assert the `node` status in list.
    ///
    /// Checks if the `node` exists in both list cycles, clockwise and
    /// counterclockwise, to ensure that `node` has been correctly inserted
    /// or removed from list.
    /// See also `find`, which returns the `node` if exists, otherwise `null`.
    pub fn hasNode(self: *List, node: *Node) bool {
        if (self.find(node)) |_| return true;

        return false;
    }

    /// Print the list node pointers.
    ///
    /// The `count` parameter restricts the print range of nodes in list.
    /// Stops after list cycle ends or if count ends, whichever comes first.
    pub fn printNode(self: *List, name: []const u8, count: usize) void {
        if (self.head == null) {
            print("\n\n\t{s}.node: list head == null, list is empty", .{name});

            return;
        }

        if (count == 0) {
            print("\n\n\t{s}.node: parameter count == 0, nothing to print", .{name});

            return;
        }

        var leng = count - 1;
        var curr = self.head.?;

        print("\n\n\t{s}.node:  {*:>}", .{ name, curr });

        while (curr.next.? != self.head.? and leng != 0) : (curr = curr.next.?) {
            print("\n\t\t{s:>26}", .{@as(*f16, @alignCast(@ptrCast(curr.next)))});

            leng -= 1;
        }
    }
};

// pub fn printData(self: *List, name: []const u8, count: usize) void {
//     if (count != 0) {
//         var leng = count - 1;
//         var curr = &self.head;

//         print("\n\t{s}.data.*:\t{*:>}\n", .{ name, curr.data });

//         while (curr != curr.next and leng != 0) : (curr = curr.next) {
//             print("\t\t\t\t\t{s:>26}\n", .{@as(*f16, @alignCast(@ptrCast(curr.data)))});

//             leng -= 1;
//         }
//     } else {
//         print("{s}: count == 0, nothing to print", .{name});
//     }

//     print("\n", .{});
// }

// pub fn insertBetween(self: *List, node: *Node, after: *Node, before: *Node) void {
//     var curr = &self.head;

//     while (curr.prev != after) : (curr = curr.prev) {}

//     if (curr == before) {
//         node.prev = after;
//         node.next = curr;

//         curr.prev = node;
//         after.next = node;
//     }
// }
