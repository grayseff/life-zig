const std = @import("std");
const c = @cImport({
    @cInclude("SDL3/SDL.h");
});
const Board = @import("board.zig").Board;

pub const Renderer = struct {
    window: *c.SDL_Window,
    renderer: *c.SDL_Renderer,
    cell_size: c_int,
    width: c_int,
    height: c_int,


    const Error = error{
            WindowCreationFailed,
            RenderCreationFailed,
        };




    pub fn init(
        width: usize,
        height: usize,
        cell_size: i32,
        ) !Renderer {
             const wwidth: c_int = @intCast(width);
            const hheight: c_int = @intCast(height);
            const ccell_size: c_int = @intCast(cell_size);
        
            const window_width = wwidth * ccell_size;
            const window_height = hheight * ccell_size;
            
            const window = c.SDL_CreateWindow("Conway's Game of Life", window_width, window_height, 0);
            if (window == null){
                return Error.WindowCreationFailed;
            }
            const renderer = c.SDL_CreateRenderer(window,null);
            if (renderer == null){
                c.SDL_DestroyWindow(window);
                return Error.RenderCreationFailed;
            }
            return Renderer{
                .window = window.?,
                .renderer = renderer.?,
                .cell_size = ccell_size,
                .width = wwidth,
                .height = hheight,
            };
        
        }


        pub fn deinit(self: *Renderer) void {
            c.SDL_DestroyRenderer(self.renderer);
            c.SDL_DestroyWindow(self.window);
        }

        fn drawCell(self: *Renderer, x:usize, y:usize, alive: bool) void {
            const xi: c_int = @intCast(x);
            const yi: c_int = @intCast(y);

            const rect = c.SDL_FRect{
                .x = @floatFromInt(xi*self.cell_size + 1) ,
                .y = @floatFromInt(yi*self.cell_size + 1) ,
                .w = @floatFromInt(self.cell_size - 2) ,
                .h = @floatFromInt(self.cell_size - 2) ,
            };
            if (alive) {
                _ = c.SDL_SetRenderDrawColor(self.renderer, 80, 220, 120, 255);
            } else {
                _ = c.SDL_SetRenderDrawColor(self.renderer, 40, 40, 40, 255);
            }
            _ = c.SDL_RenderFillRect(self.renderer, &rect);

        }


        pub fn draw(self: *Renderer, board: *Board) void {
            _ = c.SDL_SetRenderDrawColor(self.renderer, 0, 0, 0, 255);
            _ = c.SDL_RenderClear(self.renderer);
            for (0..board.height) |j| {
                for (0..board.width) |i| {
                    self.drawCell(i, j, board.getCell(i,j));
                }
            }

            _ = c.SDL_RenderPresent(self.renderer);

        }
};


