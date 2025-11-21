const std = @import("std");

pub const Position = struct {};

pub const PositionManager = struct {
    exposure: f64,

    pub fn init() PositionManager {
        return PositionManager {
            .exposure = 0,
        };
    }
};
