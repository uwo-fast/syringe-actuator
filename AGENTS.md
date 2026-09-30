# AGENTS.md

Instructions for AI coding agents working in this repository.

## Project

Printed parts that connect an N20 gearmotor to a luer syringe so the plunger strokes back and forth
continuously. The motor runs in one direction straight off a supply; a printed crank and
connecting rod do the rest. Read [`docs/design.md`](docs/design.md) before changing anything: it
holds the mechanism, the part dimensions and what is open.

**Scope is the mechanism only.** What the syringe is connected to, and anything that powers or
controls the motor, belong to other projects. Do not design for them here.

**The constraint that shapes every decision:** printed parts, one syringe, one DC gearmotor and a
few screws. No guide rods, lead screws, linear bearings or stepper. A change that adds bought
hardware has to say why a printed part cannot do the job.

## Stack

- **CAD** — OpenSCAD 2021.01 (what Ubuntu 24.04 packages, and what CI runs), no external libraries
- **Tooling** — `just`, `clang-format` 18 for `.scad` (config in `.clang-format`), pre-commit with
  gitleaks, Python 3 standard library only in `tools/`

## Layout

```
cad/main.scad       THE ENTRY POINT, and the only file that draws: pick a part or the assembly
cad/build.scad      layout(): every part's spec and position, from the catalog and the choices
cad/catalog.scad    bought parts (syringe, N20, screws), each figure with its source
cad/parts/          one printed part per file: frame, crank, rod, clip
cad/assembly.scad   the mechanism at a crank angle (View > Animate turns it), and `report`
docs/design.md      mechanism, part dimensions and their sources, open questions
tools/stl_edges.py  counts STL edges that do not join exactly two facets
output/             generated exports (gitignored)
working/            local scratch: session notes, partspec contracts (gitignored)
```

## Commands

```sh
just setup    # verify the toolchain
just fmt      # format the SCAD sources
just check    # fmt-check, and every SCAD file evaluates cleanly (CI-equivalent)
just test     # every printed part in PARTS exports as one solid, every edge manifold
just export   # printed parts to output/*.stl
```

`openscad -D 'part="report"' -o /tmp/r.csg cad/main.scad` echoes the screws to buy and the
derived figures.

## Conventions

- **Follow the uwo-fast CAD pattern** set by `thermoelectric-liquid-chiller`. Purchased parts are
  key-value structs in `cad/catalog.scad`, read with `get(row, "key")`, which stops the build on a
  missing or unmeasured value. A printed part is a `*_spec()` function and a module that takes the
  spec. Nothing below `main.scad` reads a global.
- **Libraries draw nothing.** Only `cad/main.scad` has top-level geometry; `check-scad` fails any
  other file that does. Every printed part is a `part` choice in `main.scad`, added to `PARTS` in
  the justfile.
- **OpenSCAD exits 0 on a failed assert.** Gates grep stderr for `ERROR` and `WARNING`; never trust
  `$?`.
- **Overshoot every cutter, overlap every union.** Solids that meet only along an edge or at a point
  are not one solid; `just test` fails them (the volume count, OpenSCAD's warning and
  `tools/stl_edges.py`), and so does `partspec lint`.
- **One physical fact, one expression.** Derive dimensions from catalog rows; never restate a
  number in a second file.
- **Visual review:** the sandbox has no display, so `openscad` cannot render PNGs there. Export STLs
  and inspect them, or ask the user to render.

## Sibling repositories

- `uwo-fast/syringe-pump` — the precision pump this project deliberately is not. Its tooling
  patterns are reusable; its architecture is not.
- `uwo-fast/thermoelectric-liquid-chiller` — the source of the CAD pattern above.

## Constraints

- Do not add an external SCAD library without updating `LICENSING.md`: a GPL library forces the
  CAD to GPL-only.
- Do not commit generated files (`output/`) or scratch (`working/`).
- Do not state a dimension, force or pressure as measured unless it was. Label estimates and
  listing figures as such.
- Do not add dependencies without justification.
- Do not commit secrets or credentials.
- Do not add AI attribution to commits or PR descriptions — no co-author trailers, session links,
  or "generated with" footers.
- Do not let a check report success when it could not run. A check that does not apply may pass,
  but must name itself as skipped; one that could not complete must not exit 0.
