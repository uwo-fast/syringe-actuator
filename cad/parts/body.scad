/**
 * @file body.scad
 * @brief The body: a shell fitted round what the frame carries, a lid on its roof, and the cap on its back end
 * @author Cameron K. Brooks
 * @copyright 2026
 *
 * Frame: slides in from the back on two dovetail rails, up to the front wall; the cap's post holds it.
 * Syringe: in and out through a roof window over the barrel and the clip's travel; the barrel exits
 * the front wall through a slot.
 * Lid: slides on roof rails between a lip on the front wall and the cap. A bump under its back end
 * drops into a notch at the window's back edge when shut, and runs in a groove along the roof the
 * rest of its travel, so it never drags.
 *
 * Shell: a loft of sections along x. Narrow and shallow at the front (syringe, plate, clip), tapering
 * out to full width and motor depth where the crank turns. Each section is symmetric about the axis's
 * vertical plane, square on top (lid rails), chamfered at the bottom as far as the contents allow.
 * Neighbouring sections are hulled pairwise: equal ones make a prism, unequal ones a taper. The outside
 * is the inside grown by the wall, edge for edge, so the wall keeps its thickness.
 *
 * Coordinates: the frame's (x along the syringe axis, z = 0 at the frame's underside).
 * Printing: body on its open back end, walls near vertical; lid top down; cap outer face down.
 */

// clang-format off
include <../lib/struct.scad>;
include <frame.scad>;
// clang-format on

// A section's [W, B, c] for the [y, z] points pts: half-width, bottom, and the biggest bottom chamfer that keeps clr
// off every point, under a top at T.
function section_fit(pts, T, clr) = let(W = max([for (p = pts) p[0]]) + clr, B = min([for (p = pts) p[1]]) - clr,
                                        c = min([for (p = pts) W - B - (p[0] - p[1])]) -
                                            clr * sqrt(2))[W, B, max(0, min(c, W, T - B))];

// The half-width at x of the loft through stations [[x, [W, B, c]], ...], interpolated.
function loft_w(st, x) = let(i = max([for (k = [0:len(st) - 2]) if (st[k][0] <= x) k]), a = st[i],
                             b = st[i + 1]) a[1][0] +
                         (b[1][0] - a[1][0]) * (x - a[0]) / (b[0] - a[0]);

