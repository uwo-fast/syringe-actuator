/**
 * @file motor.scad
 * @brief A gearmotor, drawn from its row in motors.scad
 * @author Cameron K. Brooks
 * @copyright 2026
 */

// clang-format off
include <../lib/struct.scad>;
// clang-format on

// Whether motor m is round, a GA25 say, or rectangular, an N20.
function motor_round(m) = get(m, "shape") == "round";

// The gearbox's extent, [across x, across y], the shaft at its centre.
function motor_size(m) = motor_round(m) ? [ get(m, "gearbox_d"), get(m, "gearbox_d") ] : [ get(m, "h"), get(m, "w") ];

// How far the gearbox or the can reaches out from the shaft's axis across y, whichever is further.
function motor_half_w(m) = motor_round(m) ? max(get(m, "gearbox_d"), get(m, "can_d")) / 2 : get(m, "w") / 2;

// The gearbox's section, grown by g all round, centred on the shaft.
module motor_outline(m, g = 0)
{
    if (motor_round(m))
        circle(d = get(m, "gearbox_d") + 2 * g);
    else
        square(motor_size(m) + [ 2, 2 ] * g, center = true);
}

// Gearmotor m, its gearbox's face at z = 0 and its shaft up the z axis.
module motor(m)
{
    gb = get(m, "gearbox_l");
    can = get(m, "can_l");
    color("goldenrod") translate([ 0, 0, -gb ]) linear_extrude(gb) motor_outline(m);
    color("silver") translate([ 0, 0, -gb - can ]) linear_extrude(can) if (motor_round(m)) circle(d = get(m, "can_d"));
    else motor_outline(m);
    color("silver") cylinder(d = get(m, "shaft_d"), h = get(m, "shaft_l"));
}
