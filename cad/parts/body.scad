/**
 * @file body.scad
 * @brief The body: an octagonal tube the frame slides into, and the cap that closes its back end
 * @author Cameron K. Brooks
 * @copyright 2026
 *
 * The frame slides in from the back on two rails that take its dovetailed edges, up to the front wall, and the cap's
 * post holds it there. The syringe goes in and out through a window in the roof over its barrel and the clip's travel;
 * the barrel passes the front wall through a slot. A lid inside the roof closes the window: it rides on two ledges and
 * slides back under the roof to open, up to the cap. Its front end hangs down to close the slot over the barrel, and a
 * wedge on it, tapered to fit the slot tight only in the last few millimetres, holds it shut.
 *
 * Coordinates are the frame's: x along the syringe axis, z = 0 at the frame's underside. The body
 * prints on its bottom flat; the cap prints outer face down.
 */

// clang-format off
include <../lib/struct.scad>;
// clang-format on

// Half the width across flats a regular octagon, flats on y and z, centred at z = zc, needs to hold
// every [y, z] in pts.
function octagon_need(pts,
                      zc) = max([for (p = pts) max(abs(p[0]), abs(p[1] - zc), (abs(p[0]) + abs(p[1] - zc)) / sqrt(2))]);

// pts: [y, z] of what the frame carries, at its extremes over a turn. x: [front, back] of the inside, the back at
// least; it grows to take the lid open. window: [its end's x, its width]. plate: [w, dovetail, t] of the frame's plate.
// frame_end: the plate's back end's x. screw: the cap's screws; tap: their holes in the bosses. wire_z: the wires' hole
// in the cap. clr: round the frame's contents. slide: per side, the dovetails in the rails, and the lid between the
// roof and its ledges. wall, end_t: the tube's wall and its front wall's and cap's thickness. lid: [thickness, its
// reach past the window's sides, its reach past the window's end when shut]. lid_grip: per side, how much wider than
// the barrel's slot the lid's wedge ends, for friction that holds it shut.
// clang-format off
function body_spec(pts, x, window, axis_z, barrel_d, plate, frame_end, screw, tap, wire_z, fit,
                   clr = 2, slide = 0.3, wall = 2.5, end_t = 3, boss_d = 8, boss_l = 12, wire_d = 6,
                   lid = [2, 4, 3], lid_grip = 0.1) =
    let (zcs = [for (z = [-40:0.25:40]) z],
         needs = [for (z = zcs) octagon_need(pts, z)],
         least = min(needs),
         zc = [for (i = [0:len(zcs) - 1]) if (needs[i] == least) zcs[i]][0],
         a = least + clr,
         // the lid, shut, from just behind the front wall to past the window's end; open, all of it
         // behind the window, under the roof
         lid_x = [x[0] + slide, window[0] + lid[2]],
         back = max(x[1], window[0] + lid_x[1] - lid_x[0] + slide + 1),
         // the lid's edges, and the ledges' tops under them
         lid_z = zc + (a - slide) * sqrt(2) - (window[1] / 2 + lid[1]),
         ledge_in = max(window[1] / 2 + 0.5, (a - slide - lid[0]) * sqrt(2) - (lid_z - zc) - 0.5)) [
        ["name", "body"], ["a", a], ["zc", zc], ["x", [x[0], back]], ["window", window], ["axis_z", axis_z],
        ["barrel_d", barrel_d + 2 * clr], ["plate", plate], ["frame_end", frame_end], ["screw", screw],
        ["tap", tap], ["wire_z", wire_z], ["fit", fit], ["slide", slide], ["wall", wall], ["end_t", end_t],
        ["boss_d", boss_d], ["boss_l", boss_l], ["wire_d", wire_d],
        ["lid", lid], ["lid_x", lid_x], ["lid_z", lid_z], ["ledge_in", ledge_in], ["lid_grip", lid_grip],
        // the lid's front end hangs down to here, clear of the tallest thing it slides back over
        ["plug_z", max([for (p = pts) p[1]]) + 1],
        // the cap's screws, in the tube's lower diagonal corners, their bosses merging into its walls
        ["bosses", [for (side = [-1, 1]) [side, -1] * (a - boss_d / 2 + 0.5) / sqrt(2) + [0, zc]]],
    ];
// clang-format on

// The octagon, half a across flats, centred at z = zc, in the [y, z] plane.
module octagon(a, zc) translate([ 0, zc ]) rotate(22.5) circle(r = a / cos(22.5), $fn = 8);

// A 2D section in [y, z], extruded along x from x0 for len.
module along_x(x0, len) translate([ x0, 0, 0 ]) rotate([ 90, 0, 90 ]) linear_extrude(len) children();

// One rail's section, the +y one: it stands on the tube's floor, holds the plate's edge from below,
// and hooks over its dovetailed foot; the plate's section, grown by slide, is cut from it.
module rail_section(s)
{
    p = get(s, "plate");
    w = p[0];
    d = p[1];
    t = p[2];
    floor_z = get(s, "zc") - get(s, "a") - 1;
    difference()
    {
        polygon([[w / 2 - 1, floor_z], [w / 2 + 1, floor_z], [w / 2 + 1, -d - 5], [w / 2 + d + 3, -3],
                 [w / 2 + d + 3, t], [w / 2 - 1, t]]);
        offset(delta = get(s, "slide")) polygon(
            [ [ -w / 2 - d, 0 ], [ w / 2 + d, 0 ], [ w / 2, d ], [ w / 2, t + 1 ], [ -w / 2, t + 1 ], [ -w / 2, d ] ]);
    }
}

