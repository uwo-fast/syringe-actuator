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

// Luer-lock syringes. Axis: X; nozzle: -X. Dimensions in mm.
// Rows: <volume>_<maker>. gnr = generic, hand-measured; bd = BD Plastipak, estimated.
// Same volume from another maker can differ by ~1 mm: measure yours (docs/measuring.md).
//
// Measured: 3 mL 2026-09-29; 1 mL, 5 mL gnr1, 20 mL 2026-10-02; 5 mL gnr2 before 2026-11-06.
// bd: scaled from BD's range photo against the 5 and 20 mL; ODs published (Fisher's 16.21 for 10 mL,
// 23.77 for 30 mL, 29.5 for 50 mL); exposed from a Terumo pump manual. Good to ~1 mm. 50 mL not built.
//
// flange: [width, height]; exposed: flange rear to button front, stopper bottomed;
// plunger_span: max plunger width across the axis; barrel_l: flange front to nozzle shoulder;
// nozzle_l: shoulder to the nozzle tip or luer collar, whichever is further
// (5 mL gnr1: derived, 46.5 - 36.3, not measured).
// bore_d: nominal BD values, for the torque estimate only.
// crank_as: keep another syringe's crank position, so only the crank and rod are reprinted.
// The build stops unless barrel_od, flange, flange_t, button_d, button_t and plunger_span match.
syringe_1ml_gnr1 = [
    [ "name", "1 mL luer syringe generic 1" ], [ "bore_d", 4.78 ], [ "barrel_od", 9.45 ], [ "flange", [ 24.6, 12.6 ] ],
    [ "flange_t", 2.0 ], [ "button_d", 10.2 ], [ "button_t", 1.8 ], [ "stroke", 64.25 ], [ "exposed", 10.75 ],
    [ "plunger_span", 3.8 ], [ "barrel_l", 75.0 ], [ "nozzle_l", undef ]
];

syringe_3ml_gnr1 = [
    [ "name", "3 mL luer syringe generic 1" ], [ "bore_d", 8.66 ], [ "barrel_od", 10.0 ], [ "flange", [ 24.5, 12.6 ] ],
    [ "flange_t", 2.0 ], [ "button_d", 12.6 ], [ "button_t", 1.6 ], [ "stroke", 57.25 ], [ "exposed", 10.75 ],
    [ "plunger_span", 7.5 ], [ "barrel_l", 68.0 ], [ "nozzle_l", undef ]
];

syringe_5ml_gnr1 = [
    [ "name", "5 mL luer syringe generic 1" ], [ "bore_d", 12.06 ], [ "barrel_od", 13.6 ], [ "flange", [ 26.9, 16.0 ] ],
    [ "flange_t", 1.4 ], [ "button_d", 16.6 ], [ "button_t", 1.8 ], [ "stroke", 52.5 ], [ "exposed", 14.3 ],
    [ "plunger_span", 11.5 ], [ "barrel_l", 63.5 ], [ "nozzle_l", 10.2 ]
]; // stroke x the nominal bore: about 6.0 mL, against gnr2's 5.4 mL; neither bore is measured

syringe_5ml_gnr2 = [
    [ "name", "5 mL luer syringe generic 2" ], [ "bore_d", 12.06 ], [ "barrel_od", 13.6 ], [ "flange", [ 26.9, 16.0 ] ],
    [ "flange_t", 1.4 ], [ "button_d", 16.6 ], [ "button_t", 1.8 ], [ "stroke", 47.3 ], [ "exposed", 13.6 ],
    [ "plunger_span", 11.5 ], [ "barrel_l", 56.8 ], [ "nozzle_l", 10.0 ], [ "crank_as", syringe_5ml_gnr1 ]
];

syringe_10ml_bd = [
    [ "name", "10 mL luer syringe BD" ], [ "bore_d", 14.5 ], [ "barrel_od", 16.2 ], [ "flange", [ 30.0, 19.0 ] ],
    [ "flange_t", 1.5 ], [ "button_d", 18.0 ], [ "button_t", 1.6 ], [ "stroke", 71.0 ], [ "exposed", 11.5 ],
    [ "plunger_span", 13.7 ], [ "barrel_l", 82.5 ], [ "nozzle_l", undef ]
];

syringe_20ml_gnr1 = [
    [ "name", "20 mL luer syringe generic 1" ], [ "bore_d", 19.13 ], [ "barrel_od", 20.9 ],
    [ "flange", [ 36.3, 24.2 ] ], [ "flange_t", 1.6 ], [ "button_d", 20.9 ], [ "button_t", 1.4 ], [ "stroke", 80.0 ],
    [ "exposed", 11.75 ], [ "plunger_span", 18.3 ], [ "barrel_l", 91.75 ], [ "nozzle_l", undef ]
];

syringe_30ml_bd = [
    [ "name", "30 mL luer syringe BD" ], [ "bore_d", 21.59 ], [ "barrel_od", 23.8 ], [ "flange", [ 44.0, 27.5 ] ],
    [ "flange_t", 1.8 ], [ "button_d", 26.0 ], [ "button_t", 1.8 ], [ "stroke", 92.5 ], [ "exposed", 14.5 ],
    [ "plunger_span", 20.8 ], [ "barrel_l", 104.5 ], [ "nozzle_l", undef ]
];

syringe_50ml_bd = [
    [ "name", "50 mL luer syringe BD" ], [ "bore_d", 26.59 ], [ "barrel_od", 29.4 ], [ "flange", [ 53.0, 33.2 ] ],
    [ "flange_t", 2.2 ], [ "button_d", 31.0 ], [ "button_t", 2.0 ], [ "stroke", 117.0 ], [ "exposed", 15.0 ],
    [ "plunger_span", 25.7 ], [ "barrel_l", 130.0 ], [ "nozzle_l", undef ]
];

// The syringes the parts can be built for, by the Customizer's names, each with the motor it gets by default: the
// N20 up to the 5 mL, the GA25 from the 10 mL, whose bore makes any vacuum or back-pressure too much for an N20.
syringes = [
    [ "1ml", syringe_1ml_gnr1, "n20" ], [ "3ml", syringe_3ml_gnr1, "n20" ], [ "5ml-gnr1", syringe_5ml_gnr1, "n20" ],
    [ "5ml-gnr2", syringe_5ml_gnr2, "n20" ], [ "10ml", syringe_10ml_bd, "ga25" ], [ "20ml", syringe_20ml_gnr1, "ga25" ],
    [ "30ml", syringe_30ml_bd, "ga25" ]
];

// The syringe the Customizer names, or undef.
function syringe_by_name(name) = [for (r = syringes) if (r[0] == name) r[1]][0];

// The name of the motor the Customizer's syringe gets by default, or undef.
function syringe_motor(name) = [for (r = syringes) if (r[0] == name) r[2]][0];
