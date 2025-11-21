const std = @import("std");
const vaxis = @import("vaxis");

/// Draws the bottom footer bar.
/// Currently very simple: shows just "STATUS: ready".
pub fn render(win: vaxis.Window) void {
    const segs = &[_]vaxis.Cell.Segment{
        .{ .text = "STATUS", .style = .{} },
    };

    _ = win.print(segs, .{
        .row_offset = 0,
        .col_offset = 1,
    });
}
