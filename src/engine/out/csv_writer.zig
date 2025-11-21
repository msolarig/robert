const std = @import("std");
const OutputManager = @import("output.zig").OutputManager;
const FillManager = @import("../../roblang/core/fill.zig").FillManager;

pub fn writeFillsCSV(out: *OutputManager, fm: *FillManager, filename: []const u8) !void {
    // full absolute path
    const full_path = try out.filePath(std.heap.page_allocator, filename);
    defer std.heap.page_allocator.free(full_path);

    // create/truncate
    var file = try std.fs.cwd().createFile(full_path, .{ .truncate = true });
    defer file.close();

    // buffering
    var buf: [4096]u8 = undefined;
    var bw = file.writer(&buf);

    _ = try bw.file.write("Count,Index,Timestamp,Side,Price,Volume\n");

    var count: usize = 0;

    for (fm.fills.items) |fill| {
        count += 1;

        const side_str = switch (fill.side) {
            .Buy => "Buy",
            .Sell => "Sell",
        };

        var line_buf: [128]u8 = undefined;
        const line = try std.fmt.bufPrint(
            &line_buf,
            "{d:05},{d:05},{d},{s},{d:.4},{d:.4}\n",
            .{ count, fill.iter, fill.timestamp, side_str, fill.price, fill.volume },
        );

        _ = try bw.file.write(line);
    }

    try file.sync();
}
