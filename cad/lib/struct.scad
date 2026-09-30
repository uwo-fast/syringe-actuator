/**
 * @file struct.scad
 * @brief Key-value structs: a list of [key, value] pairs, read by key
 * @author Cameron K. Brooks
 * @copyright 2026
 *
 * get() fails loudly, naming the struct and the key, when the key is missing or its value is undef:
 * an undef reaching geometry is silent in OpenSCAD, and an unmeasured catalog field must stop the
 * build, not draw a 1 mm default.
 */

// The value at key k in struct s. A struct names itself with a "name" key, for the message.
function get(s, k) = let(i = search([k], s, 1, 0)[0],
                         who = let(n = search(["name"], s, 1, 0)[0]) n == [] ? "struct" : s[n][1])
    assert(i != [], str(who, " has no '", k, "'"))
        assert(!is_undef(s[i][1]), str(who, ": '", k, "' is not known yet, measure it")) s[i][1];
