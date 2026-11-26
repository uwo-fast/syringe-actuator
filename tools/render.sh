#!/usr/bin/env bash
#
# Render pictures of the actuator to PNG, for the paper and the docs.
#
#   views  the rows of cad/views.tsv: a name, a syringe, a view and the -D settings that select what
#          is drawn. $2 is a glob over the names, "*" for all; $3 is a syringe that overrides the
#          syringe in every row.
#   parts  every printed part in PARTS on its own, in its print orientation. $2 is a glob over the
#          part names, $3 the syringe (5ml-gnr2 unless given).
#   stroke one turn of the crank as an animated GIF, FRAMES frames (36 unless set). $2 is the view
#          (top unless given), $3 the syringe (5ml-gnr2 unless given), $4 any further -D settings.
#
# Pictures are written to output/figures/<syringe>/, with parts under parts/, and are not committed:
# a CAD change would make a committed picture stale without any check noticing, so only the list is
# committed. The pictures are previews, which keep the part colours and take seconds. OpenSCAD
# 2021.01 cannot write a PNG without a display, so this needs a current release; the script reports
# that instead of silently writing nothing.
#
set -uo pipefail
: "${OPENSCAD:=openscad}"
: "${JOBS:=$(nproc)}"
: "${OUT:=output/figures}"
# Image size in pixels before the crop; the crop keeps the part of the image the model occupies
: "${RENDER_SIZE:=2400,1800}"
: "${RENDER_SCHEME:=Tomorrow}"
: "${PARTS:?the justfile passes PARTS}"

mode="${1:-views}"
filter="${2:-*}"
syringe="${3:-}"

tmp=$(mktemp -d) && trap 'rm -rf "$tmp"' EXIT

# A check that treats "no ERROR" as a pass also passes on a binary that draws nothing, so draw a cube first.
echo 'cube(1);' > "$tmp/cube.scad"
"$OPENSCAD" --imgsize=64,64 -o "$tmp/cube.png" "$tmp/cube.scad" >/dev/null 2>"$tmp/cube.err"
if [ ! -s "$tmp/cube.png" ]; then
    echo "FAIL  $OPENSCAD ($("$OPENSCAD" --version 2>&1 | tail -1)) cannot write a PNG here"
    head -3 "$tmp/cube.err" | sed 's/^/        /'
    exit 1
fi
echo "note  $("$OPENSCAD" --version 2>&1 | tail -1)"
# The crop and the blank check need ImageMagick; without it the pictures are written as rendered
if command -v magick >/dev/null; then MAGICK=1; else
    MAGICK=0; echo "skip  crop and blank check (ImageMagick not installed)"
fi
export OPENSCAD RENDER_SIZE RENDER_SCHEME MAGICK

# One picture. A job is "name|syringe|view|flags|out", out without its extension.
#
# A view is a name below, or a rotation in the format the GUI's Edit > Copy Viewport Rotation gives,
# "[55.00, 0.00, 25.00]", for an angle found by eye. Every view is orthographic, like a drawing. This
# is also needed because in perspective the camera can sit inside the section() cutter, and the
# preview then draws the part uncut: housed with section="y" from iso_back changed 0 pixels in
# perspective. Coordinates are those of main.scad: x along the syringe, the nozzle towards -x, z up.
# So front shows the mechanism from the side, and top looks down on the plane the crank, rod and
# plunger move in.
view_rotation() {
    case "$1" in
        iso)      echo 60,0,30 ;;
        iso_back) echo 60,0,210 ;;
        front)    echo 90,0,0 ;;
        back)     echo 90,0,180 ;;
        right)    echo 90,0,90 ;;
        left)     echo 90,0,270 ;;
        top)      echo 0,0,0 ;;
        bottom)   echo 180,0,0 ;;
        *,*,*)    tr -d '[] ' <<< "$1" ;;
        *) return 1 ;;
    esac
}
render_one() {
    local name syringe view flags out cam box bg
    IFS='|' read -r name syringe view flags out <<< "$1"
    cam=$(view_rotation "$view") || { echo "FAIL  $name  no view is named $view"; return; }
    mkdir -p "$(dirname "$out")"
    # shellcheck disable=SC2086
    "$OPENSCAD" --imgsize="$RENDER_SIZE" --colorscheme="$RENDER_SCHEME" --viewall --autocenter \
        --camera="0,0,0,$cam,0" --projection=o \
        -D "syringe=\"$syringe\"" $flags -o "$out.png" cad/main.scad 2>"$out.err" >/dev/null
    # On failure, keep the log but not the picture, which could be mistaken for a real one
    if grep -qE '^(ERROR|WARNING)' "$out.err"; then
        echo "FAIL  $name  $(grep -m1 -E '^(ERROR|WARNING)' "$out.err")"
        rm -f "$out.png"
        return
    fi
    if [ ! -s "$out.png" ]; then
        echo "FAIL  $name  wrote no picture; see $out.err"
        return
    fi
    if [ "$MAGICK" = 1 ]; then
        # The crop box of an image containing only background is 0 wide
        box=$(magick "$out.png" -fuzz 2% -format '%@' info: 2>/dev/null)
        if [[ "$box" == 0x* ]]; then
            echo "FAIL  $name  drew nothing ($flags)"
            rm -f "$out.png"
            return
        fi
        bg=$(magick "$out.png" -format '%[pixel:p{0,0}]' info:)
        magick "$out.png" -fuzz 2% -trim +repage -bordercolor "$bg" -border 40 "$out.png"
    fi
    rm -f "$out.err"
    echo "ok    $name  $out.png"
}
export -f render_one view_rotation

