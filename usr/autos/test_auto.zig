const std = @import("std");

// inline ABI (match src/engine/auto/abi.zig) -------------
const AutoAPI = extern struct {
    name: [*:0]const u8,
    description: [*:0]const u8,
    functionLogic: *const fn (dt: u64) callconv(.c) void,
    deinit: *const fn () callconv(.c) void,
};

const GetAutoAPIFn = *const fn () callconv(.c) *const AutoAPI;
const ENTRY_SYMBOL = "get_auto_api_v1";
// --------------------------------------------------------

fn logic(dt: u64) callconv(.c) void {
    std.debug.print("{d} HOLA\n", .{dt});
} 

fn cleanup() callconv(.c) void {
    std.debug.print("[auto] deinit\n", .{});
}

pub export fn get_auto_api_v1() callconv(.c) *const AutoAPI {
    // Keep strings with static storage duration (C-strings)
    const NAME: [*:0]const u8 = "TEST_AUTO";
    const DESC: [*:0]const u8 = "TEST_AUTO_DESCRIPTION";

    // Put the API in static storage so the returned pointer stays valid
    const API = AutoAPI{
        .name = NAME,
        .description = DESC,
        .functionLogic = logic,
        .deinit = cleanup,
    };
    return &API;
}
