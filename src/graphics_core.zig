const std = @import("std");
const config = @import("config.zig");
const SimpleFont = @import("simple_font.zig").SimpleFont;

pub const Graphics = struct {
    frame_buffer: [config.frame_buffer_size]u8,

    // Initializes a new Graphics instance with a white canvas.
    pub fn init() Graphics {
        var self = Graphics{
            .frame_buffer = undefined,
        };
        self.clear(config.Color.White);
        return self;
    }

    // Clears the entire frame buffer to the specified color.
    pub fn clear(self: *Graphics, color: config.Color) void {
        const fill_byte: u8 = switch (color) {
            .White => 0x00, // For e-ink, white is often all bits set (depends on display)
            .Black => 0xFF, // All bits black
        };
        @memset(&self.frame_buffer, fill_byte);
    }

    // Sets a single pixel in the frame buffer.
    // (0,0) is top-left.
    // Note: PBM P4 format usually has MSB first. This implementation assumes MSB first.
    // A '1' bit means black, '0' means white for PBM.
    pub fn setPixel(self: *Graphics, x: u16, y: u16, color: config.Color) void {
        if (x >= config.screen_width or y >= config.screen_height) {
            return; // Out of bounds
        }

        const byte_index = (y * config.screen_width + x) / 8;
        const bit_offset = 7 - (x % 8); // MSB first: bit 7 is leftmost pixel in byte

        if (byte_index >= config.frame_buffer_size) return; // Should not happen if x,y are in bounds

        switch (color) {
            .Black => self.frame_buffer[byte_index] |= (@as(u8, 1) << @as(u3, @intCast(bit_offset))),
            .White => self.frame_buffer[byte_index] &= ~(@as(u8, 1) << @as(u3, @intCast(bit_offset))),
        }
    }

    // Draws a character onto the frame buffer.
    pub fn drawChar(
        self: *Graphics,
        x_start: i16,
        y_start: i16,
        char_code: u8,
        font: type, // Pass the font type, e.g., SimpleFont
        color: config.Color,
    ) u8 {
        const char_def_opt = font.getChar(char_code);
        if (char_def_opt == null) {
            return 0; // Character not in font, advance 0 pixels
        }
        const char_def = char_def_opt.?;

        // Draw the character
        for (char_def.data, 0..) |col_data, char_x| {
            if (x_start + @as(i16, @intCast(char_x)) >= config.screen_width) continue; // Don't draw past screen width

            for (0..char_def.height) |char_y| {
                if (y_start + @as(i16, @intCast(char_y)) >= config.screen_height) continue; // Don't draw past screen height
                if (x_start + @as(i16, @intCast(char_x)) < 0 or y_start + @as(i16, @intCast(char_y)) < 0) continue; // Don't draw off-screen (top/left)

                // Check if the pixel in the font character is set
                if ((col_data >> @as(u3, @intCast(char_y))) & 1 != 0) {
                    self.setPixel(
                        @as(u16, @intCast(x_start + @as(i16, @intCast(char_x)))),
                        @as(u16, @intCast(y_start + @as(i16, @intCast(char_y)))),
                        color,
                    );
                }
            }
        }
        return char_def.width; // Return the width of the character drawn
    }

    // Draws a string onto the frame buffer.
    // Returns the x-coordinate after the last character.
    pub fn drawString(
        self: *Graphics,
        x_start: i16,
        y_start: i16,
        text: []const u8,
        font: type, // Pass the font type
        color: config.Color,
    ) i16 {
        var current_x = x_start;
        const line_height = font.line_height;
        var current_y = y_start;

        for (text) |char_code| {
            if (char_code == '\n') {
                current_x = x_start;
                current_y += line_height;
                continue;
            }
            if (char_code == '\r') { // Handle carriage return, often comes with newline
                current_x = x_start;
                continue;
            }

            const char_width = self.drawChar(current_x, current_y, char_code, font, color);
            current_x += @as(i16, char_width) + @as(i16, font.char_spacing);

            // Basic word wrapping (very simple)
            // if (current_x > config.screen_width - char_width) { // Approximate next char width
            //     current_x = x_start;
            //     current_y += line_height;
            // }
        }
        return current_x;
    }

    // Provides direct access to the frame buffer.
    pub fn getFrameBuffer(self: *const Graphics) []const u8 {
        return &self.frame_buffer;
    }
};
