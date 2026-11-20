/**
 * @file cradle.scad
 * @brief The motor's cradle: a sleeve under the plate that holds the gearbox so it cannot rock
 * @author Cameron K. Brooks
 * @copyright 2026
 *
 * The rod's force reverses every stroke and acts above the gearbox's face, so it rocks the motor.
 * With only the plate's pocket and the motor's two screws to stop it, the motor worked loose. The
 * cradle grips the gearbox's sides the whole length below the plate: set screws through trapped
 * nuts push the gearbox against the far walls, so nothing is left to rock in.
 * Mounting: two M3 screws from below, through flanges at its front and back, into the plate.
 * Set screws: a rectangular gearbox gets one through the front wall and one through the -y wall; a
 * round one gets two through the front, 30 degrees either side of -x.
 * z = 0 at the plate's underside, the shaft on the z axis, the syringe towards -x. Prints top face
 * down; the nut slots open at what is then its top.
 */

// clang-format off
include <../lib/struct.scad>;
include <../purchased/motor.scad>;
// clang-format on

// pocket: the gearbox's depth up into the plate; the cradle holds the rest of it.
// screw: the plate screws; ear: their flanges' thickness, under the heads; ear_r: the flanges' reach
// round each screw. set, nut: the set screws and their nuts; fit: per side, round bought stock.
// wall: the sleeve's; skin: the boss past each nut's slot. set_lengths: stock set screw lengths.
// clang-format off
function cradle_spec(
    motor,
    pocket,
    screw,
    set,
    nut,
    fit,
    wall = 2.5,
    ear = 4,
    ear_r = 3.5,
    skin = 1.5,
    set_lengths = [3, 4, 5, 6, 8, 10, 12]
) =
    let (
        round = motor_round(motor),
        size = motor_size(motor) + [2, 2] * fit,
        depth = get(motor, "gearbox_l") - pocket,
        // each set screw's direction, and how far out the bore's wall is that way
        sets = round ? [150, 210] : [180, 270],
        reach = [for (a = sets) round ? size[0] / 2 : abs(cos(a)) * size[0] / 2 + abs(sin(a)) * size[1] / 2],
        slot_t = get(nut, "m") + 2 * fit,
        boss_l = slot_t + skin,
        boss_hw = get(nut, "e") / 2 + fit + 1.2,
        // the plate screws: one behind the gearbox, one in front beside the front boss
        back = [size[0] / 2 + wall + ear_r, 0],
        front = [-size[0] / 2 - wall - ear_r, boss_hw + ear_r],
        // the shortest stock set screw that spans the nut's slot and the wall; once on the gearbox it stays inside
        set_l = min([for (l = set_lengths) if (l >= slot_t + wall + fit) l]),
        // the furthest any part reaches across y, for the plate between the body's rails
        half_y = max(
            concat(
                [size[1] / 2 + wall, front[1] + ear_r],
                [
                    for (i = [0:len(sets) - 1]) abs(sin(sets[i])) * (reach[i] + wall + boss_l) + abs(cos(sets[i])) * boss_hw,
                ]
            )
        )
    ) assert(depth >= 5, "the gearbox reaches under 5 below the plate: too little for the cradle to hold")
    assert(set_l <= wall + boss_l, "the set screws stand out of their bosses")
    assert(get(nut, "s") / 2 + fit + 1 <= depth / 2, "the cradle is too shallow for its set screws' nuts")
    [
        ["name", "cradle"],
        ["motor", motor],
        ["fit", fit],
        ["size", size],
        ["depth", depth],
        ["wall", wall],
        ["screw", screw],
        ["ear", ear],
        ["ear_r", ear_r],
        ["set", set],
        ["nut", nut],
        ["sets", sets],
        ["reach", reach],
        ["slot_t", slot_t],
        ["boss_l", boss_l],
        ["boss_hw", boss_hw],
        ["set_l", set_l],
        ["holes", [back, front]],
        ["back_x", back[0] + ear_r],
        ["half_y", half_y],
    ];
// clang-format on

// The cradle, its top face at z = 0, the shaft on the z axis.
module cradle(s)
{
    m = get(s, "motor");
    fit = get(s, "fit");
    depth = get(s, "depth");
    wall = get(s, "wall");
    sets = get(s, "sets");
    nut = get(s, "nut");
    ear = get(s, "ear");
    sc = get(s, "screw");
    difference()
    {
        union()
        {
            translate([ 0, 0, -depth ]) linear_extrude(depth) motor_outline(m, fit + wall);
            // a boss out from the wall for each set screw, holding its nut
            for (i = [0:len(sets) - 1])
                rotate([ 0, 0, sets[i] ]) translate([ 0, -get(s, "boss_hw"), -depth ])
                    cube([ get(s, "reach")[i] + wall + get(s, "boss_l"), 2 * get(s, "boss_hw"), depth ]);
            // the flanges the plate screws go through, at the top
            for (h = get(s, "holes"))
                translate([ 0, 0, -ear ]) linear_extrude(ear) hull()
                {
                    translate(h) circle(r = get(s, "ear_r"));
                    circle(r = 1);
                }
        }
        translate([ 0, 0, -depth - 1 ]) linear_extrude(depth + 2) motor_outline(m, fit);
        for (i = [0:len(sets) - 1])
            rotate([ 0, 0, sets[i] ])
            {
                r = get(s, "reach")[i];
                // the set screw's hole out through the wall and boss, and its nut's slot, open at the bottom
                translate([ 0, 0, -depth / 2 ]) rotate([ 0, 90, 0 ])
                    cylinder(d = get(get(s, "set"), "clear"), h = r + 50);
                translate([ r + wall, -get(nut, "e") / 2 - fit, -depth - 1 ])
                    cube([ get(s, "slot_t"), get(nut, "e") + 2 * fit, depth / 2 + get(nut, "s") / 2 + fit + 1 ]);
            }
        for (h = get(s, "holes"))
            translate([ h[0], h[1], -depth - 1 ])
            {
                cylinder(d = get(sc, "clear") + 2 * fit, h = depth + 2);
                // room for the head and a driver from below, up to the flange
                cylinder(d = get(sc, "head_d") + 2 * fit + 1, h = depth + 1 - ear);
            }
    }
}
