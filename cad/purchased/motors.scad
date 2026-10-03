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
use <motor.scad>;
// clang-format on

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
