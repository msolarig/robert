const std = @import("std");

/// Returns the absolute path for `p`.
/// If `p` is absolute: returns a dup of it.
/// If relative: resolves it against the executable's directory.
/// Caller must free the returned slice.
pub fn absFromExe(a: std.mem.Allocator, p: []const u8) ![]u8 {
    if (std.fs.path.isAbsolute(p))
        return try std.mem.Allocator.dupe(a, u8, p);

    var buf: [std.fs.max_path_bytes]u8 = undefined;
    const exe_path = try std.fs.selfExePath(&buf);

    // replicate dirnameAlloc manually
    const dir = blk: {
        const d = std.fs.path.dirname(exe_path) orelse ".";
        break :blk try std.mem.Allocator.dupe(a, u8, d);
    };
    defer a.free(dir);

    return try std.fs.path.join(a, &.{ dir, p });
}

/// Resolve `child` relative to the directory containing `anchor_file_abs`.
/// If `child` is absolute, just dup it.
pub fn relToFileDir(a: std.mem.Allocator, anchor_file_abs: []const u8, child: []const u8) ![]u8 {
    if (std.fs.path.isAbsolute(child))
        return try std.mem.Allocator.dupe(a, u8, child);

    const dir = std.fs.path.dirname(anchor_file_abs) orelse ".";
    return try std.fs.path.join(a, &.{ dir, child });
}

/// macOS-only helper: converts "usr/autos/XYZ.zig" -> "<exe_dir>/zig-out/usr/autos/XYZ.dylib"
pub fn autoSrcToCompiledAbs(a: std.mem.Allocator, src_rel_or_abs: []const u8) ![]u8 {
    const base = std.fs.path.basename(src_rel_or_abs);
    if (!std.mem.endsWith(u8, base, ".zig"))
        return error.NotZigSource;

    const stem = base[0 .. base.len - ".zig".len];

    var buf: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    const exe_path = try std.fs.selfExePath(&buf);
    const dir = blk: {
        const d = std.fs.path.dirname(exe_path) orelse ".";
        break :blk try std.mem.dupe(a, u8, d);
    };
    defer a.free(dir);

    return try std.fmt.allocPrint(a, "{s}/zig-out/usr/autos/{s}.dylib", .{ dir, stem });
}
