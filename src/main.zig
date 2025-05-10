const std = @import("std");
const Graphics = @import("graphics_core.zig").Graphics;
const SimpleFont = @import("simple_font.zig").SimpleFont;
const PbmSaver = @import("pbm_saver.zig").PbmSaver;
const config = @import("config.zig");

pub fn main() !void {
    var g = Graphics.init(); // Initializes with a white background

    // Draw some text
    _ = g.drawString(5, 10, "ABCDEFGHIJK", SimpleFont, config.Color.Black);

    // Save the result to a PBM file
    const output_filename = "eink_preview.pbm";
    try PbmSaver.saveToFile(&g, output_filename);
    std.debug.print("Saved e-ink preview to '{s}'\n", .{output_filename});

    // To use on microcontroller:
    // const raw_pixel_data = g.getFrameBuffer();
    // You would then take `raw_pixel_data` and send it to your e-ink display
    // using the appropriate SPI commands and display controller protocol.
    // Ensure the bit order (MSB/LSB) and color interpretation (0=black/white)
    // match your e-ink display's requirements. Our PBM uses 1=black, 0=white.
}
