/**
 * @file rod.scad
 * @brief The connecting rod, crank pin to plunger clip
 * @author Cameron K. Brooks
 * @copyright 2026
 *
 * Both ends turn on the bosses of the crank and the clip, under the washers the pin screws clamp.
 * z = 0 at the underside, the clip end at the origin, the crank end on +x. Prints flat.
 */

// clang-format off
include <../lib/struct.scad>;
// clang-format on

// clang-format off
// hole: the bore round each boss.
function rod_spec(hole, len, t, w) = [
    ["name", "rod"], ["hole", hole], ["len", len], ["t", t], ["w", w],
];
// clang-format on

module rod(s)
{
    len = get(s, "len");
    t = get(s, "t");
    difference()
    {
        linear_extrude(t) hull()
        {
            circle(d = get(s, "w"));
            translate([ len, 0 ]) circle(d = get(s, "w"));
        }
        for (x = [ 0, len ])
            translate([ x, 0, -1 ]) cylinder(d = get(s, "hole"), h = t + 2);
    }
}
