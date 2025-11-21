const std = @import("std");
const path_util = @import("../../utils/path_converter.zig");

pub const OutputConfig = struct {
    name: []const u8,
};

pub const OutputManager = struct {
    /// Absolute directory path: <project-root>/usr/out/<name>
    dir_path: []u8, // owned

    pub fn init(alloc: std.mem.Allocator, name: []const u8) !OutputManager {
        // 1. Get project root
        const root = try path_util.getProjectRootPath(alloc);
        defer alloc.free(root);

        // 2. Build absolute directory path
        const full = try std.fmt.allocPrint(
            alloc,
            "{s}/usr/out/{s}",
            .{ root, name },
        );

        // 3. Ensure directory exists
        try std.fs.cwd().makePath(full);

        return .{
            .dir_path = full, // owned as required
        };
    }

    /// Build a file path inside the output dir
    pub fn filePath(self: *OutputManager, alloc: std.mem.Allocator, fname: []const u8) ![]u8 {
        return std.fmt.allocPrint(
            alloc,
            "{s}/{s}",
            .{ self.dir_path, fname },
        );
    }

    pub fn deinit(self: *OutputManager, alloc: std.mem.Allocator) void {
        alloc.free(self.dir_path);
    }
};
