/**
 * @file clip.scad
 * @brief The plunger clip: a cup the push-button drops into, and a tongue out to the rod's pin
 * @author Cameron K. Brooks
 * @copyright 2026
 *
 * The button drops in from above, the plunger through a slot in the front wall; the front wall pulls
 * and the back wall pushes. A sled under the clip runs between the frame's rails, which take the
 * rod's side load and keep the clip square to the axis; the plunger carries only the stroke. The
 * rod lies on the tongue's top face and turns on its boss. x = 0 at the button's front face, z = 0
 * on the syringe axis, which is the tongue's top face. Prints as it stands.
 */

// clang-format off
include <../lib/struct.scad>;
// clang-format on

// boss: [d, h] of the pin's boss. end_d: the tongue's round end, the rod's width. sled: [its reach
// past the pin, which sets how long the rails hold it square; its top's depth under the rod].
// clear: back wall to the rod's end.
// clang-format off
function clip_spec(syringe, pin, fit, wall, boss, end_d, sled, clear = 1) =
    let (r = get(syringe, "button_d") / 2 + fit, back = get(syringe, "button_t") + fit + wall,
         pin_x = back + clear + end_d / 2) [
        ["name", "plunger clip"], ["syringe", syringe], ["pin", pin], ["fit", fit],
        ["boss", boss], ["end_d", end_d], ["back", back], ["pin_x", pin_x], ["front", -fit - wall],
        ["sled", sled], ["sled_end", pin_x + sled[0]],
        ["half_w", r + wall], ["top", r],
    ];
// clang-format on

module clip(s)
{
    sy = get(s, "syringe");
    fit = get(s, "fit");
    back = get(s, "back");
    pin_x = get(s, "pin_x");
    front = get(s, "front");
    top = get(s, "top");
    hw = get(s, "half_w");
    bottom = -hw;
    span = get(sy, "plunger_span") / 2 + fit;
    boss = get(s, "boss");
    difference()
    {
        union()
        {
            translate([ front, -hw, bottom ]) cube([ back - front, 2 * hw, top - bottom ]);
            translate([ back - 1, 0, bottom ]) linear_extrude(-bottom) hull()
            {
                translate([ 0, -get(s, "end_d") / 2 ]) square([ 1, get(s, "end_d") ]);
                translate([ pin_x - back + 1, 0 ]) circle(d = get(s, "end_d"));
            }
            translate([ pin_x, 0, -1 ]) cylinder(d = boss[0], h = boss[1] + 1);
            translate([ front, -hw, bottom ]) cube([ get(s, "sled_end") - front, 2 * hw, -get(s, "sled")[1] - bottom ]);
        }
        translate([ -fit, -top, -top ]) cube([ get(sy, "button_t") + 2 * fit, 2 * top, 2 * top + 1 ]);
        translate([ front - 1, -span, -span ]) cube([ -front - fit + 2, 2 * span, top + span + 1 ]);
        translate([ pin_x, 0, bottom - 1 ]) cylinder(d = get(get(s, "pin"), "tap"), h = -bottom + boss[1] + 2);
    }
}
