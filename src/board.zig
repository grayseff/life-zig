const std = @import("std");

const NEIGHBOURLIST = [_][2]isize{
    .{-1, -1 },
    .{-1, 0 },
    .{-1, 1 },
    .{0, -1},
    .{0, 1 },
    .{1, -1},
    .{1, 0 },
    .{1, 1 },
};




pub const Board = struct {
    width: usize,
    height: usize,
    current: []bool,
    next: []bool,
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, width: usize, height: usize) !Board {
        const len = width * height;
        const current = try allocator.alloc(bool, len);
        errdefer allocator.free(current);

        const next = try allocator.alloc(bool, len);
        errdefer allocator.free(next);

        for (current) |*el| {
            el.* = false;
        }
        for (next) |*el| {
            el.* = false;
        }
        return Board{
            .width = width,
            .height = height,
            .current = current,
            .next = next,
            .allocator = allocator,
        };
    }
    pub fn deinit(self: *Board) void {
        self.allocator.free(self.current);
        self.allocator.free(self.next);
    }

    // The following are helper functions designed to access the board
    fn index(self: *const Board, x: usize, y: usize) usize {
        return y * self.width + x;
    }

    pub fn flipCell(self: *Board, x: usize, y: usize) void {
        const idx = self.index(x, y);
        self.current[idx] = !self.current[idx];
    }
    pub fn setCell(self: *Board, x: usize, y: usize, alive: bool) void {
        const idx = self.index(x, y);
        self.current[idx] = alive;
    }
    pub fn getCell(self: *const Board, x: usize, y: usize) bool {
        const idx = self.index(x, y);
        return self.current[idx];
    }

// Below are the board operations:

    pub fn countNeighbours(self: *const Board, x: usize, y: usize) u8 {
        var count: u8 = 0;
        for (NEIGHBOURLIST) |offset| {
           const ny = y + offset[0];
           const nx = x + offset[1];
           if (nx < 0 or ny < 0 or nx >= self.width or ny >= self.height){
               continue;
           }
           if (self.getCell(nx, ny) ) {
               count += 1;
           }
        }
        return count;
    }

    pub fn step(self: *Board) void {
        for (0..self.height) |i| {
            for (0..self.width) |j| {
                const alive = self.getCell(j, i );
                const neighbours: u8 = self.countNeighbours(j, i );
                const idx = self.index(j, i);   
                if (alive and (neighbours == 2 or neighbours == 3 )) {
                    self.next[idx] = true;
                } else if (alive) {
                    self.next[idx] = false;
                } else if (neighbours == 3) {
                    self.next[idx] = true;
                } else {
                    self.next[idx] = false;
                }
            }
        }
        const tmp = self.current;
        self.current = self.next;
        self.next = tmp;
    }
};
