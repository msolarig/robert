const std = @import("std");

pub const TrailABI = extern struct {
    ts: [*]const u64,
    op: [*]const f64,
    hi: [*]const f64,
    lo: [*]const f64,
    cl: [*]const f64,
    vo: [*]const u64,
};

pub const AutoAPI = extern struct {
    name: [*:0]const u8,
    desc: [*:0]const u8,
    logic_function: *const fn (trail: *const TrailABI) callconv(.c) void,
    deinit: *const fn () callconv(.c) void,
};

pub const GetAutoAPIFn = *const fn () callconv(.c) *const AutoAPI;
pub const ENTRY_SYMBOL = "get_auto_api_v1";
