const std = @import("std");
const builtin = @import("builtin");
const abi = @import("abi.zig");

pub const LoadedAuto = struct {
  allocator: std.mem.Allocator,
  lib_path: []const u8,
  lib: std.DynLib,
  api: *const abi.AutoAPI,

  pub fn AutoLogicFunction(self: *LoadedAuto, dt: u64) void {
    self.api.functionLogic(dt);
  }

  pub fn deinit(self: *LoadedAuto) void {
    self.api.deinit();
    self.lib.close();
    self.allocator.free(self.lib_path);
  }
};

pub fn load_from_file(allocator: std.mem.Allocator, auto_file_path: []const u8) !LoadedAuto {

  const base = std.fs.path.basename(auto_file_path);
  if (std.mem.endsWith(u8, base, ".dylib") == false) return error.NotADynamicLibraryName;

  // Open the library
  var lib = try std.DynLib.open(auto_file_path);
  errdefer lib.close();

  // Lookup the single entrypoint
  const get_api = lib.lookup(abi.GetAutoAPIFn, abi.ENTRY_SYMBOL) orelse
    return error.MissingEntrySymbol;

  // Zig 0.15.1: function returns non-optional pointer
  const api = get_api();

  // Own a copy of the file path
  const lib_copy = try std.mem.Allocator.dupe(allocator, u8, auto_file_path);
  errdefer allocator.free(lib_copy);

  return .{.allocator = allocator, .lib_path = lib_copy, .lib = lib, .api = api};
}

pub fn runAuto(auto_src_path: []const u8) !void {
  var gpa = std.heap.GeneralPurposeAllocator(.{}){};
  defer _ = gpa.deinit();
  const alloc = gpa.allocator();

  var la = try load_from_file(alloc, auto_src_path);
  defer la.deinit();

  std.debug.print("Loaded auto: {s}\n{s}\n", .{ la.api.name, la.api.description });

  // TEST
  la.AutoLogicFunction(100);
}
