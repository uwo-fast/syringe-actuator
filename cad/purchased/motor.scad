/**
 * @file motor.scad
 * @brief A gearmotor, drawn from its row in motors.scad
 * @author Cameron K. Brooks
 * @copyright 2026
 */

// clang-format off
include <../lib/struct.scad>;
// clang-format on

// An N20-style gearmotor m, its gearbox's face at z = 0 and its shaft up the z axis.
module motor(m)
{
    gb = get(m, "gearbox_l");
    color("goldenrod") translate([ -get(m, "h") / 2, -get(m, "w") / 2, -gb ]) cube([ get(m, "h"), get(m, "w"), gb ]);
    color("silver") translate([ -get(m, "h") / 2, -get(m, "w") / 2, -gb - get(m, "can_l") ])
        cube([ get(m, "h"), get(m, "w"), get(m, "can_l") ]);
    color("silver") cylinder(d = get(m, "shaft_d"), h = get(m, "shaft_l"));
}
