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

// ISO 4762 socket head and ISO 7089 washer table values. The motor screws as bought: JIS flat heads, 90 degree
// countersunk, M1.6 x 3 (McMaster 91305A002, its page 2026-10-03), whose length is overall, head and all.
m3_shcs =
    [ [ "name", "ISO 4762 M3" ], [ "d", 3 ], [ "clear", 3.4 ], [ "tap", 2.5 ], [ "head_d", 5.5 ], [ "head_h", 3 ] ];
m1_6_flat = [ [ "name", "JIS flat head M1.6" ], [ "d", 1.6 ], [ "clear", 1.8 ], [ "head_d", 2.4 ], [ "head_h", 0.5 ] ];
m3_washer = [ [ "name", "ISO 7089 M3" ], [ "id", 3.2 ], [ "od", 7 ], [ "h", 0.5 ] ];
