/**
 * @file main.scad
 * @brief The syringe actuator: the layout, the assembly, and each printed part in its print orientation
 * @author Cameron K. Brooks
 * @copyright 2026
 *
 * The one file that draws. Open it in OpenSCAD and use the Customizer, or pass -D:
 *   openscad -D 'part="crank"' -o crank.stl cad/main.scad
 * The assembly turns with View > Animate; `angle` sets where it starts. `report` echoes the screws and
 * the derived figures.
 *
 * An in-line crank-slider: the motor shaft stands vertical on the syringe axis's line, so the crank,
 * the rod and the plunger move in one horizontal plane. The rod lies on the crank's top face and on
 * the clip's tongue, both at the axis's height, and its ends turn on bosses that the pin screws clamp
 * through washers. The clip's sled runs between rails on the frame, which take the rod's side load
 * off the plunger. Numbers in layout() without a derivation are choices, and each says why.
 *
 * FRAME: x along the syringe axis, 0 at the flange's rear face, the nozzle towards -x; z = 0 at the
 * plate's underside. The crank angle a is 0 with the pin pointing +x, away from the syringe, which is
 * the plunger pulled out; a = 180 is it pushed in. Printed parts each have their own colour; the
 * bought parts are drawn from their catalog figures, simplified.
 */

// clang-format off
include <purchased/syringes.scad>;
include <purchased/motors.scad>;
include <purchased/fasteners.scad>;
include <parts/frame.scad>;
include <parts/crank.scad>;
include <parts/rod.scad>;
include <parts/clip.scad>;
include <parts/body.scad>;
include <lib/section.scad>;
// clang-format on

// Customizer: one line per setting, so clang-format must leave the dropdown comments whole.
// clang-format off
/* [View] */
part = "assembly"; // [assembly, housed, frame, crank, rod, clip, body, lid, cap, report]
syringe = "3ml";   // [1ml, 3ml, 5ml, 10ml]
angle = 180;       // [0:5:355]
show_bought = true;
section = "none";  // [none, x, y, z]
section_at = 0;    // [-100:1:100]

/* [Print] */
fit = 0.2;   // per side: a printed pocket round bought stock
press = 0.05; // per side: the crank's bore on the steel shaft
hole = 0.1;   // per side: a small hole a screw threads itself into, which prints undersize
wall = 3;
grip = 0.15;  // per side: how far the clip's lips reach over the push-button; more holds it tighter
// clang-format on

/* [Hidden] */
$fn = 48;

chosen = syringe_by_name(syringe);
L = assert(!is_undef(chosen), str("no syringe '", syringe, "'"))
    layout(syringe = chosen, motor = n20_1000, pin = m3_shcs, pin_washer = m3_washer, motor_screw = m1_6_flat,
           fit = fit, press = press, hole = hole, wall = wall, grip = grip);

// The assembly bare or in its body, or each printed part turned to how it prints; cut open if asked.
section(section, section_at)
{
    if (part == "assembly" || part == "housed")
        assembly(L, angle + 360 * $t, bought = show_bought, body = part == "housed");
    else if (part == "frame")
        frame(get(L, "frame"));
    else if (part == "crank")
        crank(get(L, "crank"));
    else if (part == "rod")
        rod(get(L, "rod"));
    else if (part == "clip")
        translate([ 0, 0, get(get(L, "clip"), "half_w") ]) clip(get(L, "clip"));
    else if (part == "body")
        let(b = get(L, "body")) rotate([ 0, 90, 0 ]) translate([ -get(b, "x")[1], 0, 0 ]) body(b);
    else if (part == "lid")
        let(b = get(L, "body")) translate([ 0, 0, get(b, "T") + get(b, "wall") + get(b, "lid")[0] ])
            rotate([ 180, 0, 0 ]) lid(b);
    else if (part == "cap")
        let(b = get(L, "body")) rotate([ 0, 90, 0 ]) translate([ -get(b, "x")[1] - get(b, "end_t"), 0, 0 ]) cap(b);
    else if (part == "report")
        report(L);
    else
        assert(false, str("no part '", part, "'"));
}

