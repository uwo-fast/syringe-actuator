/**
 * @file catalog.scad
 * @brief Purchased parts, one struct each, with the source of every figure
 * @author Cameron K. Brooks
 * @copyright 2026
 *
 * undef = no source states it, and get() stops the build if the design reads it; NOMINAL = no source
 * states it but the parts need a number today. Measure and replace both.
 */

// clang-format off
include <lib/struct.scad>;
// clang-format on

// Measured by hand 2026-09-29, except where NOMINAL. Barrel axis along x, nozzle towards -x.
// flange: [width, height] in the plane across the axis, as it sits in the frame. exposed: the
// flange's rear face to the push-button's front face with the stopper bottomed. plunger_span: the
// widest the plunger's ribs reach across the axis. barrel_l: flange to the nozzle's root, NOMINAL,
// drawn only.
syringe_3ml = [
    [ "name", "3 mL luer syringe" ], [ "barrel_od", 10.0 ], [ "flange", [ 24.5, 12.6 ] ], [ "flange_t", 2.0 ],
    [ "button_d", 12.6 ], [ "button_t", 1.6 ], [ "stroke", 58 ], [ "exposed", 10.75 ], [ "plunger_span", 7.5 ],
    [ "barrel_l", 55 ]
];

// Pololu micro metal gearmotor dimension drawing, 2024-04-03 (the N20 form factor), 1000:1 gearbox.
// Section w x h throughout; the M1.6 holes are pitch apart across w. shaft_l from the gearbox face.
n20_1000 = [
    [ "name", "N20 inline gearmotor, 12 V 1000:1" ], [ "w", 12 ], [ "h", 10 ], [ "gearbox_l", 12.5 ], [ "can_l", 16.2 ],
    [ "shaft_d", 3 ], [ "shaft_flat", 2.5 ], [ "shaft_l", 10 ], [ "bushing_d", 4 ], [ "bushing_h", 0.7 ],
    [ "hole_pitch", 9 ]
];

// ISO 4762 socket head and ISO 7045 pan head table values.
m3_shcs =
    [ [ "name", "ISO 4762 M3" ], [ "d", 3 ], [ "clear", 3.4 ], [ "tap", 2.5 ], [ "head_d", 5.5 ], [ "head_h", 3 ] ];
m1_6_pan = [ [ "name", "ISO 7045 M1.6" ], [ "d", 1.6 ], [ "clear", 1.8 ], [ "head_d", 3.2 ], [ "head_h", 1.3 ] ];
