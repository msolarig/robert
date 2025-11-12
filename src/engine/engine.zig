const std   = @import("std");
const db    = @import("data/sql_wrapper.zig");
const Track = @import("data/track.zig").Track;
const Trail = @import("data/trail.zig").Trail;
const Map   = @import("config/map.zig").Map;

const path = @import("../utils/path.zig");

// Runtime Auto Load
const auto_loader = @import("auto/loader.zig");
const Auto = auto_loader.LoadedAuto;

pub const Engine = struct {
  alloc: std.mem.Allocator,
  map: Map,
  auto: Auto,
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
    
    // MEMORY LEAK
    //const map_abs = try path.absFromExe(alloc, decoded_map.auto);
    //defer alloc.free(map_abs);

    //const abs_auto_path: []const u8 = try path.relToFileDir(alloc, map_abs, decoded_map.auto);
    //defer alloc.free(abs_auto_path);

    const auto: Auto = try auto_loader.load_from_file(alloc, decoded_map.auto);  
    //defer alloc.free(auto);

    return Engine{
      .alloc = alloc, .map = decoded_map,
      .auto = auto, .track = track, .trail = trail,
    };
  }

  pub fn deinit(self: *Engine) void {
    self.map.deinit();
    self.auto.deinit();
    self.track.deinit(self.alloc);
    self.trail.deinit(self.alloc);
  }
};
