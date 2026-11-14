// For tools/qa/qa.sh: the body's inside, front to back; how far the lid slides back to clear the
// window; the roof's underside T and the lid's underside. Run with -D 'part="report"' so main draws
// nothing of its own.
// clang-format off
include <../../cad/main.scad>;
// clang-format on

B = get(L, "body");
echo(str("qa-body ", get(B, "x")[0], " ", get(B, "x")[1], " ", get(B, "window")[0] - get(B, "lid_x")[0], " ",
         get(B, "T"), " ", get(B, "T") + get(B, "wall")));
