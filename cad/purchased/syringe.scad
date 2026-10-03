/**
 * @file syringe.scad
 * @brief A luer syringe, drawn from its row in syringes.scad
 * @author Cameron K. Brooks
 * @copyright 2026
 */

// clang-format off
include <../lib/struct.scad>;
// clang-format on

// Syringe s on its axis, x along it from the flanges' rear face, with its push-button's front face at x = button_x. Its
// bore is cut through the barrel and the flanges, drawn as one solid so no two faces lie on each other, with a nominal
// wall (unmeasured, drawing only); the stopper is a hair smaller than the bore, and nominally 5 long.
module syringe(s, button_x)
{
    ft = get(s, "flange_t");
    front = -ft - get(s, "barrel_l");
    stopper = front + button_x - get(s, "exposed");
    span = get(s, "plunger_span");
    bore = get(s, "barrel_od") - 2 * 0.8;
    {
        color("white", 0.4) difference()
        {
            union()
            {
                translate([ front, 0, 0 ]) rotate([ 0, 90, 0 ]) cylinder(d = get(s, "barrel_od"), h = -front);
                translate([ -ft, -get(s, "flange")[0] / 2, -get(s, "flange")[1] / 2 ])
                    cube([ ft, get(s, "flange")[0], get(s, "flange")[1] ]);
            }
            translate([ front - 1, 0, 0 ]) rotate([ 0, 90, 0 ]) cylinder(d = bore, h = -front + 2);
        }
        color("white")
        {
            translate([ button_x, 0, 0 ]) rotate([ 0, 90, 0 ]) cylinder(d = get(s, "button_d"), h = get(s, "button_t"));
            for (r = [ 0, 90 ])
                rotate([ r, 0, 0 ]) translate([ stopper, -span / 2, -0.6 ]) cube([ button_x - stopper, span, 1.2 ]);
        }
        color("dimgray") translate([ stopper, 0, 0 ]) rotate([ 0, 90, 0 ]) cylinder(d = bore - 0.2, h = 5);
    }
}
