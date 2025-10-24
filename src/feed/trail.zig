const std = @import("std");
const Point = @import("point.zig").Point;

pub const Trail = struct {
  size: usize,
  ts: []u64,
  op: []f64,
  hi: []f64,
  lo: []f64,
  cl: []f64,
  vo: []u64,   

  pub fn GetPoint(self: *Trail, index: u32) Point {
    const point_in_trail: Point = Point {
      .ts = self.ts[index],
      .op = self.op[index],
      .hi = self.hi[index],
      .lo = self.lo[index],
      .cl = self.cl[index],
      .vo = self.vo[index],
    };
    return point_in_trail;
  }
};      
