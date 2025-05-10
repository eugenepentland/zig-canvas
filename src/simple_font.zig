pub const FontChar = struct {
    code: u8,
    width: u8,
    height: u8,
    data: [5]u8, // 5 columns, 7 bits per column used
};

pub const simple_font_chars = [_]FontChar{
    FontChar{ .code = 'A', .width = 5, .height = 7, .data = [_]u8{ 0x7E, 0x09, 0x09, 0x09, 0x7E } }, // A
    FontChar{ .code = 'B', .width = 5, .height = 7, .data = [_]u8{ 0x7F, 0x49, 0x49, 0x49, 0x36 } }, // B
    FontChar{ .code = 'C', .width = 5, .height = 7, .data = [_]u8{ 0x3E, 0x41, 0x41, 0x41, 0x22 } }, // C
    FontChar{ .code = 'H', .width = 5, .height = 7, .data = [_]u8{ 0x7F, 0x08, 0x08, 0x08, 0x7F } }, // H
    FontChar{ .code = 'e', .width = 5, .height = 7, .data = [_]u8{ 0x3A, 0x45, 0x45, 0x45, 0x38 } }, // e (approx)
    FontChar{ .code = 'l', .width = 1, .height = 7, .data = [_]u8{ 0x7F, 0x00, 0x00, 0x00, 0x00 } }, // l (simplified to 1px wide)
    FontChar{ .code = 'o', .width = 5, .height = 7, .data = [_]u8{ 0x3E, 0x41, 0x41, 0x41, 0x3E } }, // o
    FontChar{ .code = 'W', .width = 5, .height = 7, .data = [_]u8{ 0x7F, 0x20, 0x18, 0x20, 0x7F } }, // W (approx)
    FontChar{ .code = 'r', .width = 5, .height = 7, .data = [_]u8{ 0x7E, 0x09, 0x05, 0x05, 0x02 } }, // r (approx)
    FontChar{ .code = 'd', .width = 5, .height = 7, .data = [_]u8{ 0x2F, 0x44, 0x44, 0x44, 0x3B } }, // d (approx)
    FontChar{ .code = 'Z', .width = 5, .height = 7, .data = [_]u8{ 0x47, 0x49, 0x51, 0x61, 0x41 } }, // Z
    FontChar{ .code = 'i', .width = 1, .height = 7, .data = [_]u8{ 0x45, 0x00, 0x00, 0x00, 0x00 } }, // i (simplified, with dot)
    FontChar{ .code = 'g', .width = 5, .height = 7, .data = [_]u8{ 0x38, 0x45, 0x45, 0x39, 0x0E } }, // g (approx)
    FontChar{ .code = '!', .width = 1, .height = 7, .data = [_]u8{ 0x5F, 0x00, 0x00, 0x00, 0x00 } }, // !
    FontChar{ .code = ' ', .width = 3, .height = 7, .data = [_]u8{ 0x00, 0x00, 0x00, 0x00, 0x00 } }, // Space
    // Add more characters as needed
};

pub const SimpleFont = struct {
    pub fn getChar(code: u8) ?FontChar {
        inline for (simple_font_chars) |char_def| {
            if (char_def.code == code) {
                return char_def;
            }
        }
        return null; // Character not found
    }
    pub const line_height: u8 = 8; // Height of each character + 1 for spacing
    pub const char_spacing: u8 = 1; // Pixels between characters
};
