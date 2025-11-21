const std = @import("std");
const vaxis = @import("vaxis");

// Panes
const Header = @import("panes/header.zig");
const Browser = @import("panes/browser.zig");
const Preview = @import("panes/preview.zig");
const Actions = @import("panes/actions.zig");
const Footer = @import("panes/footer.zig");

// Define the event union used by Vaxis.Loop
const Event = union(enum) {
    key_press: vaxis.Key,
    winsize: vaxis.Winsize,
};

pub fn run(gpa: std.mem.Allocator) !void {
    // ----------------------------
    // TTY + Vaxis initialization
    // ----------------------------
    var tty_buf: [1024]u8 = undefined;
    var tty = try vaxis.Tty.init(&tty_buf);
    defer tty.deinit();

    var vx = try vaxis.init(gpa, .{});
    defer vx.deinit(gpa, tty.writer());

    // Event Loop with our custom Event type
    var loop: vaxis.Loop(Event) = .{
        .tty = &tty,
        .vaxis = &vx,
    };
    try loop.init();
    try loop.start();
    defer loop.stop();

    try vx.enterAltScreen(tty.writer());
    try vx.queryTerminal(tty.writer(), 100 * std.time.ms_per_s);

    // ----------------------------
    // Main Event Loop
    // ----------------------------
    while (true) {
        const event = loop.nextEvent(); // already of type Event

        switch (event) {
            .key_press => |key| {
                if (key.matches('q', .{})) break;
                if (key.matches('c', .{ .ctrl = true })) break;
            },
            .winsize => |ws| {
                try vx.resize(gpa, tty.writer(), ws);
            },
        }

        const win = vx.window();
        win.clear();

        // ----------------------------
        // Layout Constants
        // ----------------------------
        const full_w = win.width;
        const full_h = win.height;

        const header_h: usize = 1;
        const footer_h: usize = 1;

        const content_h = full_h - header_h - footer_h;

        const browser_w: usize = (full_w * 3) / 4;
        const right_w: usize = full_w - browser_w;

        const preview_h = content_h / 2;
        const actions_h = content_h - preview_h;

        // ----------------------------
        // Header
        // ----------------------------
        {
            const header_win = win.child(.{
                .x_off = 0,
                .y_off = 0,
                .width = full_w,
                .height = header_h,
            });
            Header.render(header_win);
        }

        // ----------------------------
        // Browser (left)
        // ----------------------------
        {
            const browser_win = win.child(.{
                .x_off = 0,
                .y_off = header_h,
                .width = @intCast(browser_w),
                .height = @intCast(content_h),
            });

            try Browser.render(browser_win);
        }

        // ----------------------------
        // Preview (top-right)
        // ----------------------------
        {
            const preview_win = win.child(.{
                .x_off = @intCast(browser_w),
                .y_off = header_h,
                .width = @intCast(right_w),
                .height = @intCast(preview_h),
            });
            Preview.render(preview_win);
        }

        // ----------------------------
        // Actions (bottom-right)
        // ----------------------------
        {
            const actions_win = win.child(.{
                .x_off = @intCast(browser_w),
                .y_off = @intCast(header_h + preview_h),
                .width = @intCast(right_w),
                .height = @intCast(actions_h),
            });
            Actions.render(actions_win);
        }

        // ----------------------------
        // Footer
        // ----------------------------
        {
            const footer_win = win.child(.{
                .x_off = 0,
                .y_off = @intCast(header_h + content_h),
                .width = full_w,
                .height = footer_h,
            });
            Footer.render(footer_win);
        }

        try vx.render(tty.writer());
    }
}