// One ledge's section, the +y one: a shelf on the roof's diagonal under the lid's edge, its
// underside at 45 degrees so it prints.
module ledge_section(s)
{
    a = get(s, "a");
    zc = get(s, "zc");
    top = get(s, "lid_z") - get(s, "slide");
    y_in = get(s, "ledge_in");
    y_out = a * sqrt(2) - (top - zc) + 2;
    intersection()
    {
        polygon([[y_in, top], [y_out, top], [y_out, top - (y_out - y_in)]]);
        octagon(a + get(s, "wall") / 2, zc);
    }
}

// The lid's section: a channel following the roof's top flat and upper diagonals inside it, its edges
// at lid_z.
module lid_section(s)
{
    a = get(s, "a") - get(s, "slide");
    zc = get(s, "zc");
    intersection()
    {
        difference()
        {
            octagon(a, zc);
            octagon(a - get(s, "lid")[0], zc);
        }
        translate([ -2 * a, get(s, "lid_z") ]) square([ 4 * a, 2 * a ]);
    }
}

// The lid, shut: its front end hangs down to close the slot over the barrel, a wedge on it runs into the slot through
// the front wall, and grooves across its top near the window's end give a fingertip purchase to slide it back.
module lid(s)
{
    a = get(s, "a") - get(s, "slide");
    zc = get(s, "zc");
    lx = get(s, "lid_x");
    win = get(s, "window");
    difference()
    {
        union()
        {
            along_x(lx[0], lx[1] - lx[0]) lid_section(s);
            along_x(lx[0], 2) intersection()
            {
                translate([ -get(s, "barrel_d") / 2 - 2, get(s, "plug_z") ])
                    square([ get(s, "barrel_d") + 4, zc + a - get(s, "plug_z") ]);
                octagon(a, zc);
            }
            // the wedge: narrower than the slot at the front face, lid_grip wider a side by its back
            hull()
            {
                bd = get(s, "barrel_d");
                h = zc + a - 0.5 - get(s, "plug_z"); // below the lid's top, so it merges, not meets
                translate([ get(s, "x")[0] - get(s, "end_t") + 0.3, -bd / 2 + 0.3, get(s, "plug_z") ])
                    cube([ 0.01, bd - 0.6, h ]);
                // full width 0.5 inside the front wall's inner face, where the slot's sides grip it, and on
                // into the hanging front end
                for (wx = [ get(s, "x")[0] - 0.5, lx[0] + 1 ])
                    translate([ wx, -bd / 2 - get(s, "lid_grip"), get(s, "plug_z") ])
                        cube([ 0.01, bd + 2 * get(s, "lid_grip"), h ]);
            }
        }
        for (i = [0:3])
            translate([ win[0] - 8 - 5 * i, -a * tan(22.5) + 3, zc + a - 0.8 ]) cube([ 1.5, 2 * a * tan(22.5) - 6, 1 ]);
    }
}

module body(s)
{
    a = get(s, "a");
    zc = get(s, "zc");
    x = get(s, "x");
    wall = get(s, "wall");
    end_t = get(s, "end_t");
    win = get(s, "window");
    z = get(s, "axis_z");
    bd = get(s, "barrel_d");
    difference()
    {
        union()
        {
            difference()
            {
                along_x(x[0] - end_t, x[1] - x[0] + end_t) octagon(a + wall, zc);
                along_x(x[0], x[1] - x[0] + 1) octagon(a, zc);
            }
            along_x(x[0] - 1, x[1] - x[0] + 1) for (side = [ 0, 1 ]) mirror([ side, 0 ])
            {
                rail_section(s);
                ledge_section(s);
            }
            for (b = get(s, "bosses"))
                along_x(x[1] - get(s, "boss_l"), get(s, "boss_l")) intersection()
                {
                    hull()
                    {
                        translate(b) circle(d = get(s, "boss_d"));
                        translate(b * 2 - [ 0, zc ] * 2 + [ 0, zc ]) circle(d = get(s, "boss_d"));
                    }
                    octagon(a + wall / 2, zc);
                }
        }
        // the window in the roof over the barrel and the clip's travel, and the barrel's slot through the
        // front wall
        translate([ x[0], -win[1] / 2, z ]) cube([ win[0] - x[0], win[1], 100 ]);
        along_x(x[0] - end_t - 1, end_t + 2) translate([ 0, z ]) circle(d = bd);
        translate([ x[0] - end_t - 1, -bd / 2, z ]) cube([ end_t + 2, bd, 100 ]);
        for (b = get(s, "bosses"))
            along_x(x[1] - get(s, "boss_l") - 1, get(s, "boss_l") + 2) translate(b) circle(d = get(s, "tap"));
    }
}

// The cap, in place on the tube's back end: screwed to the bosses, its post holding the plate's
// back end against the front wall, the wires out through its hole.
module cap(s)
{
    x = get(s, "x");
    end_t = get(s, "end_t");
    p = get(s, "plate");
    fit = get(s, "fit");
    sc = get(s, "screw");
    difference()
    {
        union()
        {
            along_x(x[1], end_t) octagon(get(s, "a") + get(s, "wall"), get(s, "zc"));
            post = get(s, "frame_end") + get(s, "slide");
            translate([ post, -p[0] / 4, 0.5 ]) cube([ x[1] - post + 1, p[0] / 2, p[2] - 1 ]);
        }
        along_x(x[1] - 1, end_t + 2)
        {
            for (b = get(s, "bosses"))
                translate(b) circle(d = get(sc, "clear") + 2 * fit);
            translate([ 0, get(s, "wire_z") ]) circle(d = get(s, "wire_d"));
        }
    }
}
