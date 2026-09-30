/**
 * @file crank.scad
 * @brief The crank: a hub pressed onto the motor's D-shaft and an arm out to the crank pin
 * @author Cameron K. Brooks
 * @copyright 2026
 *
 * The rod lies on the arm's top face and the pin screw threads into the arm, so the rod holds the
 * crank down on its shaft; the D-flat carries the torque. z = 0 at the hub's underside, the shaft on
 * the z axis, the pin on +x. Prints upside down, the arm's top face on the bed.
 */

// clang-format off
include <../lib/struct.scad>;
// clang-format on

// throw: shaft axis to pin axis. press: per side, a printed bore round a steel shaft.
// clang-format off
function crank_spec(motor, pin, press, throw, hub_h, arm_t, hub_d = 12, end_d = 8) = [
    ["name", "crank"], ["motor", motor], ["pin", pin], ["press", press], ["throw", throw],
    ["hub_h", hub_h], ["arm_t", arm_t], ["hub_d", hub_d], ["end_d", end_d],
    ["h", hub_h + arm_t],
];
// clang-format on

// The shaft's D section, grown by press all round: round d, flat at shaft_flat across.
module d_shaft(motor, press)
{
    d = get(motor, "shaft_d");
    flat = get(motor, "shaft_flat") - d / 2 + press;
    intersection()
    {
        circle(d = d + 2 * press);
        translate([ -d, -d ]) square([ 2 * d, d + flat ]);
    }
}

module crank(s)
{
    h = get(s, "h");
    throw = get(s, "throw");
    difference()
    {
        union()
        {
            cylinder(d = get(s, "hub_d"), h = h);
            translate([ 0, 0, get(s, "hub_h") ]) linear_extrude(get(s, "arm_t")) hull()
            {
                circle(d = get(s, "hub_d"));
                translate([ throw, 0 ]) circle(d = get(s, "end_d"));
            }
        }
        translate([ 0, 0, -1 ]) linear_extrude(h + 2) d_shaft(get(s, "motor"), get(s, "press"));
        translate([ throw, 0, -1 ]) cylinder(d = get(get(s, "pin"), "tap"), h = h + 2);
    }
}
