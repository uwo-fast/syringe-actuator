/**
 * @file frame.scad
 * @brief The frame: a plate holding the syringe at one end and the motor at the other
 * @author Cameron K. Brooks
 * @copyright 2026
 *
 * The barrel's flange drops into a slot, whose walls take the push and the pull, and the barrel
 * snaps into a ring in front of it. Two rails either side of the clip's travel guide its sled. The motor's gearbox
 * goes up into a pocket under the plate, located by its bushing and held by two M1.6 screws from
 * above, counterbored under the crank's hub; the motor hangs below the plate.
 *
 * x along the syringe axis, 0 at the flange's rear face, the nozzle towards -x; z = 0 at the plate's
 * underside. Prints as it stands.
 */

// clang-format off
include <../lib/struct.scad>;
// clang-format on

// axis_z: the syringe axis's height; crank_x: the motor shaft's x. ring: [gap to the flange
// block, length, wall] of the snap ring; snap: its opening, as a fraction of the barrel's diameter.
// chamfer: the motor pocket's mouth. guide: [[x from, x to], half the gap between the rails, their
// top's z].
// clang-format off
function frame_spec(syringe, motor, screw, fit, wall, plate_t, pocket, axis_z, crank_x, guide,
                    ring = [15, 6, 2], snap = 0.8, chamfer = 0.5) =
    let (block = [-get(syringe, "flange_t") - fit - wall, fit + wall],
         ring_x = block[0] - ring[0] - ring[1]) [
        ["name", "frame"], ["syringe", syringe], ["motor", motor], ["screw", screw], ["fit", fit],
        ["plate_t", plate_t], ["pocket", pocket], ["axis_z", axis_z], ["crank_x", crank_x],
        ["ring", ring], ["snap", snap], ["chamfer", chamfer], ["guide", guide], ["wall", wall], ["block", block], ["ring_x", ring_x],
        ["w", get(syringe, "flange")[0] + 2 * fit],
        ["x", [ring_x, crank_x + get(motor, "h") / 2 + fit + wall]],
    ];
// clang-format on

// A cylinder of diameter d along +x from x = 0 to len, on the syringe axis.
module on_axis(s, d, len) translate([ 0, 0, get(s, "axis_z") ]) rotate([ 0, 90, 0 ]) cylinder(d = d, h = len);

// A slot of width w on the syringe axis, round at the bottom and open to the top, from x = 0 to len.
module u_cut(s, w, len)
{
    on_axis(s, w, len);
    translate([ 0, -w / 2, get(s, "axis_z") ]) cube([ len, w, 100 ]);
}

module frame(s)
{
    sy = get(s, "syringe");
    m = get(s, "motor");
    sc = get(s, "screw");
    fit = get(s, "fit");
    t = get(s, "plate_t");
    z = get(s, "axis_z");
    x = get(s, "x");
    w = get(s, "w");
    block = get(s, "block");
    ring = get(s, "ring");
    ring_x = get(s, "ring_x");
    od = get(sy, "barrel_od") + 2 * fit;
    ring_d = od + 2 * ring[2];
    ft = get(sy, "flange_t");
    flange = get(sy, "flange") + [ 2, 2 ] * fit;
    cx = get(s, "crank_x");
    chamfer = get(s, "chamfer");
    difference()
    {
        union()
        {
            translate([ x[0], -w / 2, 0 ]) cube([ x[1] - x[0], w, t ]);
            translate([ block[0], -w / 2, t - 1 ]) cube([ block[1] - block[0], w, z - t + 3 ]);
            translate([ ring_x, 0, 0 ]) on_axis(s, ring_d, ring[1]);
            translate([ ring_x, -ring_d / 2, t - 1 ]) cube([ ring[1], ring_d, z - t + 1 ]);
            guide = get(s, "guide");
            for (side = [ -1, 1 ])
                translate([ guide[0][0], side > 0 ? guide[1] : -guide[1] - get(s, "wall"), t - 1 ])
                    cube([ guide[0][1] - guide[0][0], get(s, "wall"), guide[2] - t + 1 ]);
        }
        // the flange's slot, open at the sides, then the barrel through the front wall and the plunger
        // through the back
        translate([ -ft - fit, -w / 2 - 1, z - flange[1] / 2 ]) cube([ ft + 2 * fit, w + 2, 100 ]);
        translate([ block[0] - 1, 0, 0 ]) u_cut(s, od, -block[0]);
        translate([ fit - 1, 0, 0 ]) u_cut(s, get(sy, "plunger_span") + 2 * fit, block[1] - fit + 2);
        // the snap ring's bore and opening
        translate([ ring_x - 1, 0, 0 ]) on_axis(s, od, ring[1] + 2);
        translate([ ring_x - 1, -get(s, "snap") * od / 2, z ]) cube([ ring[1] + 2, get(s, "snap") * od, 100 ]);
        // the motor: gearbox pocket from below, bushing and shaft through, screws counterbored from above
        pocket = [ get(m, "h"), get(m, "w") ] + [ 2, 2 ] * fit;
        translate([ cx - pocket[0] / 2, -pocket[1] / 2, -1 ]) cube([ pocket[0], pocket[1], get(s, "pocket") + 1 ]);
        // the pocket's mouth chamfered, against the first layer's squash
        translate([ cx, 0, -1 ]) linear_extrude(1 + chamfer, scale = [
            pocket[0] / (pocket[0] + 2 * chamfer + 2), pocket[1] / (pocket[1] + 2 * chamfer + 2)
        ]) square(pocket + [ 2, 2 ] * (chamfer + 1), center = true);
        translate([ cx, 0, -1 ]) cylinder(d = get(m, "bushing_d") + 2 * fit, h = t + 2);
        for (y = [ -1, 1 ] * get(m, "hole_pitch") / 2)
            translate([ cx, y, 0 ])
            {
                translate([ 0, 0, -1 ]) cylinder(d = get(sc, "clear") + 2 * fit, h = t + 2);
                translate([ 0, 0, t - get(sc, "head_h") - 0.2 ])
                    cylinder(d = get(sc, "head_d") + 2 * fit, h = get(sc, "head_h") + 1.2);
            }
    }
}
