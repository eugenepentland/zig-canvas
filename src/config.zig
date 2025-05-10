// file: src/config.zig
// Defines the screen dimensions.
pub const screen_width: u16 = 248;
pub const screen_height: u16 = 128;
pub const frame_buffer_size: usize = (screen_width * screen_height) / 8;

// Color definitions (for monochrome)
pub const Color = enum {
    Black, // Pixel is set (ink)
    White, // Pixel is clear (paper)
};