# The part list from main.scad, so an unknown name is refused here rather than failing on an assert
syringes=$(sed -n 's/^syringe = .*\/\/ *\[\(.*\)\]/\1/p' cad/main.scad | tr -d ' ' | tr ',' ' ')
known_syringe() {
    [[ " $syringes " == *" $1 "* ]] || { echo "FAIL  no syringe is named $1; main.scad offers $syringes"; return 1; }
}

# ----- one turn of the crank, as a GIF -----
#
# The camera stays fixed for the whole turn: --viewall would fit each frame to its own crank position,
# and the picture would jump. So every frame is first exported as an STL (a fraction of a second each),
# the camera is aimed at the centre of all of them and moved back beyond their extent, and every frame
# is cropped to the single box that contains them all.
if [ "$mode" = stroke ]; then
    view="${2:-top}"
    syringe="${3:-5ml-gnr2}"
    flags="${4:-}"
    : "${FRAMES:=36}"
    known_syringe "$syringe" || exit 1
    cam=$(view_rotation "$view") || { echo "FAIL  no view is named $view"; exit 1; }
    [ "$MAGICK" = 1 ] || { echo "FAIL  a GIF needs ImageMagick, which is not installed"; exit 1; }
    d="$tmp/stroke"
    mkdir -p "$d"
    for ((i = 0; i < FRAMES; i++)); do printf '%03d\n' $((i * 360 / FRAMES)); done > "$d/angles"
    # shellcheck disable=SC2016 # the child shell expands them
    xargs -P "$JOBS" -I{} bash -c '"$OPENSCAD" -D "syringe=\"$1\"" $3 -D angle="$((10#$2))" \
        -o "$4/$2.stl" cad/main.scad 2>"$4/$2.err" >/dev/null' _ "$syringe" {} "$flags" "$d" < "$d/angles"
    if grep -qE '^(ERROR|WARNING)' "$d"/*.err; then
        echo "FAIL  stroke  $(grep -h -m1 -E '^(ERROR|WARNING)' "$d"/*.err | head -1)"
        exit 1
    fi
    # The centre of the bounds of all frames, and a camera distance that shows all of them: an
    # orthographic view shows about 0.4 of its distance across, so 3 diagonals leave a margin, which
    # the crop then removes.
    cam_at=$(/usr/bin/python3 -c 'import sys, math
lo, hi = [math.inf] * 3, [-math.inf] * 3
for f in sys.argv[1:]:
    for line in open(f):
        w = line.split()
        if w[:1] == ["vertex"]:
            for k in range(3):
                v = float(w[k + 1]); lo[k] = min(lo[k], v); hi[k] = max(hi[k], v)
if lo[0] == math.inf:
    sys.exit("the frames drew nothing")
c = [(a + b) / 2 for a, b in zip(lo, hi)]
print("%g,%g,%g" % tuple(c), "%g" % (3 * math.dist(lo, hi)))' "$d"/*.stl) || { echo "FAIL  stroke  $cam_at"; exit 1; }
    read -r centre dist <<< "$cam_at"
    # shellcheck disable=SC2016
    xargs -P "$JOBS" -I{} bash -c '"$OPENSCAD" --imgsize="$RENDER_SIZE" --colorscheme="$RENDER_SCHEME" \
        --camera="$5,$6,$7" --projection=o -D "syringe=\"$1\"" $3 -D angle="$((10#$2))" \
        -o "$4/$2.png" cad/main.scad 2>"$4/$2.err" >/dev/null' _ "$syringe" {} "$flags" "$d" "$centre" "$cam" "$dist" < "$d/angles"
    if grep -qE '^(ERROR|WARNING)' "$d"/*.err || [ "$(find "$d" -name '*.png' -size +0 | wc -l)" -ne "$FRAMES" ]; then
        echo "FAIL  stroke  a frame did not render"
        exit 1
    fi
    # One crop for every frame: the union of the boxes of all frames
    box=$(for f in "$d"/*.png; do magick "$f" -fuzz 2% -format '%@\n' info:; done | /usr/bin/python3 -c 'import sys, re
b = [tuple(map(int, re.match(r"(\d+)x(\d+)\+(\d+)\+(\d+)", l).groups())) for l in sys.stdin if l.strip()]
b = [x for x in b if x[0] > 0]
if not b:
    sys.exit("every frame is empty")
x0 = min(x[2] for x in b); y0 = min(x[3] for x in b)
x1 = max(x[2] + x[0] for x in b); y1 = max(x[3] + x[1] for x in b)
print(f"{x1 - x0}x{y1 - y0}+{x0}+{y0}")') || { echo "FAIL  stroke  drew nothing"; exit 1; }
    # the settings go in the file name, so a housed turn does not overwrite the bare one: part-housed
    slug=$(sed -E 's/-D +//g; s/[^A-Za-z0-9.]+/-/g; s/^-+|-+$//g' <<< "$flags")
    out="$OUT/$syringe/stroke_$view${slug:+_$slug}.gif"
    mkdir -p "$(dirname "$out")"
    bg=$(magick "$d/000.png" -format '%[pixel:p{0,0}]' info:)
    # A turn in about three seconds: GIF delays are in hundredths
    # +dither: a GIF has 256 colours, and dithering the translucent parts to fit them speckles them
    # differently in each frame
    magick -delay $((300 / FRAMES)) -loop 0 "$d"/*.png -crop "$box" +repage -bordercolor "$bg" \
        -border 40 +dither -layers Optimize "$out"
    echo "ok    stroke  $out  ($FRAMES frames, $(du -h "$out" | cut -f1))"
    exit 0
fi

jobs="$tmp/jobs"
: > "$jobs"
case "$mode" in
    views)
        # name, syringe, view, flags: tab-separated, # starts a comment
        while IFS=$'\t' read -r name s view flags; do
            [[ -z "$name" || "$name" == \#* ]] && continue
            # shellcheck disable=SC2053
            [[ "$name" == $filter ]] || continue
            s="${syringe:-$s}"
            echo "$name|$s|$view|${flags:-}|$OUT/$s/$name" >> "$jobs"
        done < cad/views.tsv
        ;;
    parts)
        syringe="${syringe:-5ml-gnr2}"
        for p in $PARTS; do
            # shellcheck disable=SC2053
            [[ "$p" == $filter ]] || continue
            echo "$p|$syringe|iso|-D part=\"$p\"|$OUT/$syringe/parts/$p" >> "$jobs"
        done
        ;;
    *) echo "FAIL  the mode is views, parts or stroke, not $mode"; exit 1 ;;
esac

if [ ! -s "$jobs" ]; then
    echo "FAIL  nothing matches $filter"
    exit 1
fi
while read -r s; do
    known_syringe "$s" || exit 1
done < <(cut -d'|' -f2 "$jobs" | sort -u)

# shellcheck disable=SC2016 # $1 is the child shell's, not this one's
xargs -d '\n' -P "$JOBS" -I{} bash -c 'render_one "$1"' _ {} < "$jobs" | tee "$tmp/log"
n=$(wc -l < "$jobs")
if grep -q '^FAIL' "$tmp/log"; then
    echo "FAIL  $(grep -c '^FAIL' "$tmp/log") of $n pictures did not render"
    exit 1
fi
echo "ok    $n pictures in $OUT"
