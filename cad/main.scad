/**
 * @file main.scad
 * @brief The entry point: view the mechanism or one printed part
 * @author Cameron K. Brooks
 * @copyright 2026
 *
 * Open this in OpenSCAD and use the Customizer, or pass -D on the command line:
 *   openscad -D 'part="crank"' -o crank.stl cad/main.scad
 * A printed part comes out in its print orientation. The assembly turns with View > Animate; `angle`
 * sets where it starts. `report` echoes the screws and the derived figures.
 */

// clang-format off
include <catalog.scad>;
include <assembly.scad>;
// clang-format on

// Customizer: one line per setting, so clang-format must leave the dropdown comments whole.
// clang-format off
/* [View] */
part = "assembly"; // [assembly, frame, crank, rod, clip, report]
angle = 180;       // [0:5:355]
show_bought = true;

/* [Print] */
fit = 0.2;   // per side: a printed pocket round bought stock
press = 0.05; // per side: the crank's bore on the steel shaft
wall = 3;
// clang-format on

/* [Hidden] */
$fn = 48;

L = layout(syringe = syringe_3ml, motor = n20_1000, pin = m3_shcs, pin_washer = m3_washer, motor_screw = m1_6_pan,
           fit = fit, press = press, wall = wall);

// Each printed part, turned to how it prints.
if (part == "assembly")
    assembly(L, angle + 360 * $t, bought = show_bought);
else if (part == "frame")
    frame(get(L, "frame"));
else if (part == "crank")
    crank(get(L, "crank"));
else if (part == "rod")
    rod(get(L, "rod"));
else if (part == "clip")
    translate([ 0, 0, -get(get(L, "clip"), "bottom") ]) clip(get(L, "clip"));
else if (part == "report")
    report(L);
else
    assert(false, str("no part '", part, "'"));
