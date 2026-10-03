// The body, lid and cap against one other thing at crank angle a, for tools/qa/qa.sh: what the
// intersection leaves is a collision. Run with -D 'part="report"' so main draws nothing of its own.
// clang-format off
include <../../cad/main.scad>;
// clang-format on

a = 0;
other = "crank";
$fn = 24;

z = get(L, "axis_z");
cp = crank_pin(L, a);
px = clip_pin_x(L, a);
cl = get(L, "clip");
bx = px - get(cl, "pin_x");
B = get(L, "body");

module placed(n)
{
    if (n == "frame")
        frame(get(L, "frame"));
    if (n == "crank")
        translate([ get(L, "crank_x"), 0, get(L, "hub_z") ]) rotate([ 0, 0, a ]) crank(get(L, "crank"));
    if (n == "rod")
        translate([ px, 0, z ]) rotate([ 0, 0, atan2(cp[1], cp[0] - px) ]) rod(get(L, "rod"));
    if (n == "clip")
        translate([ bx, 0, z ]) clip(cl);
    if (n == "syringe")
        translate([ 0, 0, get(L, "axis_z") ]) syringe(get(L, "syringe"), bx);
    if (n == "motor")
        translate([ get(L, "crank_x"), 0, get(L, "pocket") ]) motor(get(L, "motor"));
    if (n == "screws")
        screws(L, [ cp, [ px, 0 ] ]);
    // the core as it slides in from the back, sampled every 10 along the way: it meets the tube only
    if (n == "insert")
        for (dx = [0:10:200])
            translate([ dx, 0, 0 ])
            {
                frame(get(L, "frame"));
                translate([ get(L, "crank_x"), 0, get(L, "hub_z") ]) rotate([ 0, 0, a ]) crank(get(L, "crank"));
                translate([ px, 0, z ]) rotate([ 0, 0, atan2(cp[1], cp[0] - px) ]) rod(get(L, "rod"));
                translate([ bx, 0, z ]) clip(cl);
                translate([ get(L, "crank_x"), 0, get(L, "pocket") ]) motor(get(L, "motor"));
                screws(L, [ cp, [ px, 0 ] ]);
            }
    // a known hit: a cube inside the tube's floor
    if (n == "probe")
        translate([ get(B, "x")[0] - 1.5, 12, 5 ]) cube(1, center = true);
    // the tube itself, to check the lid against it
    if (n == "tube")
        body(B);
    // a known hit on the lid: a cube inside its top flat
    if (n == "lidprobe")
        translate([ 20, 0, get(B, "T") + get(B, "wall") + 1 ]) cube(1, center = true);
    // everything the frame carries at crank angle a, for the lid's path over it
    if (n == "core")
    {
        frame(get(L, "frame"));
        translate([ get(L, "crank_x"), 0, get(L, "hub_z") ]) rotate([ 0, 0, a ]) crank(get(L, "crank"));
        translate([ px, 0, z ]) rotate([ 0, 0, atan2(cp[1], cp[0] - px) ]) rod(get(L, "rod"));
        translate([ bx, 0, z ]) clip(cl);
        translate([ get(L, "crank_x"), 0, get(L, "pocket") ]) motor(get(L, "motor"));
        screws(L, [ cp, [ px, 0 ] ]);
        translate([ 0, 0, get(L, "axis_z") ]) syringe(get(L, "syringe"), bx);
    }
    // the syringe's path as it drops in from 60 above, through the window (sampled every 3: a hull of
    // the whole syringe would wedge between its flange and its nozzle)
    if (n == "loading")
        for (dz = [0:3:60])
            translate([ 0, 0, dz + get(L, "axis_z") ]) syringe(get(L, "syringe"), bx);
}

// lid_dx: the lid slid back this far from shut; below 0, no lid
lid_dx = 0;
// lid_lift: the lid raised off the roof it rests on, so resting contact is not counted
lid_lift = 0;
// just the lid, slid back, against other: for its path over the core
lid_only = false;

intersection()
{
    union()
    {
        if (!lid_only)
            body(B);
        if (!lid_only && other != "insert")
            cap(B);
        if (lid_dx >= 0)
            translate([ lid_dx, 0, lid_lift ]) lid(B);
    }
    placed(other);
}
