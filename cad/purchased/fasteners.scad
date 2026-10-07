/**
 * @file fasteners.scad
 * @brief The screws and washers, one struct each, with the source of every figure; fastener.scad draws them
 * @author Cameron K. Brooks
 * @copyright 2026
 *
 * undef = no source states it, and get() stops the build if the design reads it; NOMINAL = no source
 * states it but the parts need a number today. Measure and replace both.
 */

// clang-format off
include <../lib/struct.scad>;
use <fastener.scad>;
// clang-format on

// ISO 4762 socket head, ISO 7380 button head and ISO 7089 washer table values. head: how a screw's length is measured
// and how it seats: "flat" overall, its cone in the hole's mouth; the others under the head, on its underside. The
// N20's screws as bought: JIS flat heads, 90 degree countersunk, M1.6 x 3 (McMaster 91305A002, its page 2026-10-03).
m3_shcs = [
    [ "name", "ISO 4762 M3" ], [ "head", "socket" ], [ "d", 3 ], [ "clear", 3.4 ], [ "tap", 2.5 ], [ "head_d", 5.5 ],
    [ "head_h", 3 ]
];
m3_button = [
    [ "name", "ISO 7380 M3 button head" ], [ "head", "button" ], [ "d", 3 ], [ "clear", 3.4 ], [ "head_d", 5.7 ],
    [ "head_h", 1.65 ]
];
m1_6_flat = [
    [ "name", "JIS flat head M1.6" ], [ "head", "flat" ], [ "d", 1.6 ], [ "clear", 1.8 ], [ "head_d", 2.4 ],
    [ "head_h", 0.5 ]
];
m3_washer = [ [ "name", "ISO 7089 M3" ], [ "id", 3.2 ], [ "od", 7 ], [ "h", 0.5 ] ];
// ISO 4026 set screw, cup point, and ISO 4032 hex nut table values: the crank's grub screw and the nut trapped in it.
m3_set = [ [ "name", "ISO 4026 set screw, cup point" ], [ "d", 3 ], [ "clear", 3.4 ] ];
m3_nut = [ [ "name", "ISO 4032 nut" ], [ "s", 5.5 ], [ "e", 6.01 ], [ "m", 2.4 ] ];
