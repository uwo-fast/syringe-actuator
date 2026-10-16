/**
 * @file syringes.scad
 * @brief The syringes, one struct each, with the source of every figure; syringe.scad draws one
 * @author Cameron K. Brooks
 * @copyright 2026
 *
 * undef = no source states it, and get() stops the build if the design reads it; NOMINAL = no source
 * states it but the parts need a number today. Measure and replace both.
 */

// clang-format off
include <../lib/struct.scad>;
use <syringe.scad>;
// clang-format on

// Luer-lock syringes, measured by hand (the 3 mL 2026-09-29, the rest 2026-10-02), barrel axis along x, nozzle towards
// -x. Not BD's: the 3 and 5 mL carry no maker's mark, and another maker's syringe of the same volume can differ by most
// of a millimetre; measure the one you use (docs/measuring.md).
// flange: [width, height] across the axis, as it sits in the frame. exposed: the flange's rear face to the
// push-button's front face, stopper bottomed. plunger_span: the widest the plunger reaches across the axis (its ribs'
// cross; the 1 mL's plunger is a solid rod), where all of them narrow a little towards the push-button. barrel_l: the
// flange's front face to the barrel's shoulder at the nozzle's root. nozzle_l: that shoulder to the syringe's front
// end, the nozzle's tip or its luer-lock collar's face, whichever reaches further; the 5 mL's is not measured but
// derived, the tip's 46.5 past the assembled body's front face less the 36.3 the shoulder sits behind it, and the rest
// are unmeasured. bore_d: the barrel's inside, NOMINAL on every row: BD's published bores, from syringe-pump libraries,
// for the report's torque estimate only.
syringe_1ml = [
    [ "name", "1 mL luer syringe" ], [ "bore_d", 4.78 ], [ "barrel_od", 9.45 ], [ "flange", [ 24.6, 12.6 ] ],
    [ "flange_t", 2.0 ], [ "button_d", 10.2 ], [ "button_t", 1.8 ], [ "stroke", 64.25 ], [ "exposed", 10.75 ],
    [ "plunger_span", 3.8 ], [ "barrel_l", 75.0 ], [ "nozzle_l", undef ]
];

syringe_3ml = [
    [ "name", "3 mL luer syringe" ], [ "bore_d", 8.66 ], [ "barrel_od", 10.0 ], [ "flange", [ 24.5, 12.6 ] ],
    [ "flange_t", 2.0 ], [ "button_d", 12.6 ], [ "button_t", 1.6 ], [ "stroke", 57.25 ], [ "exposed", 10.75 ],
    [ "plunger_span", 7.5 ], [ "barrel_l", 68.0 ], [ "nozzle_l", undef ]
];

syringe_5ml = [
    [ "name", "5 mL luer syringe" ], [ "bore_d", 12.06 ], [ "barrel_od", 13.6 ], [ "flange", [ 26.9, 16.0 ] ],
    [ "flange_t", 1.4 ], [ "button_d", 16.6 ], [ "button_t", 1.8 ], [ "stroke", 52.5 ], [ "exposed", 14.3 ],
    [ "plunger_span", 11.5 ], [ "barrel_l", 63.5 ], [ "nozzle_l", 10.2 ]
];

syringe_20ml = [
    [ "name", "20 mL luer syringe" ], [ "bore_d", 19.13 ], [ "barrel_od", 20.9 ], [ "flange", [ 36.3, 24.2 ] ],
    [ "flange_t", 1.6 ], [ "button_d", 20.9 ], [ "button_t", 1.4 ], [ "stroke", 80.0 ], [ "exposed", 11.75 ],
    [ "plunger_span", 18.3 ], [ "barrel_l", 91.75 ], [ "nozzle_l", undef ]
];

// BD Plastipak luer-lock syringes, estimated, not measured: from BD's photo of its range, scaled against the 5 and 20
// mL above, with outside diameters from published figures (Fisher's 16.21 for the 10 mL; 23.77 and 29.5 for the 30 and
// 50 mL) and exposed from a Terumo pump manual's flange-to-plunger-end figures less the push-button. Good to about a
// millimetre; measure one in hand and replace these (docs/measuring.md). The 50 mL is not built.
syringe_10ml = [
    [ "name", "10 mL BD luer-lock syringe (estimated)" ], [ "bore_d", 14.5 ], [ "barrel_od", 16.2 ],
    [ "flange", [ 30.0, 19.0 ] ], [ "flange_t", 1.5 ], [ "button_d", 18.0 ], [ "button_t", 1.6 ], [ "stroke", 71.0 ],
    [ "exposed", 11.5 ], [ "plunger_span", 13.7 ], [ "barrel_l", 82.5 ], [ "nozzle_l", undef ]
];

syringe_30ml = [
    [ "name", "30 mL BD luer-lock syringe (estimated)" ], [ "bore_d", 21.59 ], [ "barrel_od", 23.8 ],
    [ "flange", [ 44.0, 27.5 ] ], [ "flange_t", 1.8 ], [ "button_d", 26.0 ], [ "button_t", 1.8 ], [ "stroke", 92.5 ],
    [ "exposed", 14.5 ], [ "plunger_span", 20.8 ], [ "barrel_l", 104.5 ], [ "nozzle_l", undef ]
];

syringe_50ml = [
    [ "name", "50 mL BD luer-lock syringe (estimated)" ], [ "bore_d", 26.59 ], [ "barrel_od", 29.4 ],
    [ "flange", [ 53.0, 33.2 ] ], [ "flange_t", 2.2 ], [ "button_d", 31.0 ], [ "button_t", 2.0 ], [ "stroke", 117.0 ],
    [ "exposed", 15.0 ], [ "plunger_span", 25.7 ], [ "barrel_l", 130.0 ], [ "nozzle_l", undef ]
];

// The syringes the parts can be built for, by the Customizer's names, each with the motor it gets by default: the
// N20 up to the 5 mL, the GA25 from the 10 mL, whose bore makes any vacuum or back-pressure too much for an N20.
syringes = [
    [ "1ml", syringe_1ml, "n20" ], [ "3ml", syringe_3ml, "n20" ], [ "5ml", syringe_5ml, "n20" ],
    [ "10ml", syringe_10ml, "ga25" ], [ "20ml", syringe_20ml, "ga25" ], [ "30ml", syringe_30ml, "ga25" ]
];

// The syringe the Customizer names, or undef.
function syringe_by_name(name) = [for (r = syringes) if (r[0] == name) r[1]][0];

// The name of the motor the Customizer's syringe gets by default, or undef.
function syringe_motor(name) = [for (r = syringes) if (r[0] == name) r[2]][0];