// ---- Layout

// plate_t: stiff enough over the frame's length; pocket: the gearbox's depth into it, which locates
// it square. gap: the crank's underside over the plate, set by the shaft's tip bottoming in the
// crank's blind bore. float: the clip's underside over the plate. clip_wall: the clip's cup, which
// bears only the stroke on the push-button's rim. rod_min: the rod's shortest; it is at least three throws long,
// so it leans at most asin(1/3) = 19.5 degrees. rod_w: wide enough for 2 of wall round a boss's bore. boss_d: the
// washer overlaps the rod's bore round it by at least 0.5 a side. play: the rod's end float between
// its seat and the washer. sled: [reach past the clip's pin, depth of its top and the rails' under the
// rod]. slide: per side, the sled between the rails. recess: the motor screws' heads under the
// plate's top. motor_bore: [d, depth] of the counterbore over each motor screw, the room an ISO 7045 pan head
// takes; the flat heads bought sit in it on the clearance hole's rim, as printed and proven. margin: the stopper stops
// this short of each end of its travel, the barrel's end and the plunger's stop, for the error in exposed and stroke
// and the print. pin_l and motor_screw_l: the screws' lengths. window: how much wider the body's window is than the
// barrel's flanges, room for fingers round them.
// clang-format off
function layout(syringe, motor, pin, pin_washer, motor_screw, fit, press, hole, wall, grip,
                plate_t = 5, pocket = 2, gap = 1, float = 1.5, clip_wall = 2, rod_t = 4, rod_min = 90,
                rod_w = 10, boss_d = 5.6, play = 0.3, sled = [20, 2], slide = 0.3, recess = 0.2,
                margin = 1, pin_l = 10, motor_screw_l = 3, window = 3.5, motor_bore = [ 3.2, 1.3 ]) =
    let (
        throw = get(syringe, "stroke") / 2 - margin,
        rod_l = max(rod_min, ceil(3 * throw)),
        boss = [boss_d, rod_t + play],
        rod_bore = boss_d + 2 * fit,
        tap = get(pin, "tap") + 2 * hole,
        clip = clip_spec(syringe, tap, fit, clip_wall, boss, rod_w, sled, grip),
        axis_z = plate_t + float + get(clip, "half_w"),
        hub_z = plate_t + gap,
        bore = pocket + get(motor, "shaft_l") - hub_z,
        crank = crank_spec(motor, tap, press, throw, axis_z - hub_z, boss, bore, rod_w),
        rod = rod_spec(rod_bore, rod_l, rod_t, rod_w),
        button_in = get(syringe, "exposed") + margin,
        crank_x = button_in + get(clip, "pin_x") + rod_l + throw,
        rails = [button_in + 2 * throw + get(clip, "sled_end") + 1, get(clip, "half_w") + slide, axis_z - sled[1]],
        sweep_x = crank_x - throw - rod_w / 2,
        stack = boss[1] + get(pin_washer, "h"),
        pin_tip = axis_z + stack - pin_l,
        motor_seat_z = plate_t - motor_bore[1] - recess,
        // a flat head's cone rests where it is as wide as the clearance hole, this far under its top
        motor_head_z = motor_seat_z + (get(motor_screw, "head_d") - get(motor_screw, "clear") - 2 * fit) / 2,
        frame = frame_spec(syringe, motor, motor_screw, fit, wall, plate_t, pocket, axis_z, crank_x, rails, motor_seat_z,
                           motor_bore[0]),
        // what the frame carries at its extremes over a turn, [y, z], for the body to clear
        reach = throw + rod_w / 2,
        motor_z = pocket - get(motor, "gearbox_l") - get(motor, "can_l") - get(motor, "tail_l"),
        envelope = [
            [reach, hub_z], [reach, axis_z + rod_t],
            [throw + get(pin_washer, "od") / 2, axis_z + stack + get(pin, "head_h")],
            [get(motor, "w") / 2, motor_z],
            [get(frame, "w") / 2 + get(frame, "dovetail"), 0],
            [get(syringe, "flange")[0] / 2, axis_z + get(syringe, "flange")[1] / 2],
            [get(clip, "half_w"), axis_z + get(clip, "top")],
        ],
        // the same in front of where the rod spreads, which it is checked against separately
        front = [
            [get(frame, "w") / 2 + get(frame, "dovetail"), 0],
            [get(syringe, "flange")[0] / 2, axis_z + get(syringe, "flange")[1] / 2],
            [get(clip, "half_w"), axis_z + get(clip, "top")],
            [get(pin_washer, "od") / 2, axis_z + stack + get(pin, "head_h")],
        ],
        rod_edges = [for (x = [get(frame, "x")[0]:1:crank_x]) [x, rod_edge(x, crank_x, throw, rod_l, rod_w / 2)]],
        body = body_spec(front, concat(envelope, front), rod_edges, crank_x - reach,
                         [get(frame, "x")[0], max(crank_x + reach, get(frame, "x")[1]) + 2],
                         [button_in + 2 * throw + get(clip, "back") + 5, get(syringe, "flange")[0] + window], axis_z, get(syringe, "barrel_od"),
                         [get(frame, "w"), get(frame, "dovetail"), plate_t], get(frame, "x")[1], pin, tap,
                         motor_z + 5, fit)
    )
    assert(bore >= 5, str("the shaft reaches only ", bore, " into the crank"))
    assert(axis_z - hub_z - bore >= 1.5, "the crank's blind bore leaves under 1.5 over the shaft's tip")
    assert(pin_tip >= hub_z, str("the pin screws reach ", hub_z - pin_tip, " too low: they would drag on the plate"))
    assert(pin_l - stack >= 4, "the pin screws have under 4 of thread")
    assert(get(pin_washer, "od") - rod_bore >= 1, "the washers barely overlap the rod's bores")
    assert(rod_w - rod_bore >= 4, "the rod has under 2 of wall round its bores")
    assert(get(syringe, "barrel_l") > margin + 2 * throw, "the stroke pulls the stopper's face out of the barrel")
    assert(sweep_x - rails[0] >= 1, str("the rails reach ", rails[0] - sweep_x + 1, " into the crank's sweep"))
    assert(sled[1] >= 1, "the sled and the rails are under 1 below the rod")
    [
        ["name", "layout"], ["syringe", syringe], ["motor", motor], ["pin", pin], ["pin_l", pin_l],
        ["pin_washer", pin_washer], ["motor_screw", motor_screw], ["motor_screw_l", motor_screw_l],
        ["motor_seat_z", motor_seat_z], ["motor_head_z", motor_head_z],
        ["motor_thread", motor_screw_l - (motor_head_z - pocket)],
        ["pin_thread", pin_l - stack], ["throw", throw], ["rod_l", rod_l], ["axis_z", axis_z],
        ["pocket", pocket], ["hub_z", hub_z], ["crank_x", crank_x],
        ["frame", frame], ["crank", crank], ["rod", rod], ["clip", clip], ["body", body],
    ];
