const std = @import("std");

pub const Point = struct {
  ts: u64,
  op: f64,
  hi: f64,
  lo: f64,
  cl: f64,
  vo: u64, 
};