// front_pts, back_pts: [y, z] of what the frame carries at its extremes over a turn; front_pts only in
// front of the rod's spread, back_pts everywhere.
// rod: [x, y] of the rod's edge at its widest over a turn, sampled along x from the front.
// sweep_x: where the crank's sweep starts.
// x: [front, back] of the inside; the back is a minimum, grown to let the lid open.
// window: [end x, width]. plate: the frame's [w, dovetail, t]. frame_end: the plate's back end x.
// screw: the cap's screws; tap: their holes in the bosses. wire_z: the wire hole in the cap.
// clr: clearance round the frame's contents. slide: per side, dovetails in rails and lid in its rails.
// wall: shell wall; end_t: front wall and cap thickness.
// lid: [thickness, reach past the window's sides, reach past its end when shut].
// lid_grip: how far the lid flexes to pass the ridge behind its notch.
// mount_front, mount_top: 4 screw holes each, [across, along, centre], for a user's mount.
//   front: across y, up z, centred on the axis plane at a height over the plate's underside.
//   top: across y, along x, centred a distance in front of the back end, through the roof's
//   shoulders outboard of the lid rails, behind the crank's sweep. Same for every syringe.
//   layout() sets the front's spacing: the narrowest multiple of 10 that clears the widest snap
//   ring in the body's group.
// knockout: holes are blind from inside, stopping this short of the outer face; the user drills or
// punches out the ones they use.
// clang-format off
function body_spec(front_pts, back_pts, rod, sweep_x, x, window, axis_z, barrel_d, plate, frame_end, screw, tap,
                   wire_z, fit, clr = 2, slide = 0.3, wall = 2.5, end_t = 3, boss_d = 8, boss_l = 12, wire_d = 6,
                   lid = [2, 3, 3], lid_grip = 0.2, mount_front = [30, 10, 15], mount_top = [60, 20, 15],
                   knockout = 0.6) =
    let (T = max([for (p = back_pts) p[1]]) + clr,
         front = section_fit(front_pts, T, clr),
         back = section_fit(back_pts, T, clr),
         // narrow front: as far as the rod's edge keeps clr inside it, and no further than keeps the taper
         // within 45 degrees (the body prints upright); the full section starts clr before the crank's sweep
         x2 = sweep_x - clr,
         x1 = min(max([for (r = rod) if (r[1] + clr <= front[0]) r[0]]),
                  x2 - max(back[0] - front[0], front[1] - back[1])),
         lid_x = [x[0] + slide, window[0] + lid[2]],
         x_back = max(x[1], window[0] + lid_x[1] - lid_x[0] + slide + 1),
         stations = [[x[0] - end_t, front], [x1, front], [x2, back], [x_back, back]],
         // the cap's screws, on the back section's bottom chamfers, their bosses merging into the walls
         m = [back[0] - back[2] / 2, back[1] + back[2] / 2],
         k = (boss_d / 2 - 0.5) / sqrt(2))
    assert(x1 < x2, "the rod spreads past the narrow front only after the crank's sweep starts")
    assert(front[0] + wall - mount_front[0] / 2 - (get(screw, "clear") + 2 * fit) / 2 >= 1.5,
           "the front mounting holes come within 1.5 of the body's sides")
    assert(min([for (r = rod) if (r[0] >= x1 && r[0] <= x2) loft_w(stations, r[0]) - r[1]]) >= clr,
           "the taper does not clear the rod's swing")
    [
        ["name", "body"], ["T", T], ["stations", stations], ["front", front], ["back", back],
        ["x", [x[0], x_back]], ["window", window], ["axis_z", axis_z], ["barrel_d", barrel_d + 2 * clr],
        ["plate", plate], ["frame_end", frame_end], ["screw", screw], ["tap", tap], ["wire_z", wire_z], ["fit", fit],
        ["slide", slide], ["wall", wall], ["end_t", end_t], ["boss_d", boss_d], ["boss_l", boss_l], ["wire_d", wire_d],
        ["lid", lid], ["lid_x", lid_x], ["lid_grip", lid_grip], ["knockout", knockout],
        ["mount_front", [for (i = [-1, 1], j = [-1, 1]) [i * mount_front[0] / 2, mount_front[2] + j * mount_front[1] / 2]]],
        ["mount_top", [for (i = [-1, 1], j = [-1, 1]) [x_back - mount_top[2] + i * mount_top[1] / 2, j * mount_top[0] / 2]]],
        ["bosses", [for (side = [-1, 1]) [side * (m[0] - k), m[1] + k]]],
    ];
// clang-format on

// A section [W, B, c] under a top at T, grown by g all round: square at the top, chamfered c at the bottom corners.
module section_shape(sec, T, g = 0) offset(delta = g) polygon([
    [ -sec[0], T ], [ sec[0], T ], [ sec[0], sec[1] + sec[2] ], [ sec[0] - sec[2], sec[1] ],
    [ -sec[0] + sec[2], sec[1] ], [ -sec[0], sec[1] + sec[2] ]
]);

// The front wall's outer face in [y, z], where an adapter meets it: the front section grown by the wall,
// up to the top of the lid's stop lip. Growing a 45 degree chamfer by g lengthens each leg by g (2 - sqrt 2).
function front_face(s) = let(sec = get(s, "front"), g = get(s, "wall"), W = sec[0] + g, B = sec[1] - g,
                             c = sec[2] + g * (2 - sqrt(2)), top = get(s, "T") + g + get(s, "lid")[0])
    assert(sec[2] > 0, "front_face() takes a chamfered front section")[[ -W, top ], [ W, top ], [ W, B + c ],
                                                                       [ W - c, B ], [ -W + c, B ], [ -W, B + c ]];

// A 2D section in [y, z], extruded along x from x0 for len.
module along_x(x0, len) translate([ x0, 0, 0 ]) rotate([ 90, 0, 90 ]) linear_extrude(len) children();

// The loft through the spec's stations, grown by g, its end stations moved to x0 and x1; its top at top if given.
module loft(s, g, x0, x1, top = undef)
{
    st = get(s, "stations");
    n = len(st);
    ends = [for (i = [0:n - 1]) i == 0 ? [ x0, st[i][1] ] : i == n - 1 ? [ x1, st[i][1] ] : st[i]];
    for (i = [0:n - 2])
        // each station a 0.01 slab, the last one ending at its station rather than starting there
        hull() for (e = [ ends[i], ends[i + 1] ]) along_x(e[0] - (e == ends[n - 1] ? 0.01 : 0), 0.01)
            section_shape(e[1], is_undef(top) ? get(s, "T") : top, g);
}

