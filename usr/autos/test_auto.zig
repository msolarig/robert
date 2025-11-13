const std = @import("std");

// inline ABI (match src/engine/auto/abi.zig) -------------const std = @import("std");

pub const TrailABI = extern struct {
    ts: [*]const u64, op: [*]const f64, hi: [*]const f64,
    lo: [*]const f64, cl: [*]const f64, vo: [*]const u64,
};

pub const AutoAPI = extern struct {
    name: [*:0]const u8,
    desc: [*:0]const u8,
    logic_function: *const fn (trail: *const TrailABI) callconv(.c) void,
    deinit: *const fn () callconv(.c) void,
};

pub const GetAutoAPIFn = *const fn () callconv(.c) *const AutoAPI;
pub const ENTRY_SYMBOL = "get_auto_api_v1";
// --------------------------------------------------------

fn autoLogicFunction(trail: *const TrailABI) callconv(.c) void {
  std.debug.print("----------------------------------\n", .{});
  std.debug.print("Data Point TS: {d}\n", .{trail.ts[0]});
  std.debug.print("Data Point OP: {d}\n", .{trail.op[0]});
  std.debug.print("Data Point HI: {d}\n", .{trail.hi[0]});
  std.debug.print("Data Point LO: {d}\n", .{trail.lo[0]});
  std.debug.print("Data Point CL: {d}\n", .{trail.cl[0]});
  std.debug.print("Data Point VO: {d}\n", .{trail.vo[0]});
  std.debug.print("Data Point RANGE: {d}\n", .{trail.hi[0] - trail.lo[0]});
  std.debug.print("----------------------------------\n", .{});
} 

fn deinit() callconv(.c) void {
    std.debug.print("[auto] deinit\n", .{});
}

pub export fn get_auto_api_v1() callconv(.c) *const AutoAPI {
    // Keep strings with static storage duration (C-strings)
    const NAME: [*:0]const u8 = "TEST_AUTO";
    const DESC: [*:0]const u8 = "TEST_AUTO_DESCRIPTION";

    // Put the API in static storage so the returned pointer stays valid
    const API = AutoAPI{
        .name = NAME,
        .desc = DESC,
        .logic_function = autoLogicFunction,
        .deinit = deinit,
    };
    return &API;
}
