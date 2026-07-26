const std = @import("std");
const Engine = @import("engine.zig").Engine;

pub fn main(init: std.process.Init) !void {
    _ = init;

    var engine = try Engine.init(
        std.heap.c_allocator,
        50,
        20,
        20,
    );
    defer engine.deinit();
    engine.run();
}