// The +y rail's section: stands on the floor, holds the plate's edge from below, hooks over its dovetail.
// The plate's section, grown by slide, is cut from it; it reaches well down and is clipped to the shell.
// The lip's outer face slopes out at 45 degrees, so it meets the wall at a corner, not a sliver apart.
module rail_section(s)
{
    p = get(s, "plate");
    w = p[0];
    d = p[1];
    t = p[2];
    difference()
    {
        // the lower wall's outer face flares out at 45 degrees going down, square to the back's chamfered wall
        polygon([[w / 2 - 1, -100], [w / 2 + 1 + 100 - d - 5, -100], [w / 2 + 1, -d - 5], [w / 2 + d + 3, -3],
                 [w / 2 + d + 3 + t + 3, t], [w / 2 - 1, t]]);
        offset(delta = get(s, "slide")) polygon(plate_profile(w, d, t + 1));
    }
}

// The lid's edge and the rail face against it, from the roof up: land a, 45 degree bevel rising b, land to
// the top. No knife edge on either.
function lid_edge(t) = let(a = t / 4)[a, t - 2 * a];

// The lid's section: a plate on the roof, its edges bevelled under the rails' lips.
module lid_section(s)
{
    top = get(s, "T") + get(s, "wall");
    hb = get(s, "window")[1] / 2 + get(s, "lid")[1];
    t = get(s, "lid")[0];
    e = lid_edge(t);
    polygon([
        [ -hb, top ], [ hb, top ], [ hb, top + e[0] ], [ hb - e[1], top + e[0] + e[1] ], [ hb - e[1], top + t ],
        [ -hb + e[1], top + t ], [ -hb + e[1], top + e[0] + e[1] ], [ -hb, top + e[0] ]
    ]);
}

// The +y roof rail the lid slides in, from the lid's edge plus slide out to `out`; its foot sinks 1 into
// the roof.
module lid_rail_section(s, out)
{
    top = get(s, "T") + get(s, "wall");
    hb = get(s, "window")[1] / 2 + get(s, "lid")[1] + get(s, "slide");
    t = get(s, "lid")[0];
    e = lid_edge(t);
    polygon([[hb, top - 1], [out, top - 1], [out, top + t], [hb - e [1], top + t], [hb - e [1], top + e [0] + e [1]],
             [hb, top + e [0]]]);
}

// The detent bump's x when the lid is shut: under the middle of its back end, over the roof behind the window.
function bump_x(s) = get(s, "lid_x")[1] - 1.5;

// The lid, shut: its bump sits in the notch at the window's back edge; grooves near its front give a
// thumb grip.
module lid(s)
{
    lx = get(s, "lid_x");
    top = get(s, "T") + get(s, "wall");
    t = get(s, "lid")[0];
    h = get(s, "slide") + get(s, "lid_grip");
    difference()
    {
        union()
        {
            along_x(lx[0], lx[1] - lx[0]) lid_section(s);
            translate([ bump_x(s), 0, top ]) rotate([ 90, 0, 0 ]) linear_extrude(2, center = true)
                polygon([ [ -1.5, 0.5 ], [ 0, -h ], [ 1.5, 0.5 ] ]);
        }
        for (i = [0:3])
            translate([ lx[0] + 8 + 4 * i, -get(s, "window")[1] / 2 + 2, top + t - 0.8 ])
                cube([ 1.5, get(s, "window")[1] - 4, 1 ]);
    }
}

// The body: shell and cuts, then the lid rails, added after the cuts so no cutter reaches their lips.
// The rails run out to the shell's sides, filling the roof's shoulders flush over the wider back: no fin
// to snap, no inside corner to clean. Mounting holes last, sealed by a knockout skin.
module body(s)
{
    x = get(s, "x");
    end_t = get(s, "end_t");
    wall = get(s, "wall");
    t = get(s, "lid")[0];
    d = get(get(s, "screw"), "clear") + 2 * get(s, "fit");
    difference()
    {
        union()
        {
            body_shell(s);
            intersection()
            {
                along_x(x[0] - end_t, x[1] - x[0] + end_t) for (side = [ 0, 1 ]) mirror([ side, 0 ])
                    lid_rail_section(s, get(s, "back")[0] + wall + 1);
                loft(s, wall, x[0] - end_t, x[1], get(s, "T") + t + 1);
            }
        }
        // blind from inside, knockout short of the outer face
        k = get(s, "knockout");
        for (h = get(s, "mount_front"))
            translate([ x[0] - end_t + k, h[0], h[1] ]) rotate([ 0, 90, 0 ]) cylinder(d = d, h = end_t - k + 1);
        for (h = get(s, "mount_top"))
            translate([ h[0], h[1], get(s, "T") - 1 ]) cylinder(d = d, h = wall + t - k + 1);
    }
}

