const std = @import("std");
const config = @import("config.zig");
const Graphics = @import("graphics_core.zig").Graphics;

pub const PbmSaver = struct {
    // Saves the graphics buffer to a PBM file.
    // P4 format:
    // P4
    // <width> <height>
    // <raw data, 1 bit per pixel, MSB first, tightly packed>
    pub fn saveToFile(g: *const Graphics, filename: []const u8) !void {
        var file = try std.fs.cwd().createFile(filename, .{ .read = false });
        defer file.close();

        const writer = file.writer();

        // Write PBM header
        try writer.print("P4\n{d} {d}\n", .{ config.screen_width, config.screen_height });

        // Write raw pixel data
        // The frame_buffer in Graphics is already in the correct format (1 bit per pixel, packed)
        // Assuming Color.Black = 1, Color.White = 0 in the buffer for PBM.
        // If your e-ink uses inverted logic (1=white, 0=black), you'll need to invert bits here
        // or when sending to the e-ink. Our current setPixel with Black=1, White=0 is PBM-friendly.
        try writer.writeAll(g.getFrameBuffer());
    }
};
