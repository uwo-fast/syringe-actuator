/**
 * @file fastener.scad
 * @brief Screws and washers, drawn from their rows in fasteners.scad
 * @author Cameron K. Brooks
 * @copyright 2026
 */

// clang-format off
include <../lib/struct.scad>;
// clang-format on

// A screw of length len whose head seats at z = seat.
module screw(s, len, seat)
{
    translate([ 0, 0, seat ]) cylinder(d = get(s, "head_d"), h = get(s, "head_h"));
    translate([ 0, 0, seat - len ]) cylinder(d = get(s, "d"), h = len);
}

// A flat head screw of overall length len, its head's top at z = 0.
module flat_screw(s, len)
{
    hd = get(s, "head_d");
    translate([ 0, 0, -(hd - get(s, "d")) / 2 ]) cylinder(d1 = get(s, "d"), d2 = hd, h = (hd - get(s, "d")) / 2);
    translate([ 0, 0, -len ]) cylinder(d = get(s, "d"), h = len);
}

// A washer w lying on z = 0.
module washer(w)
{
    difference()
    {
        cylinder(d = get(w, "od"), h = get(w, "h"));
        translate([ 0, 0, -1 ]) cylinder(d = get(w, "id"), h = get(w, "h") + 2);
    }
}
