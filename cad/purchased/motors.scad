/**
 * @file motors.scad
 * @brief The gearmotors, one struct each, with the source of every figure; motor.scad draws one
 * @author Cameron K. Brooks
 * @copyright 2026
 *
 * undef = no source states it, and get() stops the build if the design reads it; NOMINAL = no source
 * states it but the parts need a number today. Measure and replace both.
 */

// clang-format off
include <../lib/struct.scad>;
include <fasteners.scad>;
use <motor.scad>;
// clang-format on

// shape: the gearbox's and the can's section, "rect" (w across y by h across x) or "round" (gearbox_d, can_d). mount:
// [screw, its length, [d, depth] of the counterbore over its head in the plate] that holds the gearbox to the plate.
// torque: the most the gearbox should see, kg.cm, the guide the report compares the crank's load against.

// Pololu micro metal gearmotor dimension drawing, 2024-04-03 (the N20 form factor), 1000:1 gearbox.
// Section w x h throughout; the M1.6 holes are pitch apart across w. shaft_l from the gearbox face,
// measured on the motor in hand 2026-09-29, D-profile over its whole length. tail_l: the end cap's
// boss and the terminals past the can, NOMINAL. Its counterbore is the room an ISO 7045 pan head takes; the flat
// heads bought sit in it on the clearance hole's rim, as printed and proven. torque: Pololu's advice for this gearbox,
// instantaneous.
n20_1000 = [
    [ "name", "N20 inline gearmotor, 12 V 1000:1" ], [ "shape", "rect" ], [ "w", 12 ], [ "h", 10 ],
    [ "gearbox_l", 12.5 ], [ "can_l", 16.2 ], [ "shaft_d", 3 ], [ "shaft_flat", 2.5 ], [ "shaft_l", 9 ],
    [ "bushing_d", 4 ], [ "bushing_h", 0.7 ], [ "hole_pitch", 9 ], [ "tail_l", 3 ],
    [ "mount", [ m1_6_flat, 3, [ 3.2, 1.3 ] ] ], [ "torque", 2.5 ]
];

// The round 25 mm gearmotor for the larger syringes: a GA25YN370, 12 V 30 rpm (HERCHR, Amazon.ca B0BX6B91L9), sold also
// as JGA25-370 and 25GA-370. Measured on the motor in hand 2026-10-03, which agrees with Seeed's JGA25-370 drawing (SKU
// 114090046) bar the gearbox's length, longer at this ratio: gearbox d x gearbox_l, the can can_d x can_l behind it, a
// bushing (boss) bushing_d across standing bushing_h proud round the shaft, which is centred. shaft_l from the gearbox
// face, 10 past the bushing; the D-flat runs flat_l back from the tip. tail_l: the can's end boss and terminals. 2 x M3
// tapped holes hole_pitch apart across the shaft, hole_depth deep at most (Seeed's drawing; not measured), so its M3
// button heads put under 3 into them; the face's other two screws hold the gearbox together and must stay in. torque:
// Pololu's continuous advice for its 25 mm metal gearboxes; this one's seller gives 12 kgf.cm at stall.
ga25_30 = [
    [ "name", "GA25YN370 gearmotor, 12 V 30 rpm" ], [ "shape", "round" ], [ "gearbox_d", 25 ], [ "gearbox_l", 26.8 ],
    [ "can_d", 24.3 ], [ "can_l", 30.8 ], [ "shaft_d", 4 ], [ "shaft_flat", 3.5 ], [ "shaft_l", 12.5 ], [ "flat_l", 8 ],
    [ "bushing_d", 7 ], [ "bushing_h", 2.5 ], [ "hole_pitch", 17 ], [ "hole_depth", 3.5 ], [ "tail_l", 1.75 ],
    [ "mount", [ m3_button, 4, [ 5.7, 1.65 ] ] ], [ "torque", 4 ]
];

// The motors, by the Customizer's names.
motors = [ [ "n20", n20_1000 ], [ "ga25", ga25_30 ] ];

// The motor the Customizer names, or undef.
function motor_by_name(name) = [for (r = motors) if (r[0] == name) r[1]][0];
