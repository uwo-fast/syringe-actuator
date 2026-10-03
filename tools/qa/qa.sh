#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Geometry QA beyond just test, for each syringe given: thin material and thin gaps in sections of
# the body, lid, cap and frame; collisions of the body, lid and cap with every moving part over a
# turn, with the syringe dropping in through the open lid, and with the core sliding in; overhangs
# of every printed part as it prints. Each render is its own job, J at a time. With an OpenSCAD that
# has the Manifold backend it runs on that, in a few minutes.
#
# A collision is judged by the volume two things share: under a thousandth of a mm3 is two faces
# touching, which is clear. Exit 1 on a collision, a check that hits nothing it should, or a render
# that fails; slivers and overhangs are printed for review, since a section through a sloped face
# shows thin material that is not there in print.
#
# usage: tools/qa/qa.sh syringe [...]        e.g. tools/qa/qa.sh 3ml 5ml
#        OPENSCAD=/path/to/openscad J=8 QA_KEEP=1 tools/qa/qa.sh 3ml

set -uo pipefail
cd "$(dirname "$0")/../.." || exit 1
[ $# -gt 0 ] || { echo "usage: $0 syringe [...]"; exit 64; }
export Q=tools/qa
export SCAD="${OPENSCAD:-openscad}"
"$SCAD" --help 2>&1 | grep -q -- '--backend' && SCAD="$SCAD --backend=Manifold"
export W
W=$(mktemp -d)
[ -n "${QA_KEEP:-}" ] || trap 'rm -rf "$W"' EXIT
J=${J:-$(nproc)}
T0=$(date +%s)

job() { # key kind args...
    local key=$1 kind=$2
    shift 2
    local log=$W/$key.log
    case $kind in
    export) # syringe part
        $SCAD -D "syringe=\"$1\"" -D "part=\"$2\"" -o "$W/$1_$2.stl" cad/main.scad >"$log" 2>&1
        if grep -qE '^(ERROR|WARNING)' "$log" || [ ! -s "$W/$1_$2.stl" ]; then echo BROKEN; else echo ok; fi >"$W/$key" ;;
    slice) # syringe part axis at what
        $SCAD -D "syringe=\"$1\"" -D 'part="report"' -D "which=\"$2\"" -D "axis=\"$3\"" -D xc="$4" -D "what=\"$5\"" \
            -D e=0.25 -o "$W/$key.svg" "$Q/slivers.scad" >"$log" 2>&1
        if grep -q ERROR "$log"; then echo BROKEN
        elif [ ! -s "$W/$key.svg" ]; then echo none
        else python3 "$Q/svg_boxes.py" "$W/$key.svg"; fi >"$W/$key" ;;
    chk) # syringe angle other lid_dx lid_only lid_lift
        $SCAD -D "syringe=\"$1\"" -D 'part="report"' -D a="$2" -D "other=\"$3\"" -D lid_dx="$4" -D lid_only="$5" \
            -D lid_lift="$6" -o "$W/$key.stl" "$Q/sweep.scad" >"$log" 2>&1
        if grep -q ERROR "$log"; then echo BROKEN
        elif [ ! -s "$W/$key.stl" ]; then echo clear
        else
            set -- $(python3 "$Q/stl_measure.py" "$W/$key.stl")
            if [ "$1" = empty ] || python3 -c "import sys; sys.exit(0 if $1 < 0.001 else 1)"; then echo clear
            else echo "HIT($1 mm3)"; fi
        fi >"$W/$key" ;;
    esac
}
export -f job
run() { xargs -P "$J" -L 1 bash -c 'job "$@"' _ <"$1"; }
r() { python3 -c "print('%g' % round($1, 2))"; }
ANGLES=$(seq 0 15 345)

# the body's x range and the lid's travel to open, per syringe; then every part, for the overhangs
for sy in "$@"; do
    read -r bx0 bx1 open < <($SCAD -D "syringe=\"$sy\"" -D 'part="report"' -o "$W/$sy.csg" "$Q/body.scad" 2>&1 |
        grep -oE 'qa-body [-0-9.]+ [-0-9.]+ [-0-9.]+' | cut -d' ' -f2-)
    [ -n "${open:-}" ] || { echo "BROKEN: no body for syringe '$sy'"; exit 1; }
    echo "$bx0 $bx1 $open" >"$W/body_$sy"
    for p in frame crank rod clip body lid cap; do echo "e_${sy}_$p export $sy $p"; done
done >"$W/jobs1"
run "$W/jobs1"

