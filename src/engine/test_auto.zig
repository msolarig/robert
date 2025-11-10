const std = @import("std");

/// ----------------------------------------------------------------
/// Base structure of all ROBERT systems.
/// ALL FIELDS & MARKED METHODS ARE REQUIRED BY THE SYSTEM
/// ----------------------------------------------------------------

const Auto = struct {
  name: []const u8 = "TEST_AUTO",

  //
  // AUTO GLOBAL VARIABLES
  //

  var greeting: []const u8 = "he"; 

  //
  // AUTO LOGIC UNIT
  //
  pub fn AutoLogicFunction(self: *Auto) !void {
    self.greeting = "hello";
    std.debug.print("{s}\n", .{self.greeting});
  }

  //
  // AUTO CLEANUP
  //
  pub fn deinit(self: *Auto) !void {
    _ = self;
  }
};
