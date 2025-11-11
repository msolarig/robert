const std    = @import("std");
const db     = @import("engine/data/sql_wrapper.zig");
const Track  = @import("engine/data/track.zig").Track;
const Trail  = @import("engine/data/trail.zig").Trail;
const Engine = @import("engine/engine.zig").Engine;
const Map    = @import("engine/config/map.zig").Map;

const loader = @import("engine/auto/auto_loader.zig");

pub fn main() !void {
  
  // Main Program Allocator
  var gpa = std.heap.GeneralPurposeAllocator(.{}){};
  defer _ = gpa.deinit();
  const alloc = gpa.allocator();

  var engine: Engine = try Engine.init(alloc, "usr/maps/test_map.json");
  defer engine.deinit();

  try loader.runAuto(engine.map.auto);
}

test {
    _ = @import("test/track_test.zig");
}
