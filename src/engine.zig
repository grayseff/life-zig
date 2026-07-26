const std = @import("std");
const c = @cImport({
    @cInclude("SDL3/SDL.h");
});
const Board = @import("board.zig").Board;
const Renderer = @import("render.zig").Renderer;

pub const Engine = struct {
    board: Board,
    renderer: Renderer,
    simulating: bool,
    last_step: u64,
    step_delay_ms: u64,

    pub fn init(allocator: std.mem.Allocator, width: usize, height: usize, cell_size: i32) !Engine {
        var board = try Board.init(allocator, width, height);
        errdefer board.deinit();
        var renderer = try Renderer.init(width, height, cell_size);
        errdefer renderer.deinit();
        return Engine{
            .board = board,
            .renderer = renderer,
            .simulating = false,
            .last_step = c.SDL_GetTicks(),
            .step_delay_ms = 300,
        };
    }
    pub fn deinit(self: *Engine) void {
        self.renderer.deinit();
        self.board.deinit();
    }
    // fn update(self: *Engine) void {

    // }
    fn mouseToBoard(self: *Engine, mouse_x: f32, mouse_y: f32) ?struct { x: usize, y: usize } {
        const cell_size = @as(f32, @floatFromInt(self.renderer.cell_size));
        const board_x = @as(usize, @intFromFloat(mouse_x / cell_size));
        const board_y = @as(usize, @intFromFloat(mouse_y / cell_size));

        if (board_x < self.board.width and board_y < self.board.height) {
            return .{
                .x = @intCast(board_x),
                .y = @intCast(board_y),
            };
        } else {
            return null;
        }
    }
    fn update(self: *Engine) void {
        if (!self.simulating) return;
        const now = c.SDL_GetTicks();
        if (now - self.last_step >= self.step_delay_ms) {
            self.board.step();
            self.last_step = now;
        }
    }

    pub fn run(self: *Engine) void {
        // c.SDL_Delay(3000);
        var running = true;

        while (running) {
            //events
            var event: c.SDL_Event = undefined;
            while (c.SDL_PollEvent(&event)) {
                //handle event
                switch (event.type) {
                    c.SDL_EVENT_QUIT => running = false,
                    c.SDL_EVENT_KEY_DOWN => {
                        if (event.key.key == c.SDLK_SPACE) {
                            // self.board.step();
                            self.simulating = !self.simulating;
                        } else if (event.key.key == c.SDLK_C) {
                            self.board.clearBoard();
                        }
                    },
                    c.SDL_EVENT_MOUSE_BUTTON_DOWN => {
                        const mouse_x = event.button.x;
                        const mouse_y = event.button.y;
                        if (self.mouseToBoard(mouse_x, mouse_y)) |pos| {
                            self.board.flipCell(pos.x, pos.y);
                        }
                    },
                    else => {},
                }
            }
            //draw
            self.update();
            self.renderer.draw(&self.board);
        }
    }
};
