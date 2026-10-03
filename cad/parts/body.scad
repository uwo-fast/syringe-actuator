/**
 * @file body.scad
 * @brief The body: a shell fitted round what the frame carries, a lid on its roof, and the cap on its back end
 * @author Cameron K. Brooks
 * @copyright 2026
 *
 * The frame slides in from the back on two rails that take its dovetailed edges, up to the front wall, and the cap's
 * post holds it there. The syringe goes in and out through a window in the roof over its barrel and the clip's travel;
 * the barrel passes the front wall through a slot. A lid slides along rails on the roof, between a lip on the front
 * wall and the cap, to close the window, its edges resting on the roof either side of it. A bump under the middle of
 * its back end drops into a notch at the window's back edge when it is shut, and runs in a groove along the roof's
 * middle the rest of its travel so it never drags.
 *
 * The shell is a loft of sections along x: narrow and shallow at the front, where there is only the syringe, the plate
 * and the clip, tapering out to full width and the motor's depth where the crank turns. Each section is symmetric
 * about the syringe axis's vertical plane, square at the top, where the lid's rails run, and chamfered at the bottom as
 * far as its contents allow. Neighbouring sections are hulled pairwise, so equal ones make a prism and unequal ones a
 * taper; the outside's sections are the inside's grown by the wall, edge for edge, so the hulls' faces stay parallel
 * and the wall its thickness.
 *
 * Coordinates are the frame's: x along the syringe axis, z = 0 at the frame's underside. The body prints standing on
 * its open back end, its walls near vertical; the lid prints top down; the cap outer face down.
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

// front_pts, back_pts: [y, z] of what the frame carries, at its extremes over a turn, in front of the rod's spread and
// everywhere. rod: [x, y] of the rod's edge at its widest over a turn, sampled along x from the front. sweep_x: where
// the crank's sweep starts. x: [front, back] of the inside, the back at least; it grows to take the lid open. window:
// [its end's x, its width]. plate: [w, dovetail, t] of the frame's plate. frame_end: the plate's back end's x. screw:
// the cap's screws; tap: their holes in the bosses. wire_z: the wires' hole in the cap. clr: round the frame's
// contents. slide: per side, the dovetails in the rails, and the lid in its rails. wall, end_t: the shell's wall and
// its front wall's and cap's thickness. lid: [thickness, its reach past the window's sides, its reach past the
// window's end when shut]. lid_grip: how far the lid flexes to pass the ridge behind its notch.
// clang-format off
function body_spec(front_pts, back_pts, rod, sweep_x, x, window, axis_z, barrel_d, plate, frame_end, screw, tap,
                   wire_z, fit, clr = 2, slide = 0.3, wall = 2.5, end_t = 3, boss_d = 8, boss_l = 12, wire_d = 6,
                   lid = [2, 3, 3], lid_grip = 0.2) =
    let (T = max([for (p = back_pts) p[1]]) + clr,
         front = section_fit(front_pts, T, clr),
         back = section_fit(back_pts, T, clr),
         // the narrow front runs as far as the rod's edge keeps clr inside it, but no further than keeps the taper
         // within 45 degrees of the body's axis, which is upright as it prints; the full section starts clr before
         // the crank's sweep
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
    assert(min([for (r = rod) if (r[0] >= x1 && r[0] <= x2) loft_w(stations, r[0]) - r[1]]) >= clr,
           "the taper does not clear the rod's swing")
    [
        ["name", "body"], ["T", T], ["stations", stations], ["front", front], ["back", back],
        ["x", [x[0], x_back]], ["window", window], ["axis_z", axis_z], ["barrel_d", barrel_d + 2 * clr],
        ["plate", plate], ["frame_end", frame_end], ["screw", screw], ["tap", tap], ["wire_z", wire_z], ["fit", fit],
        ["slide", slide], ["wall", wall], ["end_t", end_t], ["boss_d", boss_d], ["boss_l", boss_l], ["wire_d", wire_d],
        ["lid", lid], ["lid_x", lid_x], ["lid_grip", lid_grip],
        ["bosses", [for (side = [-1, 1]) [side * (m[0] - k), m[1] + k]]],
    ];
// clang-format on

// A section [W, B, c] under a top at T, grown by g all round: square at the top, chamfered c at the bottom corners.
module section_shape(sec, T, g = 0) offset(delta = g) polygon([
    [ -sec[0], T ], [ sec[0], T ], [ sec[0], sec[1] + sec[2] ], [ sec[0] - sec[2], sec[1] ],
    [ -sec[0] + sec[2], sec[1] ], [ -sec[0], sec[1] + sec[2] ]
]);

// A 2D section in [y, z], extruded along x from x0 for len.
module along_x(x0, len) translate([ x0, 0, 0 ]) rotate([ 90, 0, 90 ]) linear_extrude(len) children();

// The loft through the spec's stations, grown by g, its end stations moved to x0 and x1.
module loft(s, g, x0, x1)
{
    st = get(s, "stations");
    n = len(st);
    ends = [for (i = [0:n - 1]) i == 0 ? [ x0, st[i][1] ] : i == n - 1 ? [ x1, st[i][1] ] : st[i]];
    for (i = [0:n - 2])
        // each station a 0.01 slab, the last one ending at its station rather than starting there
        hull() for (e = [ ends[i], ends[i + 1] ]) along_x(e[0] - (e == ends[n - 1] ? 0.01 : 0), 0.01)
            section_shape(e[1], get(s, "T"), g);
}

// One rail's section, the +y one: it stands on the floor, holds the plate's edge from below, and hooks over its
// dovetailed foot; the plate's section, grown by slide, is cut from it. It reaches well down and is clipped to the
// shell; the lip's outer face slopes out at 45 degrees, so where the wall moves out the two meet at a corner rather
// than running side by side a sliver apart.
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

// The lid's edge, and the rail's face against it, from the roof up: a land of a, a 45 degree bevel rising b, and a land
// to the top, so neither the lid's edge nor the rail's lip comes to a knife edge.
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

// The +y rail on the roof the lid slides in, from the lid's edge, with slide, out to the narrow front's side; its foot
// sinks 1 into the roof outside the lid's edge.
module lid_rail_section(s)
{
    top = get(s, "T") + get(s, "wall");
    hb = get(s, "window")[1] / 2 + get(s, "lid")[1] + get(s, "slide");
    t = get(s, "lid")[0];
    out = get(s, "front")[0] + get(s, "wall");
    e = lid_edge(t);
    polygon([[hb, top - 1], [out, top - 1], [out, top + t], [hb - e [1], top + t], [hb - e [1], top + e [0] + e [1]],
             [hb, top + e [0]]]);
}

// The detent bump's x when the lid is shut: under the middle of its back end, over the roof behind the window.
function bump_x(s) = get(s, "lid_x")[1] - 1.5;

// The lid, shut: a bump under the middle of its back end sits in a notch at the window's back edge, and grooves across
// its top near the front give a thumb purchase to push it back.
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

// The body: the shell and its cuts, then the lid's rails, which go on after the cuts so no cutter reaches their lips.
module body(s)
{
    x = get(s, "x");
    body_shell(s);
    along_x(x[0] - get(s, "end_t"), x[1] - x[0] + get(s, "end_t")) for (side = [ 0, 1 ]) mirror([ side, 0 ])
        lid_rail_section(s);
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
    out = get(s, "front")[0] + wall;
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
            // the front wall's lip the lid stops against; the barrel's slot cuts through it
            translate([ x[0] - end_t, -out, T + wall - 1 ]) cube([ end_t, 2 * out, get(s, "lid")[0] + 1 ]);
        }
        // the window in the roof over the barrel and the clip's travel, and the barrel's slot through the front wall
        translate([ x[0], -win[1] / 2, T - 1 ]) cube([ win[0] - x[0], win[1], 100 ]);
        along_x(x[0] - end_t - 1, end_t + 2) translate([ 0, z ]) circle(d = bd);
        translate([ x[0] - end_t - 1, -bd / 2, z ]) cube([ end_t + 2, bd, 100 ]);
        // the detent: a notch under the bump when shut, running into the window's back edge, a ridge behind it, then
        // a groove along the roof's middle the bump runs free in
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

// The cap, in place on the back end: screwed to the bosses, the wires out through its hole. Its post is the plate's own
// section, so it slides into the same rails, squares the cap onto the body and bears on the plate's whole back edge,
// holding it against the front wall. It closes the lid's rails too, so the lid stops against it.
module cap(s)
{
    x = get(s, "x");
    end_t = get(s, "end_t");
    p = get(s, "plate");
    fit = get(s, "fit");
    sc = get(s, "screw");
    T = get(s, "T");
    wall = get(s, "wall");
    out = get(s, "front")[0] + wall;
    difference()
    {
        union()
        {
            along_x(x[1], end_t)
            {
                section_shape(get(s, "back"), T, wall);
                translate([ -out, T + wall - 1 ]) square([ 2 * out, get(s, "lid")[0] + 1 ]);
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
