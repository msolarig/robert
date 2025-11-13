const std = @import("std");
const Engine = @import("../engine.zig").Engine;
const abi = @import("../auto/abi.zig");

pub fn runBacktest(engine: *Engine) !void {

  // Minimum data points before beginning calculations.
  //  Used to avoid index out of range error when functions 
  //  require access to a minimum amount of past data points.
  const data_points_required: u64 = 2;

  // Backtest Iterator
  //  execute block once per data point on Engine Track.
  for (0..engine.track.size) |i| {

    // FOR tesing, this logic will go inside auto eventually.
    if (i >= data_points_required) {
      try engine.trail.load(engine.track, i);
      const trail = engine.trail.toABI();
      std.debug.print("Data Point {d}\n", .{i + 1});
      engine.auto.AutoLogicFunction(trail);
    }
  }
}
