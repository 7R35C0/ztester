const std = @import("std");
const print = std.debug.print;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const root_source_file = b.path("src/main.zig");

    const ztester_dep = b.dependency(
        "ztester",
        .{
            .target = target,
            .optimize = optimize,
        },
    );
    const ztester_mod = ztester_dep.module("ztester");

    const exe = b.addExecutable(.{
        .name = "zimport",
        .target = target,
        .optimize = optimize,
        .root_source_file = root_source_file,
    });

    exe.root_module.addImport("ztester", ztester_mod);

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
