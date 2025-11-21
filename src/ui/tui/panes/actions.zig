const std = @import("std");
const vaxis = @import("vaxis");
const border = @import("border.zig");

/// Bottom-right ACTIONS pane
/// Placeholder text for now
pub fn render(win: vaxis.Window) void {
    border.draw(win, "ACTIONS");

    const segs = &[_]vaxis.Cell.Segment{
        .{ .text = "...", .style = .{} },
    };

    _ = win.print(segs, .{
        .row_offset = 1,
        .col_offset = 2,
    });
}
