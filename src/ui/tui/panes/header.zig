const std = @import("std");
const vaxis = @import("vaxis");

/// Draws the top header bar.
/// Width is taken from the window.
pub fn render(win: vaxis.Window) void {
    const text = " ROBERT! — The Robotic Execution & Research Terminal ";

    const segs = &[_]vaxis.Cell.Segment{
        .{ .text = text, .style = .{} },
    };

    const col = @as(u16, 0);
    const row = @as(u16, 0);

    _ = win.print(segs, .{
        .row_offset = row,
        .col_offset = col,
    });
}
