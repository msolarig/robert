const std    = @import("std");
const Engine = @import("engine/engine.zig").Engine;

pub fn main() !void {
  
  // Main Program Allocator
  var gpa = std.heap.GeneralPurposeAllocator(.{}){};
  defer _ = gpa.deinit();
  const alloc = gpa.allocator();

  var engine: Engine = try Engine.init(alloc, "usr/maps/test_map.json");
  defer engine.deinit();

  for (0..10) |index| {
    _ = index;
    engine.auto.AutoLogicFunction(100);
  }
}

test {
    _ = @import("test/track_test.zig");
}
