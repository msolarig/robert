const std = @import("std");

pub const Track = struct {
  size: usize,
  ts: []u64,
  op: []f64,
  hi: []f64,
  lo: []f64,
  cl: []f64,
  vo: []u64,

  pub fn deinit(self: *Track, allocator: std.mem.Allocator) void {
    allocator.free(self.ts);
    allocator.free(self.op);
    allocator.free(self.hi);
    allocator.free(self.lo);
    allocator.free(self.cl);
    allocator.free(self.vo);
  }
};
