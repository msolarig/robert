const std = @import("std");
const db = @import("feed/sql_wrapper.zig");
const Track = @import("feed/track.zig").Track;

pub fn main() !void {
  std.debug.print("hey\n", .{});
}
