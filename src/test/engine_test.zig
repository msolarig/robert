const std = @import("std");
const Engine = @import("../engine/engine.zig").Engine;

test "ENGINE TRACK TEST" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    var eng_1: Engine = try Engine.init(alloc, "test_map.json");
    defer eng_1.deinit();

    const t = eng_1.track;

    // CHECKS: Data Point Count
    try std.testing.expectEqual(t.ts.items.len, 6288);

    // CHECKS: Data Point Consistency
    try std.testing.expectEqual(t.ts.items.len, t.op.items.len);
    try std.testing.expectEqual(t.ts.items.len, t.hi.items.len);
    try std.testing.expectEqual(t.ts.items.len, t.lo.items.len);
    try std.testing.expectEqual(t.ts.items.len, t.cl.items.len);
    try std.testing.expectEqual(t.ts.items.len, t.vo.items.len);

    // CHECKs: Data Loading Accuracy
    try std.testing.expectEqual(t.ts.items[0], 1735516800);
    try std.testing.expectEqual(t.ts.items[t.ts.items.len - 1], 946857600);

    try std.testing.expectEqual(t.op.items[0], 251.33775398934142);
    try std.testing.expectEqual(t.op.items[t.op.items.len - 1], 0.7870901168329728);

    try std.testing.expectEqual(t.hi.items[0], 252.60326573181473);
    try std.testing.expectEqual(t.hi.items[t.hi.items.len - 1], 0.8443156783566781);

    try std.testing.expectEqual(t.lo.items[0], 249.86299361835324);
    try std.testing.expectEqual(t.lo.items[t.lo.items.len - 1], 0.7631676614192741);

    try std.testing.expectEqual(t.cl.items[0], 251.307861328125);
    try std.testing.expectEqual(t.cl.items[t.cl.items.len - 1], 0.8400943279266357);

    try std.testing.expectEqual(t.vo.items[0], 35557500);
    try std.testing.expectEqual(t.vo.items[t.vo.items.len - 1], 535796800);
}

test "ENGINE TRAIL TEST" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    var eng_1: Engine = try Engine.init(alloc, "test_map.json");
    defer eng_1.deinit();

    const t = eng_1.trail;

    // CHECKS: Data Point Count
    try std.testing.expectEqual(t.ts.len, 10);

    // CHECKS: Data Point Consistency
    try std.testing.expectEqual(t.ts.len, t.op.len);
    try std.testing.expectEqual(t.ts.len, t.hi.len);
    try std.testing.expectEqual(t.ts.len, t.lo.len);
    try std.testing.expectEqual(t.ts.len, t.cl.len);
    try std.testing.expectEqual(t.ts.len, t.vo.len);

    // CHECKs: Data Loading Accuracy
    try std.testing.expectEqual(t.ts[0], 946857600);
    try std.testing.expectEqual(t.ts[t.ts.len - 1], 947808000);

    try std.testing.expectEqual(t.op[0], 0.7870901168329728);
    try std.testing.expectEqual(t.op[t.op.len - 1], 0.7505028370602003);

    try std.testing.expectEqual(t.hi[0], 0.8443156783566781);
    try std.testing.expectEqual(t.hi[t.hi.len - 1], 0.7673888884875701);

    try std.testing.expectEqual(t.lo[0], 0.7631676614192741);
    try std.testing.expectEqual(t.lo[t.lo.len - 1], 0.7458124871090789);

    try std.testing.expectEqual(t.cl[0], 0.8400943279266357);
    try std.testing.expectEqual(t.cl[t.cl.len - 1], 0.7537860870361328);

    try std.testing.expectEqual(t.vo[0], 535796800);
    try std.testing.expectEqual(t.vo[t.vo.len - 1], 390376000);

    // CHECKS: Track - Trail Relationship
    try std.testing.expectEqual(t.ts[0], eng_1.track.ts.items[6288 - 1]);
    try std.testing.expectEqual(t.ts[t.ts.len - 1], eng_1.track.ts.items[6288 - 10]);
}
