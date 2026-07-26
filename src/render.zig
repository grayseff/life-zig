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


        pub fn draw(self: *Renderer) void {
            _ = c.SDL_SetRenderDrawColor(self.renderer, 0, 0, 0, 255);
            _ = c.SDL_RenderClear(self.renderer);
            _ = c.SDL_RenderPresent(self.renderer);

        }
};