module body_shell(s)
{
    x = get(s, "x");
    end_t = get(s, "end_t");
    wall = get(s, "wall");
    win = get(s, "window");
    z = get(s, "axis_z");
    bd = get(s, "barrel_d");
    T = get(s, "T");
    difference()
    {
        union()
        {
            difference()
            {
                loft(s, wall, x[0] - end_t, x[1]);
                loft(s, 0, x[0], x[1] + 1);
            }
            intersection()
            {
                union()
                {
                    along_x(x[0] - 1, x[1] - x[0] + 1) for (side = [ 0, 1 ]) mirror([ side, 0 ]) rail_section(s);
                    for (b = get(s, "bosses"))
                        along_x(x[1] - get(s, "boss_l"), get(s, "boss_l")) hull()
                        {
                            // a wide foot along the chamfered wall, so the boss's flanks meet it steeply
                            translate(b) circle(d = get(s, "boss_d"));
                            for (k = [ -1, 1 ])
                                translate(b + ([ sign(b[0]), -1 ] * 5 + [ sign(b[0]), 1 ] * k * get(s, "boss_d")) /
                                                  sqrt(2)) circle(d = 1);
                        }
                }
                loft(s, wall / 2, x[0] - end_t, x[1]);
            }
            // the front wall and the lip on it the lid stops against; the barrel's slot cuts through it
            along_x(x[0] - end_t, end_t) polygon(front_face(s));
        }
        // the window in the roof over the barrel and the clip's travel, and the barrel's slot through the front wall
        translate([ x[0], -win[1] / 2, T - 1 ]) cube([ win[0] - x[0], win[1], 100 ]);
        along_x(x[0] - end_t - 1, end_t + 2) translate([ 0, z ]) circle(d = bd);
        translate([ x[0] - end_t - 1, -bd / 2, z ]) cube([ end_t + 2, bd, 100 ]);
        // detent: notch under the bump when shut, a ridge behind it, then a groove the bump runs free in
        d = get(s, "slide") + get(s, "lid_grip") + 0.3;
        translate([ 0, -1.5, T + wall - d ])
        {
            translate([ bump_x(s) - 2, 0, 0 ]) cube([ 4, 3, d + 1 ]);
            translate([ bump_x(s) + 3.5, 0, 0 ]) cube([ x[1] - bump_x(s), 3, d + 1 ]);
        }
        // the cap screws' holes, blind, a millimetre short of the bosses' far ends
        for (b = get(s, "bosses"))
            along_x(x[1] - get(s, "boss_l") + 1, get(s, "boss_l")) translate(b) circle(d = get(s, "tap"));
    }
}

// The cap on the back end: screwed to the bosses, wires out through its hole. Its post has the plate's
// section, so it slides in the same rails, squares the cap, and pushes the plate against the front wall.
// It also closes the lid rails, so the lid stops against it.
module cap(s)
{
    x = get(s, "x");
    end_t = get(s, "end_t");
    p = get(s, "plate");
    fit = get(s, "fit");
    sc = get(s, "screw");
    T = get(s, "T");
    wall = get(s, "wall");
    back_out = get(s, "back")[0] + wall;
    difference()
    {
        union()
        {
            along_x(x[1], end_t)
            {
                section_shape(get(s, "back"), T, wall);
                translate([ -back_out, T + wall - 1 ]) square([ 2 * back_out, get(s, "lid")[0] + 1 ]);
            }
            post = get(s, "frame_end") + get(s, "slide");
            along_x(post, x[1] - post + 1) polygon(plate_profile(p[0], p[1], p[2]));
        }
        along_x(x[1] - 1, end_t + 2)
        {
            for (b = get(s, "bosses"))
                translate(b) circle(d = get(sc, "clear") + 2 * fit);
            translate([ 0, get(s, "wire_z") ]) circle(d = get(s, "wire_d"));
        }
    }
}
