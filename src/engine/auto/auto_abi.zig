const std = @import("std");

pub const AutoAPI = extern struct {
    name: [*:0]const u8,
    description: [*:0]const u8,
    functionLogic: *const fn (dt: u64) callconv(.c) void,
    deinit: *const fn () callconv(.c) void,
};

pub const GetAutoAPIFn = *const fn () callconv(.c) *const AutoAPI;
pub const ENTRY_SYMBOL = "get_auto_api_v1";
