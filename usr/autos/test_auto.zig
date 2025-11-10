const std = @import("std");

/// ----------------------------------------------------------------
/// Base structure of all ROBERT systems.
/// Submit this struct along a JSON map to the engine to run a test.
/// ----------------------------------------------------------------

const TEST_AUTO = struct {
  name: []const u8,
  desc: []const u8,

  //
  // AUTO GLOBAL VARIABLES
  //

  const greeting: []const u8 = "hello"; 

  //
  // AUTO LOGIC UNIT
  //

  pub fn AutoLogicFunction(self: *TEST_AUTO) !void {
    std.debug.print("{s}\n", .{self.greeting});
  }

  //
  // AUTO CLEANUP
  //

  pub fn deinit() !void {

  }

};
