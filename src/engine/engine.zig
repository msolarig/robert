const std = @import("std");
const db = @import("data/db_wrap.zig");
const Track = @import("data/track.zig").Track;
const Trail = @import("data/trail.zig").Trail;
const Map = @import("config/map.zig").Map;
const loader = @import("auto/loader.zig");
const Auto = loader.LoadedAuto;
const path_util = @import("../utils/path.zig");

/// Central Unit of Execution:
///  takes a single config file (map) and automatically
///  loads inputs, executes commands, produces specified output.
pub const Engine = struct {
  alloc: std.mem.Allocator,
  map: Map,
  auto: Auto,
  track: Track,
  trail: Trail,

  /// Initialize an engine instance
  ///   Reads & saves process configs.
  ///   Loads track, trail, compiled auto.
  pub fn init(alloc: std.mem.Allocator, map_path: []const u8) !Engine {
    const map_abs_path = try path_util.mapRelPathToAbsPath(alloc, map_path);
    defer alloc.free(map_abs_path);

    var decoded_map: Map = try Map.init(alloc, map_abs_path);
    errdefer {decoded_map.deinit();}

    const db_handle: *anyopaque = try db.openDB(decoded_map.db);
    var track: Track = Track.init();
    try track.load(alloc, db_handle, decoded_map.table, decoded_map.t0, decoded_map.tn);
    var trail: Trail = try Trail.init(alloc, decoded_map.trail_size);
    try trail.load(track, 0);
    try db.closeDB(db_handle);
    errdefer {track.deinit(alloc); trail.deinit(alloc);}
    
    const auto: Auto = try loader.load_from_file(alloc, decoded_map.auto);  

    return Engine{
      .alloc = alloc, .map = decoded_map,
      .auto = auto, .track = track, .trail = trail,
    };
  }

  /// Deinitialize engine instance
  ///  Frees map, auto, track, trail.
  pub fn deinit(self: *Engine) void {
    self.map.deinit();
    self.auto.deinit();
    self.track.deinit(self.alloc);
    self.trail.deinit(self.alloc);
  }
};
