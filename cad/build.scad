/**
 * @file build.scad
 * @brief layout(): the bought parts and the design's choices in, every part's spec and position out
 * @author Cameron K. Brooks
 * @copyright 2026
 *
 * The one place the parts are arranged. An in-line crank-slider: the motor shaft stands vertical on
 * the syringe axis's line, so the crank, the rod and the plunger move in one horizontal plane. The
 * rod lies on the crank's top face and on the clip's tongue, both at the axis's height, and its ends
 * turn on bosses that the pin screws clamp through washers. The clip's sled runs between rails on the
 * frame, which take the rod's side load off the plunger.
 * Numbers written here without a derivation are choices, and each says why.
 *
 * FRAME: x along the syringe axis, 0 at the flange's rear face, the nozzle towards -x; z = 0 at the
 * plate's underside. The crank angle a is 0 with the pin pointing +x, away from the syringe, which is
 * the plunger pulled out; a = 180 is it pushed in.
 */

// clang-format off
include <parts/frame.scad>;
include <parts/crank.scad>;
include <parts/rod.scad>;
include <parts/clip.scad>;
// clang-format on

// plate_t: stiff enough over the frame's length; pocket: the gearbox's depth into it, which locates
// it square. gap: the crank's underside over the plate, set by the shaft's tip bottoming in the
// crank's blind bore. float: the clip's underside over the plate. clip_wall: the clip's cup, which
// bears only the stroke on the push-button's rim. rod_l: at least three throws, so the rod leans at
// most asin(1/3) = 19.5 degrees. rod_w: wide enough for 2 of wall round a boss's bore. boss_d: the
// washer overlaps the rod's bore round it by at least 0.5 a side. play: the rod's end float between
// its seat and the washer. sled: [reach past the clip's pin, depth of its top and the rails' under the
// rod]. slide: per side, the sled between the rails. recess: the motor screws' heads under the
// plate's top. margin: the stopper stops this short of the barrel's end, for the error in exposed and
// the print. pin_l and motor_screw_l: the screws' lengths.
// clang-format off
function layout(syringe, motor, pin, pin_washer, motor_screw, fit, press, wall,
                plate_t = 5, pocket = 2, gap = 1, float = 1.5, clip_wall = 2, rod_t = 4, rod_l = 90,
                rod_w = 10, boss_d = 5.6, play = 0.3, sled = [20, 2], slide = 0.3, recess = 0.2,
                margin = 1, pin_l = 10, motor_screw_l = 3) =
    let (
        throw = get(syringe, "stroke") / 2,
        boss = [boss_d, rod_t + play],
        hole = boss_d + 2 * fit,
        clip = clip_spec(syringe, pin, fit, clip_wall, boss, rod_w, sled),
        axis_z = plate_t + float + get(clip, "half_w"),
        hub_z = plate_t + gap,
        bore = pocket + get(motor, "shaft_l") - hub_z,
        crank = crank_spec(motor, pin, press, throw, axis_z - hub_z, boss, bore, rod_w),
        rod = rod_spec(hole, rod_l, rod_t, rod_w),
        button_in = get(syringe, "exposed") + margin,
        crank_x = button_in + get(clip, "pin_x") + rod_l + throw,
        rails = [button_in + 2 * throw + get(clip, "sled_end") + 1, get(clip, "half_w") + slide, axis_z - sled[1]],
        sweep_x = crank_x - throw - rod_w / 2,
        stack = boss[1] + get(pin_washer, "h"),
        pin_tip = axis_z + stack - pin_l,
        motor_seat_z = plate_t - get(motor_screw, "head_h") - recess
    )
    assert(bore >= 5, str("the shaft reaches only ", bore, " into the crank"))
    assert(axis_z - hub_z - bore >= 1.5, "the crank's blind bore leaves under 1.5 over the shaft's tip")
    assert(pin_tip >= hub_z, str("the pin screws reach ", hub_z - pin_tip, " too low: they would drag on the plate"))
    assert(pin_l - stack >= 4, "the pin screws have under 4 of thread")
    assert(get(pin_washer, "od") - hole >= 1, "the washers barely overlap the rod's bores")
    assert(rod_w - hole >= 4, "the rod has under 2 of wall round its bores")
    assert(rod_l >= 3 * throw, "the rod is under three throws long")
    assert(sweep_x - rails[0] >= 1, str("the rails reach ", rails[0] - sweep_x + 1, " into the crank's sweep"))
    assert(sled[1] >= 1, "the sled and the rails are under 1 below the rod")
    [
        ["name", "layout"], ["syringe", syringe], ["motor", motor], ["pin", pin], ["pin_l", pin_l],
        ["pin_washer", pin_washer], ["motor_screw", motor_screw], ["motor_screw_l", motor_screw_l],
        ["motor_seat_z", motor_seat_z], ["motor_thread", motor_screw_l - (motor_seat_z - pocket)],
        ["pin_thread", pin_l - stack], ["throw", throw], ["rod_l", rod_l], ["axis_z", axis_z],
        ["pocket", pocket], ["hub_z", hub_z], ["crank_x", crank_x],
        ["frame", frame_spec(syringe, motor, motor_screw, fit, wall, plate_t, pocket, axis_z, crank_x, rails,
                             motor_seat_z)],
        ["crank", crank], ["rod", rod], ["clip", clip],
    ];
// clang-format on

// The crank pin's [x, y] at crank angle a.
function crank_pin(L, a) = [ get(L, "crank_x"), 0 ] + get(L, "throw") * [ cos(a), sin(a) ];

// The clip pin's x at crank angle a; it stays on the axis.
function clip_pin_x(L, a) = crank_pin(L, a)[0] - sqrt(pow(get(L, "rod_l"), 2) - pow(crank_pin(L, a)[1], 2));
