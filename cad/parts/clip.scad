/**
 * @file clip.scad
 * @brief The plunger clip: a cup the push-button drops into, and a tongue out to the rod's pin
 * @author Cameron K. Brooks
 * @copyright 2026
 *
 * The button drops in from above, the plunger through a slot in the front wall; the front wall pulls
 * and the back wall pushes. The plunger holds the clip on its axis, and the rod, screwed down onto
 * the tongue's top face, keeps it level. x = 0 at the button's front face, z = 0 on the syringe
 * axis, which is the tongue's top face. Prints as it stands.
 */

// clang-format off
include <../lib/struct.scad>;
// clang-format on

// clear: back wall to the rod's end. end_d: the tongue's round end, the rod's width.
// clang-format off
function clip_spec(syringe, pin, fit, wall, clear = 1, end_d = 8) =
    let (r = get(syringe, "button_d") / 2 + fit, back = get(syringe, "button_t") + fit + wall) [
        ["name", "plunger clip"], ["syringe", syringe], ["pin", pin], ["fit", fit], ["wall", wall],
        ["end_d", end_d], ["back", back], ["pin_x", back + clear + end_d / 2],
        ["half_w", r + wall], ["bottom", -(r + wall)], ["top", r],
    ];
// clang-format on

module clip(s)
{
    sy = get(s, "syringe");
    fit = get(s, "fit");
    wall = get(s, "wall");
    back = get(s, "back");
    pin_x = get(s, "pin_x");
    bottom = get(s, "bottom");
    top = get(s, "top");
    hw = get(s, "half_w");
    r = get(sy, "button_d") / 2 + fit;
    span = get(sy, "plunger_span") / 2 + fit;
    difference()
    {
        union()
        {
            translate([ -fit - wall, -hw, bottom ]) cube([ back + fit + wall, 2 * hw, top - bottom ]);
            translate([ back - 1, 0, bottom ]) linear_extrude(-bottom) hull()
            {
                translate([ 0, -get(s, "end_d") / 2 ]) square([ 1, get(s, "end_d") ]);
                translate([ pin_x - back + 1, 0 ]) circle(d = get(s, "end_d"));
            }
        }
        translate([ -fit, -r, -r ]) cube([ get(sy, "button_t") + 2 * fit, 2 * r, 2 * r + 1 ]);
        translate([ -fit - wall - 1, -span, -span ]) cube([ wall + 2, 2 * span, top + span + 1 ]);
        translate([ pin_x, 0, bottom - 1 ]) cylinder(d = get(get(s, "pin"), "tap"), h = -bottom + 2);
    }
}
