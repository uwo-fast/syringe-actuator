/**
 * @file frame.scad
 * @brief The frame: a plate holding the syringe at one end and the motor at the other
 * @author Cameron K. Brooks
 * @copyright 2026
 *
 * Syringe: the flange drops into a slot whose walls take push and pull; the barrel snaps into a
 * ring in front of it, past two thin arms.
 * Clip: its sled runs between two rails along its travel.
 * Motor: gearbox up into a pocket under the plate, located by its bushing, held by two screws from
 * above, counterbored under the crank's hub; the motor hangs below.
 * Plate: long edges dovetailed, for the body's rails.
 *
 * x along the syringe axis, 0 at the flange's rear face, nozzle towards -x; z = 0 at the plate's
 * underside. Prints as it stands.
 */

// clang-format off
include <../lib/struct.scad>;
// clang-format on

// axis_z: syringe axis height. crank_x: motor shaft x.
// ring: snap ring [gap to the flange block, length, wall].
// ring_grip: per side, ring opening narrower than the barrel; the barrel springs the arms open by this.
// ring_root: degrees below the axis where the base lets go of the ring, so each arm bends over a long
//   arc; 45 is the most its underside may overhang.
// chamfer: the motor pocket's mouth.
// rails: [end x, half the gap between them, top z]; from the flange block out to the plate's edges.
// seat_z: motor screw head seat; screw_bore: counterbore diameter.
// dovetail: how far each long edge's foot reaches out, at 45 degrees.
// w, front: the plate's width and front end x, when a shared body fixes them; by default the flange's
// width and the snap ring's front.
// clang-format off
function frame_spec(syringe, motor, screw, fit, wall, plate_t, pocket, axis_z, crank_x, rails, seat_z, screw_bore,
                    ring_grip, ring = [15, 6, 1.6], ring_root = 45, chamfer = 0.5, dovetail = 2.5, w = undef,
                    front = undef) =
    let (block = [-get(syringe, "flange_t") - fit - wall, fit + wall],
         ring_x = block[0] - ring[0] - ring[1],
         own_w = plate_w(syringe, fit))
    assert(is_undef(w) || w >= own_w, "the plate is narrower than the flange")
    assert(is_undef(front) || front <= ring_x, "the plate ends behind the snap ring") [
        ["name", "frame"], ["syringe", syringe], ["motor", motor], ["screw", screw], ["fit", fit],
        ["plate_t", plate_t], ["pocket", pocket], ["axis_z", axis_z], ["crank_x", crank_x],
        ["ring", ring], ["ring_grip", ring_grip], ["ring_root", ring_root], ["chamfer", chamfer], ["block", block], ["ring_x", ring_x],
        ["rail_end", rails[0]], ["rail_gap", rails[1]], ["rail_top", rails[2]], ["seat_z", seat_z], ["screw_bore", screw_bore], ["dovetail", dovetail],
        ["w", is_undef(w) ? own_w : w],
        ["x", [is_undef(front) ? ring_x : front, crank_x + motor_size(motor)[0] / 2 + fit + wall]],
    ];
// clang-format on

// The plate's width for a syringe alone: its flange's, with fit a side.
function plate_w(syringe, fit) = get(syringe, "flange")[0] + 2 * fit;

// A cylinder of diameter d along +x from x = 0 to len, on the syringe axis.
module on_axis(s, d, len) translate([ 0, 0, get(s, "axis_z") ]) rotate([ 0, 90, 0 ]) cylinder(d = d, h = len);

// A slot of width w on the syringe axis, round at the bottom and open to the top, from x = 0 to len.
module u_cut(s, w, len)
{
    on_axis(s, w, len);
    translate([ 0, -w / 2, get(s, "axis_z") ]) cube([ len, w, 100 ]);
}

// The plate's section across the axis: w wide on top, t thick, long edges dovetailed out d at 45
// degrees, each foot on a land so its edge is square. The body's rails use the same points.
function plate_profile(w, d, t, land = 0.6) = [
    [ -w / 2 - d, 0 ], [ w / 2 + d, 0 ], [ w / 2 + d, land ], [ w / 2, d + land ], [ w / 2, t ], [ -w / 2, t ],
    [ -w / 2, d + land ], [ -w / 2 - d, land ]
];

