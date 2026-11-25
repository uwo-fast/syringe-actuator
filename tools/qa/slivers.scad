// For tools/qa/qa.sh: the section of a printed part at xc along axis, in [-z, y], and the regions in
// it thinner than 2 * e: material ("material") or air ("gap") that a morphological opening or closing
// by e removes. Run with -D 'part="report"' so main draws nothing itself.
include <../../cad/main.scad>;

xc = 0;
what = "material";
e = 0.25;
B = get(L, "body");
// which: the part; axis: the normal of the cut
which = "body";
axis = "x";
module placed() {
    if (axis == "x")
        rotate([0, -90, 0]) translate([-xc, 0, 0]) children();
    if (axis == "y")
        rotate([90, 0, 0]) translate([0, -xc, 0]) children();
    if (axis == "z")
        translate([0, 0, -xc]) children();
}
module sect() projection(cut=true) placed() {
            if (which == "body")
                body(B);
            if (which == "lid")
                lid(B);
            if (which == "cap")
                cap(B);
            if (which == "frame")
                frame(get(L, "frame"));
        }

if (what == "material")
    difference() {
        sect();
        offset(delta=e) offset(delta=-e) sect();
    }
if (what == "gap")
    difference() {
        offset(delta=-e) offset(delta=e) sect();
        sect();
    }
if (what == "section")
    sect();