// clang-format on

// The rod's edge at x, at its widest over a turn: how far it swings off the axis there, plus half its width.
function rod_edge(x, crank_x, throw, rod_l,
                  half_w) = half_w +
                            max([for (a = [0:2:358]) let(p = [ crank_x + throw *cos(a), throw *sin(a) ],
                                                         c = p[0] - sqrt(rod_l * rod_l - p[1] * p[1])) x >= c &&
                                         x <= p[0]
                                     ? abs(p[1]) * (x - c) / (p[0] - c)
                                     : 0]);

// The crank pin's [x, y] at crank angle a.
function crank_pin(L, a) = [ get(L, "crank_x"), 0 ] + get(L, "throw") * [ cos(a), sin(a) ];

// The clip pin's x at crank angle a; it stays on the axis.
function clip_pin_x(L, a) = crank_pin(L, a)[0] - sqrt(pow(get(L, "rod_l"), 2) - pow(crank_pin(L, a)[1], 2));

// ---- Assembly and report

module assembly(L, a, bought = true, body = false)
{
    z = get(L, "axis_z");
    cp = crank_pin(L, a);
    px = clip_pin_x(L, a);
    button_x = px - get(get(L, "clip"), "pin_x");
    color("wheat") frame(get(L, "frame"));
    color("gold") translate([ get(L, "crank_x"), 0, get(L, "hub_z") ]) rotate([ 0, 0, a ]) crank(get(L, "crank"));
    color("mediumseagreen") translate([ px, 0, z ]) rotate([ 0, 0, atan2(cp[1], cp[0] - px) ]) rod(get(L, "rod"));
    color("royalblue") translate([ button_x, 0, z ]) clip(get(L, "clip"));
    if (body)
        color("lightsteelblue", 0.35)
        {
            body(get(L, "body"));
            lid(get(L, "body"));
            cap(get(L, "body"));
        }
    if (bought)
    {
        translate([ 0, 0, z ]) syringe(get(L, "syringe"), button_x);
        translate([ get(L, "crank_x"), 0, get(L, "pocket") ]) motor(get(L, "motor"));
        screws(L, [ cp, [ px, 0 ] ]);
    }
}

