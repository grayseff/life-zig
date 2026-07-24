const std = @import("std");
const c = @cImport({
    @cInclude("SDL3/SDL.h"); 
});
const Board = @import("board.zig").Board;
const Renderer = @import("render.zig").Renderer;



pub const Engine = struct {
    board: Board,
    renderer: Renderer,

    pub fn init(allocator: std.mem.Allocator, width:usize, height:usize, cell_size:i32 ) !Engine {
        var board = try Board.init(allocator, width, height);
        errdefer board.deinit();
        var renderer = try Renderer.init(width, height, cell_size);
        errdefer renderer.deinit(); 
        return Engine{
            .board = board,
            .renderer = renderer,
        };
    }
    pub fn deinit(self: *Engine) void {
        self.renderer.deinit();
        self.board.deinit();
    }
    pub fn run(self: *Engine) void {
        self.renderer.draw();
        c.SDL_Delay(3000);
    }
};
