#!/usr/bin/env bash
#
# Render pictures of the actuator to PNG, for the paper and the docs.
#
#   views  the rows of cad/views.tsv: a name, a syringe, a view and the -D settings that pick what
#          is drawn. $2 is a glob over the names, "*" for all; $3 a syringe that replaces every
#          row's own.
#   parts  every printed part in PARTS on its own, in its print orientation. $2 is a glob over the
#          part names, $3 the syringe (3ml unless given).
#
# Pictures land in output/figures/<syringe>/, parts under parts/, and are not committed: a change
# to the CAD makes a committed picture stale without anything noticing, so the list is what is
# kept. Previews, which keep the parts' colours and take seconds. OpenSCAD 2021.01 cannot write a
# PNG without a display, so this needs a current release; it says so rather than writing nothing.
#
set -uo pipefail
: "${OPENSCAD:=openscad}"
: "${JOBS:=$(nproc)}"
: "${OUT:=output/figures}"
# Pixels before the crop; the crop keeps the model's share of them
: "${RENDER_SIZE:=2400,1800}"
: "${RENDER_SCHEME:=Tomorrow}"
: "${PARTS:?the justfile passes PARTS}"

mode="${1:-views}"
filter="${2:-*}"
syringe="${3:-}"

tmp=$(mktemp -d) && trap 'rm -rf "$tmp"' EXIT

# A gate that reads "no ERROR" as a pass passes on a binary that draws nothing, so draw a cube first.
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
# A view is a name below, or a rotation as the GUI's Edit > Copy Viewport Rotation gives it,
# "[55.00, 0.00, 25.00]", for an angle found by eye. Every view is orthographic, as a drawing is,
# and not only for that: in perspective the eye can sit inside section()'s cutter, and the preview
# then draws the part uncut. housed with section="y" from iso_back changed 0 pixels in perspective.
# main.scad's frame: x along the syringe, the nozzle towards -x, z up, so front looks at the
# mechanism side-on and top looks down on the plane the crank, rod and plunger move in.
render_one() {
    local name syringe view flags out cam box bg
    IFS='|' read -r name syringe view flags out <<< "$1"
    case "$view" in
        iso)      cam=60,0,30 ;;
        iso_back) cam=60,0,210 ;;
        front)    cam=90,0,0 ;;
        back)     cam=90,0,180 ;;
        right)    cam=90,0,90 ;;
        left)     cam=90,0,270 ;;
        top)      cam=0,0,0 ;;
        bottom)   cam=180,0,0 ;;
        *,*,*)    cam=$(tr -d '[] ' <<< "$view") ;;
        *) echo "FAIL  $name  no view is named $view"; return ;;
    esac
    mkdir -p "$(dirname "$out")"
    # shellcheck disable=SC2086
    "$OPENSCAD" --imgsize="$RENDER_SIZE" --colorscheme="$RENDER_SCHEME" --viewall --autocenter \
        --camera="0,0,0,$cam,0" --projection=o \
        -D "syringe=\"$syringe\"" $flags -o "$out.png" cad/main.scad 2>"$out.err" >/dev/null
    # A failure keeps the log and not the picture, which could pass for a real one
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
        # The crop box of a frame holding only background is 0 wide
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
export -f render_one

# main.scad's own list, so a name it does not offer is refused here rather than drawn as an assert
syringes=$(sed -n 's/^syringe = .*\/\/ *\[\(.*\)\]/\1/p' cad/main.scad | tr -d ' ' | tr ',' ' ')
known_syringe() {
    [[ " $syringes " == *" $1 "* ]] || { echo "FAIL  no syringe is named $1; main.scad offers $syringes"; return 1; }
}

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
        syringe="${syringe:-3ml}"
        for p in $PARTS; do
            # shellcheck disable=SC2053
            [[ "$p" == $filter ]] || continue
            echo "$p|$syringe|iso|-D part=\"$p\"|$OUT/$syringe/parts/$p" >> "$jobs"
        done
        ;;
    *) echo "FAIL  the mode is views or parts, not $mode"; exit 1 ;;
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
