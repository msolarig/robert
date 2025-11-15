const std = @import("std");

/// Returns the project root (three directories above the executable)
pub fn getProjectRootPath(alloc: std.mem.Allocator) ![]u8 {
    const builtin = @import("builtin");

    if (builtin.is_test) {
        // During tests: CWD *is the project root*
        return try alloc.dupe(u8, ".");
    }

    // Normal mode: walk up from executable
    var buf: [std.fs.max_path_bytes]u8 = undefined;
    const exe_path = try std.fs.selfExePath(&buf);

    const bin_dir     = std.fs.path.dirname(exe_path)        orelse return error.BadExePath;
    const zig_out_dir = std.fs.path.dirname(bin_dir)         orelse return error.BadExePath;
    const root_dir    = std.fs.path.dirname(zig_out_dir)     orelse return error.BadExePath;

    return try alloc.dupe(u8, root_dir);
}

/// Tries multiple directories and returns the absolute path of the first match.
/// `dirs` is a list of directory strings relative to the project root.
fn findExistingFile(
    alloc: std.mem.Allocator,
    root_abs: []const u8,
    file_name: []const u8,
    dirs: []const []const u8,
) ![]const u8 {
    var cwd = std.fs.cwd();

    for (dirs) |dir| {
        const full = try std.fmt.allocPrint(alloc, "{s}/{s}/{s}", .{
            root_abs,
            dir,
            file_name,
        });

        // Try accessing the file
        if (cwd.access(full, .{})) |_| {
            return full; // KEEP and return it
        } else |_| {
            alloc.free(full); // cleanup
        }
    }

    return error.FileNotFound;
}

/// Finds an auto-compiled dylib path like:
/// usr/auto/AUTO.zig  → zig-out/bin/auto/AUTO.dylib
fn resolveAutoDylibPath(
    alloc: std.mem.Allocator,
    root_abs: []const u8,
    zig_file: []const u8,
) ![]u8 {
    const file_name = std.fs.path.basename(zig_file);

    if (!std.mem.endsWith(u8, file_name, ".zig"))
        return error.InvalidFilePath;

    const stem = file_name[0 .. file_name.len - ".zig".len];

    return try std.fmt.allocPrint(alloc, "{s}/zig-out/bin/auto/{s}.dylib", .{
        root_abs,
        stem,
    });
}

/// Converts "usr/map/MAP.json" → absolute path
/// Falls back to "test/test_maps/" if not found.
pub fn mapRelPathToAbsPath(
    alloc: std.mem.Allocator,
    map_path: []const u8,
) ![]const u8 {
    const file_name = std.fs.path.basename(map_path);

    if (!std.mem.endsWith(u8, file_name, ".json"))
        return error.InvalidFileType;

    const root_abs = try getProjectRootPath(alloc);
    defer alloc.free(root_abs);

    return try findExistingFile(
        alloc,
        root_abs,
        file_name,
        &.{
            "usr/map", // primary
            "test/map", // fallback
        },
    );
}

/// Converts "usr/auto/AUTO.zig" → absolute dylib path
pub fn autoSrcRelPathToCompiledAbsPath(
    alloc: std.mem.Allocator,
    auto_path: []const u8,
) ![]const u8 {
    const root_abs = try getProjectRootPath(alloc);
    defer alloc.free(root_abs);

    return try resolveAutoDylibPath(alloc, root_abs, auto_path);
}

/// Converts "usr/data/DB.db" → absolute path
/// Includes fallback search (optional — change dirs if needed)
pub fn dbRelPathToAbsPath(
    alloc: std.mem.Allocator,
    db_path: []const u8,
) ![]const u8 {
    const file_name = std.fs.path.basename(db_path);

    if (!std.mem.endsWith(u8, file_name, ".db"))
        return error.InvalidFilePath;

    const root_abs = try getProjectRootPath(alloc);
    defer alloc.free(root_abs);

    return try findExistingFile(
        alloc,
        root_abs,
        file_name,
        &.{
            "usr/data", // primary
            "test/data", // fallback (change if needed)
        },
    );
}
