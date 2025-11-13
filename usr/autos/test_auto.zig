const std = @import("std");

/// Auto Export Function
///   Provides ROBERT with an interface to access the compiled AUTO.
///   Update name & description. Do not modify ABI struct insance declaration. 
pub export fn getAutoABI() callconv(.c) *const AutoABI {
    const NAME: [*:0]const u8 = "TEST_AUTO";
    const DESC: [*:0]const u8 = "TEST_AUTO_DESCRIPTION";

    const ABI = AutoABI{
        .name = NAME,
        .desc = DESC,
        .logic_function = autoLogicFunction,
        .deinit = deinit,
    };
    return &ABI;
}

// Custom Auto variables & methods ------------------------
const minimum_required_data_points: u64 = 2;
// --------------------------------------------------------

/// Execution Function
///   Called once per update in data feed.
fn autoLogicFunction(iter_index: u64, trail: *const TrailABI) callconv(.c) void {
  if (iter_index >= minimum_required_data_points) {
    std.debug.print("{d} -------------------------------\n", .{iter_index + 1});
    std.debug.print("Data Point RANGE: {d}\n", .{trail.hi[0] - trail.lo[0]});
    std.debug.print("----------------------------------\n", .{});
  }
} 

/// Deinitialization Function
///  Called once by the engine at the end of the process. 
///  Include any allocated variables inside to avoid memory leak errors.
fn deinit() callconv(.c) void {
    std.debug.print("Auto Deinitialized\n", .{});
}

// ------------------------------------------------------------------------------------------------
// ABI Declarations (DO NOT MODIFY)
// ------------------------------------------------------------------------------------------------

/// inline Auto ABI (match src/engine/auto/abi.zig)
///  Interaction between compiled auto and compiled application. 
pub const TrailABI = extern struct {
    ts: [*]const u64, op: [*]const f64, hi: [*]const f64,
    lo: [*]const f64, cl: [*]const f64, vo: [*]const u64,
};

pub const AutoABI = extern struct {
    name: [*:0]const u8,
    desc: [*:0]const u8,
    logic_function: *const fn (iter_index: u64, trail: *const TrailABI) callconv(.c) void,
    deinit: *const fn () callconv(.c) void,
};

pub const GetAutoABIFn = *const fn () callconv(.c) *const AutoABI;
pub const ENTRY_SYMBOL = "getAutoABI";
