const std   = @import("std");
const db    = @import("data/sql_wrapper.zig");
const Track = @import("data/track.zig").Track;
const Trail = @import("data/trail.zig").Trail;
const Map   = @import("config/map.zig").Map;

pub const Engine = struct {
  alloc: std.mem.Allocator,
  map: Map,
  track: Track,
  trail: Trail,

  pub fn init(alloc: std.mem.Allocator, map_path: []const u8) !Engine {

    const decoded_map: Map = try Map.init(alloc, map_path);

    const db_handle: *anyopaque = try db.openDB(decoded_map.db);

    var track: Track = Track.init();
    try track.load(alloc, db_handle, decoded_map.table, decoded_map.t0, decoded_map.tn);

    var trail: Trail = try Trail.init(alloc, decoded_map.trail_size);
    try trail.load(track, 0);

    try db.closeDB(db_handle);

    return Engine{
      .alloc = alloc, .map   = decoded_map,
      .track = track, .trail = trail,
    };
  }

  pub fn deinit(self: *Engine) void {
    self.map.deinit();
    self.track.deinit(self.alloc);
    self.trail.deinit(self.alloc);
  }
};
