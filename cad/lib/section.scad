/**
 * @file section.scad
 * @brief section(): cut its children open along a plane, to look inside
 * @author Cameron K. Brooks
 * @copyright 2026
 */

// Its children, less everything on the + side of the plane square to axis ("x", "y" or "z") at at.
// axis = "none" passes them through whole. size: the cutter, bigger than anything cut.
module section(axis = "none", at = 0, size = 1000)
{
    n = axis == "x" ? [ 1, 0, 0 ] : axis == "y" ? [ 0, 1, 0 ] : axis == "z" ? [ 0, 0, 1 ] : undef;
    assert(axis == "none" || !is_undef(n), str("section: no axis '", axis, "'"));
    if (axis == "none")
        children();
    else
        difference()
        {
            children();
            translate(n * (at + size / 2)) cube(size, center = true);
        }
}
