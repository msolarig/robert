const std    = @import("std");
const db     = @import("feed/sql_wrapper.zig");
const Track  = @import("feed/track.zig").Track;
const Trail  = @import("feed/trail.zig").Trail;
const Engine = @import("engine/engine.zig").Engine;
const Map    = @import("engine/map.zig").Map;

pub fn main() !void {
  // Main program allocator
  var gpa = std.heap.GeneralPurposeAllocator(.{}){};
  defer _ = gpa.deinit();
  const alloc = gpa.allocator();

  var test_engine: Engine = try Engine.init(alloc, "usr/maps/test_map.json");
  defer test_engine.deinit();

  
 



}

test {
    _ = @import("test/track_test.zig");
}
