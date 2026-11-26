/**
 * @file clip.scad
 * @brief The plunger clip: a cup the push-button drops into, and a tongue out to the rod pin
 * @author Cameron K. Brooks
 * @copyright 2026
 *
 * The push-button drops in from above, and the plunger passes through a slot in the front wall. The
 * front wall pulls and the back wall pushes.
 * The sled runs between the frame rails, which take the side load from the rod and keep the clip
 * square; the plunger carries only the stroke load. The rod lies on the tongue and turns on its boss.
 * Above the axis, the side walls of the cup are free of the end walls; lips on top snap over the
 * push-button, so it stays in whichever way up the unit is.
 * x = 0 at the front face of the push-button, z = 0 on the syringe axis (the top of the tongue).
 * Prints in the orientation shown.
 */

include <../lib/struct.scad>;

// tap: self-tapping hole for the pin screw. boss: the pin boss [d, h].
// end_d: diameter of the round end of the tongue, equal to the rod width.
// sled: [extension past the pin (how far the rails keep it square), depth of its top below the rod].
// grip: per side, how far the lips reach over the push-button. clear: back wall to the end of the rod.
function clip_spec(syringe, tap, fit, wall, boss, end_d, sled, grip = 0.15, clear = 1) =
    let (
        r = get(syringe, "button_d") / 2 + fit,
        back = get(syringe, "button_t") + fit + wall,
        pin_x = back + clear + end_d / 2
    ) [
            ["name", "plunger clip"],
            ["syringe", syringe],
            ["tap", tap],
            ["fit", fit],
            ["boss", boss],
            ["end_d", end_d],
            ["back", back],
            ["pin_x", pin_x],
            ["front", -fit - wall],
            ["sled", sled],
            ["grip", grip],
            ["sled_end", pin_x + sled[0]],
            ["half_w", r + wall],
            ["top", r],
    ];

module clip(s) {
    sy = get(s, "syringe");
    fit = get(s, "fit");
    back = get(s, "back");
    pin_x = get(s, "pin_x");
    front = get(s, "front");
    top = get(s, "top");
    hw = get(s, "half_w");
    bottom = -hw;
    span = get(sy, "plunger_span") / 2 + fit;
    boss = get(s, "boss");
    difference() {
        union() {
            translate([front, -hw, bottom]) cube([back - front, 2 * hw, top - bottom]);
            translate([back - 1, 0, bottom]) linear_extrude(-bottom) hull() {
                        translate([0, -get(s, "end_d") / 2]) square([1, get(s, "end_d")]);
                        translate([pin_x - back + 1, 0]) circle(d=get(s, "end_d"));
                    }
            translate([pin_x, 0, -1]) cylinder(d=boss[0], h=boss[1] + 1);
            translate([front, -hw, bottom]) cube([get(s, "sled_end") - front, 2 * hw, -get(s, "sled")[1] - bottom]);
        }
        translate([-fit, -top, -top]) cube([get(sy, "button_t") + 2 * fit, 2 * top, 2 * top + 1]);
        translate([front - 1, -span, -span]) cube([-front - fit + 2, 2 * span, top + span + 1]);
        // slits separate the side walls from the end walls above the axis, so they flex past the push-button
        for (side = [-1, 1])
            translate([front - 1, side > 0 ? top - 0.6 : -top, 0]) cube([back - front + 2, 0.6, top + 1]);
        translate([pin_x, 0, bottom - 1]) cylinder(d=get(s, "tap"), h=-bottom + boss[1] + 2);
    }
    // the lips, near the tops of the side walls. A polyhedron, not an extruded polygon: 2D polygons snap
    // to a grid, which leaves a sliver against the wall when top is off the grid (5.3 on the 1 mL).
    for (side = [-1, 1])
    {
        yz = [
            [side * (top + 0.5), top - 3],
            [side * top, top - 2.5],
            [side * (top - fit - get(s, "grip")), top - 1],
            [side * top, top],
            [side * (top + 0.5), top],
        ];
        cw = side > 0 ? yz : [for (i = [len(yz) - 1:-1:0]) yz[i]]; // clockwise seen from +x
        n = len(cw);
        polyhedron(
            points=[for (x = [-fit, get(sy, "button_t") + fit]) for (p = cw) [x, p[0], p[1]]],
            faces=concat(
                [[for (i = [0:n - 1]) n + i]], [[for (i = [n - 1:-1:0]) i]],
                [for (i = [0:n - 1]) [i, (i + 1) % n, (i + 1) % n + n, i + n]]
            )
        );
    }
}
