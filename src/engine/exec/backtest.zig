const std = @import("std");
const Engine = @import("../engine.zig").Engine;

pub fn runBacktest(engine: *Engine) !void {

  // this  is a test implementation. Normally this 
  // logic would go in the actual:
  //
  // engine.auto.AutoLogicFunction
  //
  //

  const data_points_required: u64 = 2;

  // track[0] = oldest data point
  // trail[0] = newest data point
  for (0..engine.track.size) |i| {
    try engine.trail.load(engine.track, i);
    if (i >= data_points_required) 
      engine.auto.AutoLogicFunction(engine.trail.vo[0]);
  }
}
