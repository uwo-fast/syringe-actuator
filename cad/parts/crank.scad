/**
 * @file crank.scad
 * @brief The crank: a hub pressed onto the motor's D-shaft and an arm out to the crank pin
 * @author Cameron K. Brooks
 * @copyright 2026
 *
 * The rod turns on a boss on the crank's top face, and the pin screw clamps a washer down on the
 * boss, not on the rod. The D-bore is blind: pressed on, the crank stops on the shaft's tip, which
 * sets its height over the plate; the D-flat carries the torque. z = 0 at the underside, the shaft on
 * the z axis, the pin on +x. Prints as it stands.
 */

// clang-format off
include <../lib/struct.scad>;
// clang-format on

// tap: the pin screw's hole, which it threads itself into. throw: shaft axis to pin axis. press: per
// side, a printed bore round a steel shaft. h: underside
// to the top face the rod lies on. boss: [d, h] of the pin's boss. bore: the blind bore's depth, the
// shaft's reach into the crank. end_d: the pin end, the rod's width.
// clang-format off
function crank_spec(motor, tap, press, throw, h, boss, bore, end_d, hub_d = 12) = [
    ["name", "crank"], ["motor", motor], ["tap", tap], ["press", press], ["throw", throw],
    ["h", h], ["boss", boss], ["bore", bore], ["hub_d", hub_d], ["end_d", end_d],
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
    boss = get(s, "boss");
    difference()
    {
        union()
        {
            linear_extrude(h) hull()
            {
                circle(d = get(s, "hub_d"));
                translate([ throw, 0 ]) circle(d = get(s, "end_d"));
            }
            translate([ throw, 0, h - 1 ]) cylinder(d = boss[0], h = boss[1] + 1);
        }
        translate([ 0, 0, -1 ]) linear_extrude(get(s, "bore") + 1) d_shaft(get(s, "motor"), get(s, "press"));
        translate([ throw, 0, -1 ]) cylinder(d = get(s, "tap"), h = h + boss[1] + 2);
    }
}
