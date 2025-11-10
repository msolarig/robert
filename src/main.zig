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
  
  std.debug.print("{s}\n", .{test_engine.map.auto});
  std.debug.print("{s}\n", .{test_engine.map.db});
  std.debug.print("{s}\n", .{test_engine.map.table});
  std.debug.print("{d}\n", .{test_engine.map.t0});
  std.debug.print("{d}\n", .{test_engine.map.tn});
  std.debug.print("{any}\n", .{test_engine.map.mode});
  
  std.debug.print("\n", .{});

  std.debug.print("{d}\n", .{test_engine.trail.cl[0]});
  std.debug.print("{d}\n", .{test_engine.track.cl.items[test_engine.track.size - 1]});
}

test {
    _ = @import("tests/track_test.zig");
}
