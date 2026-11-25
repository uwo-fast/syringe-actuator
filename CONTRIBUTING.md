# Contributing

How to work on this repository. The organization's
[contribution guide](https://github.com/uwo-fast/.github/blob/main/CONTRIBUTING.md) covers what is
common to every uwo-fast project. This file covers what is specific to this one.

## The project

Printed parts that connect a gearmotor (an N20, or a GA25 for 10 mL and up) to a luer syringe so
that the plunger moves back and forth continuously. The motor runs in one direction directly from a
DC supply, and a printed crank and connecting rod convert the rotation into the plunger stroke. Read
[`docs/design.md`](docs/design.md) before changing anything. It documents the mechanism, the part
dimensions and the open questions.

**The scope is the mechanism only.** What the syringe is connected to, and anything that powers or
controls the motor, belong to other projects. Do not design for them here.

**The main design constraint:** printed parts, one syringe, one DC gearmotor and a few screws. No
guide rods, lead screws, linear bearings or stepper motor. A change that adds purchased hardware has
to explain why a printed part cannot do the job.

## Stack

- **CAD** — OpenSCAD, no external libraries. CI runs 2021.01, the version Ubuntu 24.04 packages.
  The gates read the exported mesh, so they give the same result on a current nightly, whose
  Manifold backend makes `just qa` much faster
- **Tooling** — [`just`](https://github.com/casey/just), `topiary` 0.8.0 for `.scad` (config in
  `.topiary/languages.ncl`), pre-commit with gitleaks, Python 3 standard library only in `tools/`

## Layout

```text
cad/main.scad       THE ENTRY POINT and the only file that draws geometry: settings, layout() (the
                    spec and position of every part), the assembly (View > Animate turns it),
                    `report`, and the part to draw
cad/purchased/      purchased parts: syringes, motors and fasteners hold the rows, each figure
                    with its source; syringe, motor and fastener draw one
cad/lib/            struct.scad (get(), has()) and section.scad (cut a view open)
cad/parts/          one printed part per file: frame, crank, rod, clip, and the body with its cap
docs/design.md      mechanism, part dimensions and their sources, open questions
tools/stl_edges.py  checks an STL is one closed shell, every edge joining two facets
tools/qa/           `just qa`: slivers, collisions over a turn, overhangs, per syringe
tools/render.sh     `just render`: the pictures cad/views.tsv lists, every part, and a stroke GIF
cad/views.tsv       the pictures: a name, a syringe, a view and the -D settings to draw
output/             one-off exports, `just export [syringe]`, with BUILT_FROM (gitignored)
build/              every syringe's parts, `just build`, with BUILT_FROM (gitignored)
working/            local scratch (gitignored)
```

## Commands

```sh
just setup    # verify the toolchain
just fmt      # format the SCAD sources
just check    # fmt-check, and every SCAD file evaluates cleanly (CI-equivalent)
just test     # every part in PARTS, for every syringe in SYRINGES, exports as one solid
just export   # one syringe's printed parts to output/*.stl (default 3ml)
just build    # every syringe's printed parts to build/<syringe>/*.stl
just qa       # slivers, collisions and overhangs, every syringe or those named (a few minutes)
just render   # the pictures in cad/views.tsv to output/figures/<syringe>/, or those a glob names
just render-parts  # every printed part on its own, for a syringe (5ml-gnr2 unless named)
just render-stroke # one turn of the crank as a GIF, from a view (top unless named)
```

`just build` and `just export` write `BUILT_FROM` next to the parts. It records the commit,
`-dirty` if the source had uncommitted edits, and the OpenSCAD version. Re-run `just build` after
any geometry change, so that `build/` never holds parts the source no longer draws. Run `just qa`
before committing a geometry change. It exits 1 on a collision.

`openscad -D 'part="report"' -o /tmp/r.csg cad/main.scad` prints the screws to buy and the
derived dimensions.

## Workflow

1. Create a branch from `main`.
2. Make the change, and run `just check && just test`. For a geometry change, also run `just qa`.
3. Add a line under `## [Unreleased]` in [`CHANGELOG.md`](CHANGELOG.md) for any change someone
   building or using the actuator would notice. A release moves those lines under the new version.
4. Commit with [Conventional Commits](https://www.conventionalcommits.org/):
   `type(scope): description`, where type is one of `feat`, `fix`, `docs`, `refactor`, `test`, `ci`,
   `chore` or `build`, in the imperative, lowercase, with no trailing period. One logical change per
   commit.
5. Open a pull request against `main`. CI must pass before it merges.

## Conventions

- **Purchased parts are data, printed parts are specs.** Purchased parts are key-value structs in
  `cad/purchased/`. Each kind has one file of rows (`syringes.scad`) and one file that draws a part
  (`syringe.scad`). Values are read with `get(row, "key")`, which stops the build on a missing or
  unmeasured value. A printed part is a `*_spec()` function plus a module that takes the spec, in
  its own file under `cad/parts/`. `layout()` in `main.scad` is the only place where parts are sized
  and arranged. Nothing outside `main.scad` reads a global.
- **Keep the code as small as the design.** Add a file when it separates something, not to mirror
  the structure of another project.
- **Libraries draw nothing.** Only `cad/main.scad` has top-level geometry, and `check-scad` fails
  any other file that does. Every printed part is a `part` choice in `main.scad` and is listed in
  `PARTS` in the justfile. Every supported syringe is in `syringes` in
  `cad/purchased/syringes.scad`, is a `syringe` choice in `main.scad`, and is listed in `SYRINGES`.
- **OpenSCAD exits 0 on a failed assert.** The gates grep stderr for `ERROR` and `WARNING`. Never
  trust `$?`.
- **Overshoot every cutter, overlap every union.** Solids that meet only along an edge or at a point
  are not one solid. `just test` fails them (through the OpenSCAD warning and the edge and shell
  counts from `tools/stl_edges.py`), and so does `partspec lint`.
- **One physical fact, one expression.** Derive dimensions from catalog rows. Never restate a
  number in a second file.
- **Look at the parts.** `just render-parts` draws every part. On a current nightly,
  `openscad --camera=... -o view.png` renders any other PNG without a display; 2021.01 cannot (it
  segfaults without OpenGL). A section through `tools/qa/slivers.scad` shows the cross-section of a
  part on either version. The numbers can pass on a part that is upside down or the wrong shape.

## Constraints

- Do not add an external SCAD library without updating `LICENSING.md`. A GPL library forces the
  CAD to be GPL-only.
- Do not commit generated files (`output/`, `build/`) or scratch (`working/`).
- Do not describe a dimension, force or pressure as measured unless it was. Label estimates and
  figures taken from product listings as such.
- Do not add dependencies without justification.
- Do not commit secrets or credentials.
- Commit messages and pull requests describe the change, not the tools used to make it: no
  co-author trailers for tools, session links or "generated with" footers.
- Do not let a check report success when it could not run. A check that does not apply may pass,
  but must report itself as skipped. A check that could not complete must not exit 0.
