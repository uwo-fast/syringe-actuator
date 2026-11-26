// For tools/qa/qa.sh: the inside of the body, front to back; how far the lid slides back to clear the
// window; the roof underside T, and the lid underside and back end when shut. Run with -D 'part="report"'
// so main draws nothing of its own.
include <../../cad/main.scad>;

B = get(L, "body");
echo(
    str(
        "qa-body ", get(B, "x")[0], " ", get(B, "x")[1], " ", get(B, "window_v") - get(B, "lid_x")[0], " ",
        get(B, "T"), " ", get(B, "T") + get(B, "wall"), " ", get(B, "lid_x")[1]
    )
);
