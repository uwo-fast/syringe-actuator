/**
 * @file assembly.scad
 * @brief The mechanism at a crank angle, with the bought parts drawn, and the build report
 * @author Cameron K. Brooks
 * @copyright 2026
 *
 * Printed parts each have a colour: the frame wheat, the crank gold, the rod green and the clip blue.
 * The syringe is translucent, and the motor and the screws grey. The bought parts are drawn from their
 * catalog figures, simplified.
 */

// clang-format off
include <build.scad>;
// clang-format on

module assembly(L, a, bought = true)
{
    z = get(L, "axis_z");
    cp = crank_pin(L, a);
    px = clip_pin_x(L, a);
    color("wheat") frame(get(L, "frame"));
    color("gold") translate([ get(L, "crank_x"), 0, get(L, "hub_z") ]) rotate([ 0, 0, a ]) crank(get(L, "crank"));
    color("mediumseagreen") translate([ px, 0, z ]) rotate([ 0, 0, atan2(cp[1], cp[0] - px) ]) rod(get(L, "rod"));
    color("royalblue") translate([ px - get(get(L, "clip"), "pin_x"), 0, z ]) clip(get(L, "clip"));
    if (bought)
    {
        syringe(L, px - get(get(L, "clip"), "pin_x"));
        motor(L);
        screws(L, [ cp, [ px, 0 ] ]);
    }
}

// The syringe with its push-button's front face at x = button_x.
module syringe(L, button_x)
{
    s = get(L, "syringe");
    z = get(L, "axis_z");
    ft = get(s, "flange_t");
    front = -ft - get(s, "barrel_l");
    stopper = front + button_x - get(s, "exposed");
    span = get(s, "plunger_span");
    translate([ 0, 0, z ])
    {
        color("white", 0.4) translate([ front, 0, 0 ]) rotate([ 0, 90, 0 ])
            cylinder(d = get(s, "barrel_od"), h = get(s, "barrel_l"));
        color("white", 0.6) translate([ -ft, -get(s, "flange")[0] / 2, -get(s, "flange")[1] / 2 ])
            cube([ ft, get(s, "flange")[0], get(s, "flange")[1] ]);
        color("white")
        {
            translate([ button_x, 0, 0 ]) rotate([ 0, 90, 0 ]) cylinder(d = get(s, "button_d"), h = get(s, "button_t"));
            for (r = [ 0, 90 ])
                rotate([ r, 0, 0 ]) translate([ stopper, -span / 2, -0.6 ]) cube([ button_x - stopper, span, 1.2 ]);
        }
        color("dimgray") translate([ stopper, 0, 0 ]) rotate([ 0, 90, 0 ])
            cylinder(d = get(s, "barrel_od") - 1.2, h = 5);
    }
}

module motor(L)
{
    m = get(L, "motor");
    f = get(L, "face_z");
    gb = get(m, "gearbox_l");
    translate([ get(L, "crank_x"), 0, 0 ])
    {
        color("goldenrod") translate([ -get(m, "h") / 2, -get(m, "w") / 2, f - gb ])
            cube([ get(m, "h"), get(m, "w"), gb ]);
        color("silver") translate([ -get(m, "h") / 2, -get(m, "w") / 2, f - gb - get(m, "can_l") ])
            cube([ get(m, "h"), get(m, "w"), get(m, "can_l") ]);
        color("silver") translate([ 0, 0, f ]) cylinder(d = get(m, "shaft_d"), h = get(m, "shaft_l"));
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
        difference()
        {
            cylinder(d = get(washer, "od"), h = get(washer, "h"));
            translate([ 0, 0, -1 ]) cylinder(d = get(washer, "id"), h = get(washer, "h") + 2);
        }
        screw(pin, get(L, "pin_l"), get(washer, "h"));
    }
    ms_seat = get(L, "face_z") + get(L, "motor_screw_l") - get(L, "motor_thread");
    color("dimgray") for (y = [ -1, 1 ] * get(get(L, "motor"), "hole_pitch") / 2)
        translate([ get(L, "crank_x"), y, ms_seat ]) screw(ms, get(L, "motor_screw_l"), 0);
}

// A screw of length len whose head seats at z = seat.
module screw(s, len, seat)
{
    translate([ 0, 0, seat ]) cylinder(d = get(s, "head_d"), h = get(s, "head_h"));
    translate([ 0, 0, seat - len ]) cylinder(d = get(s, "d"), h = len);
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
    echo(str("screws: 2 x M3 x ", get(L, "pin_l"), " with 2 x M3 washer (crank pin, clip pin), ", get(L, "pin_thread"),
             " of thread; 2 x M1.6 x ", get(L, "motor_screw_l"), " pan head (motor), ", get(L, "motor_thread"),
             " of it into the gearbox"));
}
