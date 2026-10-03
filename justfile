# Project task runner

set dotenv-load := false

OPENSCAD := env("OPENSCAD", "openscad")

# The one entry point. Every other .scad file is a library and must draw nothing on its own.
MAIN := "cad/main.scad"

# Printed parts, by main.scad's `part` names. `test` checks each; `export` writes each to output/.
PARTS := "frame crank rod clip body lid cap"

# The builds, by main.scad's `syringe` names. `test` checks every part of each; `build` writes each to
# build/<syringe>/.
SYRINGES := "1ml 3ml 5ml"

default:
    @just --list

# Verify the toolchain. Nothing links to an external library.
setup:
    #!/usr/bin/env bash
    set -uo pipefail
    command -v {{OPENSCAD}} >/dev/null || { echo "openscad not found"; exit 1; }
    {{OPENSCAD}} --version 2>&1 | head -1
    command -v clang-format >/dev/null || echo "warning: clang-format not found; fmt-check will skip"
    command -v python3 >/dev/null || echo "warning: python3 not found; test cannot check edges"

# Format the SCAD sources in place.
fmt:
    @[ -d cad ] && find cad -name '*.scad' -print0 | xargs -0 -r clang-format -i; echo "formatted"

# Verify formatting (non-mutating).
fmt-check:
    #!/usr/bin/env bash
    set -uo pipefail
    command -v clang-format >/dev/null || { echo "skip  formatting (clang-format not installed)"; exit 0; }
    files=$([ -d cad ] && find cad -name '*.scad' | sort)
    [ -n "$files" ] || { echo "skip  formatting (no SCAD sources yet)"; exit 0; }
    failed=0
    while read -r f; do
        clang-format --dry-run --Werror "$f" 2>/dev/null || { echo "FAIL  $f  not formatted"; failed=1; }
    done <<<"$files"
    [ "$failed" = 0 ] && echo "ok    formatting"
    exit $failed

lint: check-scad

# Everything CI runs, bar the tests.
check: fmt-check check-scad

# A failing assert still exits 0 under `-o *.csg`, so ERROR and WARNING on stderr are the signal,
# never $?. main.scad must draw; every library must draw nothing.
# Evaluate every SCAD file.
check-scad:
    #!/usr/bin/env bash
    set -uo pipefail
    files=$([ -d cad ] && find cad -name '*.scad' | sort)
    [ -n "$files" ] || { echo "skip  SCAD evaluation (no SCAD sources yet)"; exit 0; }
    [ -f "{{MAIN}}" ] || { echo "FAIL  SCAD sources exist but {{MAIN}}, the entry point, does not"; exit 1; }
    tmp=$(mktemp -d) && trap 'rm -rf "$tmp"' EXIT
    failed=0
    while read -r f; do
        out="$tmp/$(echo "$f" | tr / _).csg"
        {{OPENSCAD}} -o "$out" "$f" 2>"$tmp/err"
        size=$(stat -c%s "$out" 2>/dev/null || echo 0)
        if grep -qE '^(ERROR|WARNING)' "$tmp/err"; then
            echo "FAIL  $f"; grep -E '^(ERROR|WARNING)' "$tmp/err" | head -5 | sed 's/^/        /'; failed=1
        elif [ "$f" = "{{MAIN}}" ] && [ "$size" -le 1 ]; then
            echo "FAIL  $f  draws nothing"; failed=1
        elif [ "$f" != "{{MAIN}}" ] && [ "$size" -gt 1 ]; then
            echo "FAIL  $f  draws geometry; only {{MAIN}} may"; failed=1
        else
            printf 'ok    %-40s %s\n' "$f" "$([ "$f" = "{{MAIN}}" ] && echo "$size bytes" || echo 'library')"
        fi
    done <<<"$files"
    exit $failed

# .csg does not render, so only an STL export can see a broken or disconnected part; tools/stl_edges.py
# counts the solids and the edges where two meet, from the mesh, so any OpenSCAD's export reads the same.
# Every printed part, for every syringe, must export as one closed solid.
test:
    #!/usr/bin/env bash
    set -uo pipefail
    [ -n "{{PARTS}}" ] || { echo "skip  part exports (PARTS is empty: no printed part yet)"; exit 0; }
    tmp=$(mktemp -d) && trap 'rm -rf "$tmp"' EXIT
    failed=0
    for s in {{SYRINGES}}; do
        for p in {{PARTS}}; do
            rm -f "$tmp/out.stl"
            {{OPENSCAD}} -o "$tmp/out.stl" -D "syringe=\"$s\"" -D "part=\"$p\"" {{MAIN}} 2>"$tmp/err"
            if grep -qE '^(ERROR|WARNING)' "$tmp/err"; then
                echo "FAIL  $s $p"; grep -E '^(ERROR|WARNING)' "$tmp/err" | head -5 | sed 's/^/        /'; failed=1
            elif ! edges=$(python3 tools/stl_edges.py "$tmp/out.stl"); then
                echo "FAIL  $s $p  ${edges#*out.stl  }"; failed=1
            else
                printf 'ok    %-4s %-13s one closed solid, every edge manifold\n' "$s" "$p"
            fi
        done
    done
    exit $failed

# Export one syringe's printed parts to output/<part>.stl, the spot for one-off exports.
export syringe="3ml":
    #!/usr/bin/env bash
    set -uo pipefail
    [ -n "{{PARTS}}" ] || { echo "skip  export (PARTS is empty: no printed part yet)"; exit 0; }
    mkdir -p output
    for p in {{PARTS}}; do
        rm -f "output/$p.stl"
        {{OPENSCAD}} -o "output/$p.stl" -D 'syringe="{{syringe}}"' -D "part=\"$p\"" {{MAIN}} 2>"output/$p.err"
        if grep -qE '^(ERROR|WARNING)' "output/$p.err"; then echo "FAIL  $p"; exit 1; fi
        rm -f "output/$p.err"; printf 'ok    output/%s.stl\n' "$p"
    done

# Export every printed part for every syringe to build/<syringe>/<part>.stl.
build:
    #!/usr/bin/env bash
    set -uo pipefail
    [ -n "{{PARTS}}" ] || { echo "skip  build (PARTS is empty: no printed part yet)"; exit 0; }
    for s in {{SYRINGES}}; do
        mkdir -p "build/$s"
        for p in {{PARTS}}; do
            rm -f "build/$s/$p.stl"
            {{OPENSCAD}} -o "build/$s/$p.stl" -D "syringe=\"$s\"" -D "part=\"$p\"" {{MAIN}} 2>"build/$s/$p.err"
            if grep -qE '^(ERROR|WARNING)' "build/$s/$p.err"; then echo "FAIL  $s $p"; exit 1; fi
            rm -f "build/$s/$p.err"; printf 'ok    build/%s/%s.stl\n' "$s" "$p"
        done
    done

clean:
    rm -rf output build
