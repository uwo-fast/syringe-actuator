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

// Luer-lock syringes, measured by hand (the 3 mL 2026-09-29, the rest 2026-10-02), barrel axis along x, nozzle towards
// -x. Not BD's: the 3 and 5 mL carry no maker's mark, and another maker's syringe of the same volume can differ by most
// of a millimetre; measure the one you use (docs/measuring.md).
// flange: [width, height] across the axis, as it sits in the frame. exposed: the flange's rear face to the
// push-button's front face, stopper bottomed. plunger_span: the widest the plunger reaches across the axis (its
// ribs' cross; the 1 mL's plunger is a solid rod), where all of them narrow a little towards the push-button.
// barrel_l: the flange's front face to the barrel's shoulder at the nozzle's root. The 20 mL is not built yet: it
// needs the round 25 mm motor, ga25_30, which the frame does not take yet.
syringe_1ml = [
    [ "name", "1 mL luer syringe" ], [ "barrel_od", 9.45 ], [ "flange", [ 24.6, 12.6 ] ], [ "flange_t", 2.0 ],
    [ "button_d", 10.2 ], [ "button_t", 1.8 ], [ "stroke", 64.25 ], [ "exposed", 10.75 ], [ "plunger_span", 3.8 ],
    [ "barrel_l", 75.0 ]
];

syringe_3ml = [
    [ "name", "3 mL luer syringe" ], [ "barrel_od", 10.0 ], [ "flange", [ 24.5, 12.6 ] ], [ "flange_t", 2.0 ],
    [ "button_d", 12.6 ], [ "button_t", 1.6 ], [ "stroke", 57.25 ], [ "exposed", 10.75 ], [ "plunger_span", 7.5 ],
    [ "barrel_l", 68.0 ]
];

syringe_5ml = [
    [ "name", "5 mL luer syringe" ], [ "barrel_od", 13.6 ], [ "flange", [ 26.9, 16.0 ] ], [ "flange_t", 1.4 ],
    [ "button_d", 16.6 ], [ "button_t", 1.8 ], [ "stroke", 52.5 ], [ "exposed", 14.3 ], [ "plunger_span", 11.5 ],
    [ "barrel_l", 63.5 ]
];

syringe_20ml = [
    [ "name", "20 mL luer syringe" ], [ "barrel_od", 20.9 ], [ "flange", [ 36.3, 24.2 ] ], [ "flange_t", 1.6 ],
    [ "button_d", 20.9 ], [ "button_t", 1.4 ], [ "stroke", 80.0 ], [ "exposed", 11.75 ], [ "plunger_span", 18.3 ],
    [ "barrel_l", 91.75 ]
];

// Pololu micro metal gearmotor dimension drawing, 2024-04-03 (the N20 form factor), 1000:1 gearbox.
// Section w x h throughout; the M1.6 holes are pitch apart across w. shaft_l from the gearbox face,
// measured on the motor in hand 2026-09-29, D-profile over its whole length. tail_l: the end cap's
// boss and the terminals past the can, NOMINAL.
n20_1000 = [
    [ "name", "N20 inline gearmotor, 12 V 1000:1" ], [ "w", 12 ], [ "h", 10 ], [ "gearbox_l", 12.5 ], [ "can_l", 16.2 ],
    [ "shaft_d", 3 ], [ "shaft_flat", 2.5 ], [ "shaft_l", 9 ], [ "bushing_d", 4 ], [ "bushing_h", 0.7 ],
    [ "hole_pitch", 9 ], [ "tail_l", 3 ]
];

// The round 25 mm gearmotor for the larger syringes: a GA25YN370, 12 V 30 rpm (HERCHR, Amazon.ca B0BX6B91L9, ordered
// 2026-10-02), sold also as JGA25-370 and 25GA-370. Outline from Seeed's JGA25-370 drawing (SKU 114090046), the same
// 25 mm form factor: gearbox d x gearbox_l, the can can_d x can_l behind it, a bushing (boss) round the shaft. shaft_l
// from the gearbox face; the D-flat runs flat_l back from the tip. 2 x M3 tapped holes hole_pitch apart across the
// shaft, hole_depth deep at most; the face's other two screws hold the gearbox together and must stay in. undef: no
// source gives it for this ratio or the sources disagree; measure the motor in hand: gearbox_l (21 on Seeed's 350 rpm
// part, longer at higher ratios), shaft_l (the listing says 10, Seeed 11.5), and tail_l.
ga25_30 = [
    [ "name", "GA25YN370 gearmotor, 12 V 30 rpm" ], [ "gearbox_d", 25 ], [ "gearbox_l", undef ], [ "can_d", 24.4 ],
    [ "can_l", 30.8 ], [ "shaft_d", 4 ], [ "shaft_flat", 3.5 ], [ "shaft_l", undef ], [ "flat_l", 8 ],
    [ "bushing_d", 7 ], [ "bushing_h", 2.5 ], [ "hole_pitch", 17 ], [ "hole_depth", 3.5 ], [ "tail_l", undef ]
];

// ISO 4762 socket head, ISO 7045 pan head and ISO 7089 washer table values.
m3_shcs =
    [ [ "name", "ISO 4762 M3" ], [ "d", 3 ], [ "clear", 3.4 ], [ "tap", 2.5 ], [ "head_d", 5.5 ], [ "head_h", 3 ] ];
m1_6_pan = [ [ "name", "ISO 7045 M1.6" ], [ "d", 1.6 ], [ "clear", 1.8 ], [ "head_d", 3.2 ], [ "head_h", 1.3 ] ];
m3_washer = [ [ "name", "ISO 7089 M3" ], [ "id", 3.2 ], [ "od", 7 ], [ "h", 0.5 ] ];