// The pin screws and washers on their bosses at pins [[x, y], ...], and the motor screws seated in
// their counterbores. Each screw's length is under its head.
module screws(L, pins)
{
    pin = get(L, "pin");
    washer = get(L, "pin_washer");
    ms = get(L, "motor_screw");
    seat = get(L, "axis_z") + get(get(L, "crank"), "boss")[1];
    color("silver") for (p = pins) translate([ p[0], p[1], seat ])
    {
        washer(washer);
        screw(pin, get(L, "pin_l"), get(washer, "h"));
    }
    color("dimgray") for (y = [ -1, 1 ] * get(get(L, "motor"), "hole_pitch") / 2)
        translate([ get(L, "crank_x"), y, get(L, "motor_head_z") ]) flat_screw(ms, get(L, "motor_screw_l"));
}

// Echoes what to buy and the derived figures.
module report(L)
{
    f = get(L, "frame");
    throw = get(L, "throw");
    echo(str("stroke ", 2 * throw, ", crank throw ", throw, ", rod ", get(L, "rod_l"), ", peak rod angle ",
             asin(throw / get(L, "rod_l")), " deg"));
    echo(str("frame ", get(f, "x")[1] - get(f, "x")[0], " x ", get(f, "w"), ", syringe axis ", get(L, "axis_z"),
             " above its underside"));
    b = get(L, "body");
    echo(str(
        "body ", get(b, "x")[1] - get(b, "x")[0] + 2 * get(b, "end_t"), " long; ",
        [for (sec = [ get(b, "front"), get(b, "back") ])[2 * (sec[0] + get(b, "wall")),
                                                         get(b, "T") + get(b, "lid")[0] - sec[1] + 2 * get(b, "wall")]],
        " wide x high at the front and the back, outside, with the lid"));
    echo(str("screws: 2 x M3 x ", get(L, "pin_l"), " with 2 x M3 washer (crank pin, clip pin), ", get(L, "pin_thread"),
             " of thread; 2 x ", get(get(L, "motor_screw"), "name"), " x ", get(L, "motor_screw_l"), " (motor), ",
             get(L, "motor_thread"), " of it into the gearbox; 2 x M3 x 10 (cap)"));
}