for sy in "$@"; do
    read -r bx0 bx1 open <"$W/body_$sy"
    for x in $(python3 -c "import math; print(' '.join('%g' % x for x in range(math.floor($bx0 / 4) * 4, math.ceil($bx1), 4)))") $(r "$bx1+1"); do
        echo "s_${sy}_body_x_$x"; done
    for y in 0 1 1.4 2 5 10 11.4 12 12.5 13 13.5 14 14.5 15 15.5 16 16.5 17 17.5 18 18.5 19 19.5 20 21 22 25 30 35; do
        echo "s_${sy}_body_y_$y"; done
    for z in -30 -27 -25 -22 -20 -17 -15 -12 -10 -7 -5 -3 -2.5 -1 0 0.3 1 2.5 3 4 5 6 10 15 20 24 25 26 26.8 27.1 27.5 \
        27.9 28.3 28.8 29.2; do echo "s_${sy}_body_z_$z"; done
    for c in "lid_x_-25" lid_x_0 lid_x_40 lid_x_80 lid_x_81 lid_y_0 lid_y_10 lid_y_15.5 lid_y_16.5 lid_z_27.4 lid_z_28 \
        lid_z_28.5 lid_z_29.2 "cap_x_$(r "$bx1+2.2")" "cap_x_$(r "$bx1-15.8")" "cap_x_$(r "$bx1-35.8")" cap_y_0 cap_y_6 \
        cap_y_15 cap_y_19 cap_z_2 cap_z_-15 cap_z_-20 cap_z_20 cap_z_28 frame_x_0 frame_x_50 frame_x_120 frame_z_0.3 \
        frame_z_1 frame_z_2; do echo "s_${sy}_$c"; done
done >"$W/slices"
while read -r k; do
    IFS=_ read -r _ sy part axis at <<<"$k"
    for w in material gap; do echo "${k}_$w slice $sy $part $axis $at $w"; done
done <"$W/slices" >"$W/jobs2"
for sy in "$@"; do
    read -r bx0 bx1 open <"$W/body_$sy"
    echo "c_${sy}_probe chk $sy 0 probe 0 false 0"
    echo "c_${sy}_lidprobe chk $sy 0 lidprobe 0 true 0"
    for o in crank rod clip screws frame motor syringe; do for a in $ANGLES; do echo "c_${sy}_${o}_$a chk $sy $a $o 0 false 0.05"; done; done
    for a in $ANGLES; do echo "c_${sy}_loading_$a chk $sy $a loading $open false 0.05"; done
    for a in 0 90 180 270; do echo "c_${sy}_insert_$a chk $sy $a insert -1 false 0"; done
    for dx in 0 0.5 1 1.5 2 3 4 4.5 5 6 10 30 60 90 "$open" "$(r "$open+1.3")"; do echo "c_${sy}_tube_$dx chk $sy 0 tube $dx true 0.05"; done
done >>"$W/jobs2"
run "$W/jobs2"

# the report
failed=0
v() { cat "$W/$1" 2>/dev/null || echo MISSING; }
bad() { echo "  FAIL  $*"; failed=1; }
for sy in "$@"; do
    read -r bx0 bx1 open <"$W/body_$sy"
    echo "######## $sy"
    echo "== slivers (material or air under 0.5 across; a section through a sloped face shows some that print fine)"
    while read -r k; do
        m=$(v "${k}_material"); g=$(v "${k}_gap")
        [[ "$m$g" == *BROKEN* || "$m$g" == *MISSING* ]] && bad "slice ${k#s_${sy}_}: $m $g"
        [ "$m$g" = nonenone ] || echo "${k#s_${sy}_}  material: $m  gap: $g" | sed -E 's/^(body|lid|cap|frame)_([xyz])_/\1 \2 /'
    done < <(grep "^s_${sy}_" "$W/slices")
    echo "== collisions"
    p=$(v "c_${sy}_probe"); lp=$(v "c_${sy}_lidprobe")
    echo "controls: probe $p, lidprobe $lp"
    [[ $p == HIT* && $lp == HIT* ]] || bad "a control did not hit: the sweep cannot see a collision"
    for o in crank rod clip screws frame motor syringe; do
        h=""; for a in $ANGLES; do c=$(v "c_${sy}_${o}_$a"); [ "$c" = clear ] || h="$h $a:$c"; done
        echo "shut, $o: ${h:-clear at 24 angles}"; [ -z "$h" ] || bad "$o hits the body, lid or cap"
    done
    h=""; for a in $ANGLES; do c=$(v "c_${sy}_loading_$a"); [ "$c" = clear ] || h="$h $a:$c"; done
    echo "loading through the lid slid back $open: ${h:-clear at 24 clip positions}"; [ -z "$h" ] || bad "the syringe hits on its way in"
    for a in 0 90 180 270; do
        c=$(v "c_${sy}_insert_$a"); echo "core sliding in, crank $a: $c"; [ "$c" = clear ] || bad "the core hits the tube sliding in"
    done
    printf 'lid lifted 0.05 off the roof, slid back by: '
    for dx in 0 0.5 1 1.5 2 3 4 4.5 5 6 10 30 60 90 "$open" "$(r "$open+1.3")"; do c=$(v "c_${sy}_tube_$dx"); printf '%s:%s ' "$dx" "${c%%(*}"; done
    echo "(it rides over the detent's ridge from about 1.5 to 4)"
    echo "== overhangs (as each part prints)"
    for p in frame crank rod clip body lid cap; do [ "$(v "e_${sy}_$p")" = ok ] || bad "export of $p"; done
    python3 "$Q/overhangs.py" "$W/${sy}"_{body,lid,cap,frame,crank,rod,clip}.stl | sed "s#^${sy}_##"
done
echo "######## $(( $(date +%s) - T0 )) s, $( [ $failed = 0 ] && echo 'no failures' || echo FAILED)"
exit $failed
