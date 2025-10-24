const std = @import("std");
const db = @import("feed/sql_wrapper.zig");

pub fn main() !void {
  const handle: *anyopaque = try db.openDB("data/market.db");
  try db.closeDB(handle);
}

