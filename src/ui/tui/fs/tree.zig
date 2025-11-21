const std = @import("std");

pub const Node = struct {
    name: []const u8,
    is_dir: bool,
    parent: ?*Node,
    children: []*Node,
};

pub fn buildTreeAlloc(alloc: std.mem.Allocator, path: []const u8) !*Node {
    var root_dir = try std.fs.cwd().openDir(path, .{ .iterate = true });

    const root = try alloc.create(Node);
    root.* = .{
        .name = try alloc.dupe(u8, path),
        .is_dir = true,
        .parent = null,
        .children = &.{},
    };

    try loadChildren(alloc, root, &root_dir);
    return root;
}

fn loadChildren(
    alloc: std.mem.Allocator,
    parent: *Node,
    dir: *std.fs.Dir,           // ← FIXED (no const)
) !void {
    var iter = dir.iterate();

    var scratch: std.ArrayList(*Node) = .{};
    defer scratch.deinit(alloc);

    while (try iter.next()) |entry| {
        if (std.mem.eql(u8, entry.name, ".DS_Store"))
            continue;

        const child = try alloc.create(Node);
        child.* = .{
            .name = try alloc.dupe(u8, entry.name),
            .is_dir = entry.kind == .directory,
            .parent = parent,
            .children = &.{},
        };

        try scratch.append(alloc, child);

        if (child.is_dir) {
            var subdir = try dir.openDir(entry.name, .{ .iterate = true }); // ← FIXED
            try loadChildren(alloc, child, &subdir);                        // ← FIXED
        }
    }

    parent.children = try scratch.toOwnedSlice(alloc);
}

pub fn flattenTree(
    alloc: std.mem.Allocator,
    node: *Node,
    depth: usize,
    out: *std.ArrayList([]const u8),
) !void {
    var indent_buf: [128]u8 = undefined;
    const indent_len = @min(depth * 4, indent_buf.len);

    for (indent_buf[0..indent_len]) |*b| b.* = ' ';
    const indent = indent_buf[0..indent_len];

    const icon = if (node.is_dir) "[D] " else "[F] ";

    var line_buf: [256]u8 = undefined;
    const line = try std.fmt.bufPrint(
        &line_buf,
        "{s}{s}{s}",
        .{ indent, icon, node.name },
    );

    try out.append(alloc, try alloc.dupe(u8, line));

    for (node.children) |child| {
        try flattenTree(alloc, child, depth + 1, out);
    }
}
