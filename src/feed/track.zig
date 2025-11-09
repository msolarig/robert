const std = @import("std");
const sql = @import("sql_wrapper.zig");

pub const Track = struct {
  size: u64,
  ts: std.ArrayListUnmanaged(u64),
  op: std.ArrayListUnmanaged(f64),
  hi: std.ArrayListUnmanaged(f64),
  lo: std.ArrayListUnmanaged(f64),
  cl: std.ArrayListUnmanaged(f64),
  vo: std.ArrayListUnmanaged(u64),

  pub fn init() Track {
    return Track{
      .size = 0,
      .ts = .{},
      .op = .{},
      .hi = .{},
      .lo = .{},
      .cl = .{},
      .vo = .{},
      };
    }

  pub fn deinit(self: *Track, alloc: std.mem.Allocator) void {
    self.size = 0;
    self.ts.deinit(alloc);
    self.op.deinit(alloc);
    self.hi.deinit(alloc);
    self.lo.deinit(alloc);
    self.cl.deinit(alloc);
    self.vo.deinit(alloc);
  }

  pub fn load(self: *Track, alloc: std.mem.Allocator, db: *anyopaque, 
              table: []const u8, t0: u64, tn: u64) !void {

    const query: []const u8 = "SELECT timestamp, open, high, low, close, volume FROM {s}";
    const command: []const u8 = try std.fmt.allocPrint(alloc, query, .{table});
    const c_command = try std.heap.c_allocator.dupeZ(u8, command);
    defer std.heap.c_allocator.free(c_command);
    defer alloc.free(command);

    var stmt: ?*anyopaque = null;
    var tail: ?*[*:0]const u8 = null;
    const prepare = sql.sqlite3_prepare_v2(db, c_command, -1, &stmt, &tail);

    if (prepare != 0) {
      const errmsg = sql.sqlite3_errmsg(db);
      const msg = std.mem.span(errmsg);
      std.debug.print("SQLite prepare error: {s}\n", .{msg});
      return error.PrepareFailed;
    }

    while (sql.sqlite3_step(stmt.?) == 100) {
      const timestamp: u64 = @intFromFloat(sql.sqlite3_column_double(stmt.?, 0));
      if (timestamp > t0 and timestamp < tn) { // Non-inclusive
        const open = sql.sqlite3_column_double(stmt.?, 1);
        const high = sql.sqlite3_column_double(stmt.?, 2);
        const low = sql.sqlite3_column_double(stmt.?, 3);
        const close = sql.sqlite3_column_double(stmt.?, 4);
        const volume: u64 = @intFromFloat(sql.sqlite3_column_double(stmt.?, 5));
        try self.addRow(alloc, timestamp, open, high, low, close, volume);
      }
    }
    _ = sql.sqlite3_finalize(stmt.?);
  }

  pub fn addRow(self: *Track, alloc: std.mem.Allocator,
                ts: u64, op: f64, hi: f64, lo: f64, cl: f64, vo: u64) !void {

    try self.ts.append(alloc, ts);
    try self.op.append(alloc, op);
    try self.hi.append(alloc, hi);
    try self.lo.append(alloc, lo);
    try self.cl.append(alloc, cl);
    try self.vo.append(alloc, vo);
    self.size += 1;
  }
};
