/**
 * @file struct.scad
 * @brief Key-value structs: a list of [key, value] pairs, read by key
 * @author Cameron K. Brooks
 * @copyright 2026
 *
 * get() fails with an error naming the struct and the key when the key is missing or its value is
 * undef. OpenSCAD does not warn when an undef reaches geometry, and an unmeasured catalog field must
 * stop the build rather than draw a 1 mm default.
 */

// The value at key k in struct s. A struct has a "name" key, used in the error message.
function get(s, k) =
    let (
        i = search([k], s, 1, 0)[0],
        who = let (n = search(["name"], s, 1, 0)[0]) n == [] ? "struct" : s[n][1]
    )
    assert(i != [], str(who, " has no '", k, "'"))
    assert(!is_undef(s[i][1]), str(who, ": '", k, "' is not known yet, measure it")) s[i][1];

// The value at key k in struct s, or undef if it is missing or undef: for an optional field.
function get_or(s, k) = let (i = search([k], s, 1, 0)[0]) i == [] ? undef : s[i][1];

// Whether struct s has key k at all, for a field only some rows carry.
function has(s, k) = search([k], s, 1, 0)[0] != [];