module plate_section(s) polygon(plate_profile(get(s, "w"), get(s, "dovetail"), get(s, "plate_t")));

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
    slot_h = get(sy, "flange")[1] + 2 * fit;
    cx = get(s, "crank_x");
    chamfer = get(s, "chamfer");
    difference()
    {
        union()
        {
            translate([ x[0], 0, 0 ]) rotate([ 90, 0, 90 ]) linear_extrude(x[1] - x[0]) plate_section(s);
            translate([ block[0], -w / 2, t - 1 ]) cube([ block[1] - block[0], w, z - t + 3 ]);
            // the base holds the ring only up to ring_root below the axis; above, each arm stands free and
            // springs open over a long arc. Filleted where the arms leave the base, so no crack starts there.
            translate([ ring_x, 0, 0 ]) rotate([ 90, 0, 90 ]) linear_extrude(ring[1]) offset(r = -1) offset(delta = 1)
                let(root = [ ring_d / 2 * cos(get(s, "ring_root")), z - ring_d / 2 * sin(get(s, "ring_root")) ])
            {
                translate([ 0, z ]) circle(d = ring_d);
                polygon([ [ -root[0], t - 1 ], [ root[0], t - 1 ], root, [ -root[0], root[1] ] ]);
            }
            // the rails run from the flange block's back wall, out to the plate's edges
            gap = get(s, "rail_gap");
            for (side = [ -1, 1 ])
                translate([ block[1] - 1, side > 0 ? gap : -w / 2, t - 1 ])
                    cube([ get(s, "rail_end") - block[1] + 1, w / 2 - gap, get(s, "rail_top") - t + 1 ]);
        }
        // flange slot, open at the sides; barrel through the front wall, plunger through the back
        translate([ -ft - fit, -w / 2 - 1, z - slot_h / 2 ]) cube([ ft + 2 * fit, w + 2, 100 ]);
        translate([ block[0] - 1, 0, 0 ]) u_cut(s, od, -block[0]);
        translate([ fit - 1, 0, 0 ]) u_cut(s, get(sy, "plunger_span") + 2 * fit, block[1] - fit + 2);
        // snap ring bore and opening (ring_grip a side narrower than the barrel); tips bevelled 45 degrees
        // as a lead-in, so the barrel spreads the arms instead of bearing on their tips
        translate([ ring_x - 1, 0, 0 ]) on_axis(s, od, ring[1] + 2);
        a = get(sy, "barrel_od") / 2 - get(s, "ring_grip");
        h = sqrt(od * od / 4 - a * a);
        translate([ ring_x - 1, 0, 0 ]) rotate([ 90, 0, 90 ]) linear_extrude(ring[1] + 2) polygon(
            [ [ -a, z ], [ a, z ], [ a, z + h ], [ a + 50, z + h + 50 ], [ -a - 50, z + h + 50 ], [ -a, z + h ] ]);
        // the motor: gearbox pocket from below, bushing and shaft through, screws counterbored from above
        translate([ cx, 0, -1 ]) linear_extrude(get(s, "pocket") + 1) motor_outline(m, fit);
        // the pocket's mouth chamfered, against the first layer's squash
        pocket = motor_size(m) + [ 2, 2 ] * fit;
        translate([ cx, 0, -1 ]) linear_extrude(1 + chamfer, scale = [for (p = pocket) p / (p + 2 * chamfer + 2)])
            motor_outline(m, fit + chamfer + 1);
        translate([ cx, 0, -1 ]) cylinder(d = get(m, "bushing_d") + 2 * fit, h = t + 2);
        for (y = [ -1, 1 ] * get(m, "hole_pitch") / 2)
            translate([ cx, y, 0 ])
            {
                translate([ 0, 0, -1 ]) cylinder(d = get(sc, "clear") + 2 * fit, h = t + 2);
                translate([ 0, 0, get(s, "seat_z") ]) cylinder(d = get(s, "screw_bore") + 2 * fit, h = t);
            }
    }
}
