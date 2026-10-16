/**
 * @file crank.scad
 * @brief The crank: a hub pressed onto the motor's D-shaft and an arm out to the crank pin
 * @author Cameron K. Brooks
 * @copyright 2026
 *
 * The rod turns on a boss on the crank's top face, and the pin screw clamps a washer down on the
 * boss, not on the rod. The D-bore is blind: pressed on, the crank stops on the shaft's tip, which
 * sets its height over the plate. A grub screw through a lobe on the hub's back, away from the pin,
 * bears on the shaft's flat, which faces it, through a nut dropped into a slot from the top: steel
 * on steel carries the torque and holds the crank down. The printed D alone, keyed only by the
 * flat's half millimetre, wore round in an hour under the load reversing every stroke, in PETG on
 * an N20. z = 0 at the underside, the shaft on the z axis, the pin on +x. Prints as it stands.
 */

// clang-format off
include <../lib/struct.scad>;
// clang-format on

// tap: the pin screw's hole, which it threads itself into. throw: shaft axis to pin axis. press: per side, a printed
// bore round a steel shaft. h: underside to the top face the rod lies on. boss: [d, h] of the pin's boss. bore: the
// blind bore's depth, the shaft's reach into the crank. end_d: the pin end, the rod's width. set, nut: the grub screw
// and the nut it threads through, trapped in a slot from the top; fit: per side, round them. web: between the shaft's
// flat and the nut. skin: the lobe beyond the nut. floor: under the nut's slot. hub_d: the hub's width. set_lengths:
// the stock set screw lengths, the longest that reaches no further than the lobe's end chosen.
// clang-format off
function crank_spec(motor, tap, press, throw, h, boss, bore, end_d, set, nut, fit, web = 1.5, skin = 3, floor = 0.6,
                    hub_d = 12, set_lengths = [ 3, 4, 5, 6, 8, 10, 12 ]) =
    let (flat_y = get(motor, "shaft_flat") - get(motor, "shaft_d") / 2,
         // the D's bottom: where the shaft's flat starts, or the crank's underside
         d0 = has(motor, "flat_l") ? max(0, bore - get(motor, "flat_l")) : 0,
         set_z = max(get(nut, "s") / 2 + fit + floor, (d0 + bore) / 2),
         // the nut's slot, and the lobe's end, measured back from the shaft's axis
         slot = [flat_y + web, flat_y + web + get(nut, "m") + 2 * fit],
         back = slot[1] + skin,
         set_l = max([for (l = set_lengths) if (l <= back - flat_y) l]))
    assert(set_z + get(set, "d") / 2 <= bore + 1, "the grub screw sits above the shaft's tip")
    assert(get(nut, "e") + 2 * fit + 2 * 1.5 <= hub_d, "the hub is too narrow round the nut's slot")
    [
        ["name", "crank"], ["motor", motor], ["tap", tap], ["press", press], ["throw", throw],
        ["h", h], ["boss", boss], ["bore", bore], ["hub_d", hub_d], ["end_d", end_d],
        ["set", set], ["nut", nut], ["fit", fit], ["set_z", set_z], ["slot", slot], ["back", back],
        // the grub screw's length, its tip on the flat and its end inside the lobe
        ["set_l", set_l],
    ];
// clang-format on

// The shaft's D section, grown by press all round: round d, flat at shaft_flat across.
module d_shaft(motor, press)
{
    d = get(motor, "shaft_d");
    flat = get(motor, "shaft_flat") - d / 2 + press;
    intersection()
    {
        circle(d = d + 2 * press);
        translate([ -d, -d ]) square([ 2 * d, d + flat ]);
    }
}

module crank(s)
{
    h = get(s, "h");
    throw = get(s, "throw");
    boss = get(s, "boss");
    difference()
    {
        union()
        {
            // the arm, and the lobe behind the hub that holds the grub screw
            linear_extrude(h) hull()
            {
                translate([ -get(s, "back") + get(s, "hub_d") / 2, 0 ]) circle(d = get(s, "hub_d"));
                translate([ throw, 0 ]) circle(d = get(s, "end_d"));
            }
            translate([ throw, 0, h - 1 ]) cylinder(d = boss[0], h = boss[1] + 1);
        }
        // the D only as far down as the shaft's flat runs from its tip, where the motor says (a GA25's stops short of
        // its bushing); round below it. Its flat faces -x, the grub screw.
        m = get(s, "motor");
        bore = get(s, "bore");
        if (has(m, "flat_l") && get(m, "flat_l") < bore)
        {
            fl = get(m, "flat_l");
            translate([ 0, 0, -1 ]) cylinder(d = get(m, "shaft_d") + 2 * get(s, "press"), h = bore - fl + 1);
            translate([ 0, 0, bore - fl - 0.5 ]) linear_extrude(fl + 0.5) rotate(90) d_shaft(m, get(s, "press"));
        }
        else
            translate([ 0, 0, -1 ]) linear_extrude(bore + 1) rotate(90) d_shaft(m, get(s, "press"));
        translate([ throw, 0, -1 ]) cylinder(d = get(s, "tap"), h = h + boss[1] + 2);
        // the grub screw's hole back along -x through the lobe, and the nut's slot across it, open at the top
        fit = get(s, "fit");
        nut = get(s, "nut");
        slot = get(s, "slot");
        translate([ 0, 0, get(s, "set_z") ]) rotate([ 0, -90, 0 ])
            cylinder(d = get(get(s, "set"), "clear"), h = get(s, "back") + 1);
        translate([ -slot[1], -get(nut, "e") / 2 - fit, get(s, "set_z") - get(nut, "s") / 2 - fit ])
            cube([ slot[1] - slot[0], get(nut, "e") + 2 * fit, h ]);
    }
}
