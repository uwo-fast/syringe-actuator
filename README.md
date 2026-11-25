# Syringe Actuator

> A printed crank that drives a syringe plunger back and forth from a continuously running
> gearmotor.

[![Licensing](https://img.shields.io/badge/Licensing-by_component-lightgrey.svg)](https://github.com/uwo-fast/syringe-actuator/blob/main/LICENSING.md)
[![Contributions welcome](https://img.shields.io/badge/Contributions-welcome-brightgreen.svg)](https://github.com/uwo-fast/.github/blob/main/CONTRIBUTING.md)

![The mechanism for a 3 mL syringe: the frame holds the syringe at one end and the motor under the other; the crank turns the rod, which drives the plunger's clip along its rails](docs/images/mechanism.png)

## Overview

An N20 gearmotor drives 1 to 5 mL luer syringes and a 25 mm GA25 drives 10 to 30 mL, each straight
off a supply. A printed crank and connecting rod stroke the plunger over nearly its whole travel,
the plunger's clip guided on rails. The mechanism sits in a printed body: the syringe loads through
a lidded window in the roof, the motor's two wires come out the back, and two patterns of knockout
holes take whatever you mount it to. The bought hardware is the syringe, the motor and a few screws.

**Status:** working prototype; [`docs/design.md`](docs/design.md) says what has been printed and
run, and records the mechanism, the part dimensions and their sources, and what is open.

## Build one

1. **Pick the syringe.** Each syringe gets its own frame, clip, crank and rod. The N20 syringes
   share one body, lid and cap, so switching between them reprints only those four. Presets:

   | Syringe | Motor | Source |
   | --- | --- | --- |
   | 1, 3, 5 mL (two makes of 5 mL) | N20 | measured unbranded luer-lock syringes |
   | 5 mL, both makes (`5ml-gnr1-ga25`, `5ml-gnr2-ga25`) | GA25 | the same syringes on the larger motor |
   | 20 mL | GA25 | measured |
   | 10, 30 mL | GA25 | BD Plastipak, estimated to about a millimetre |

   Syringes of the same volume differ by maker, so for any other syringe, or to replace an estimate,
   measure it and add it as a preset: [`docs/measuring.md`](docs/measuring.md).

2. **Export the parts.** `just build` writes every preset's printed parts to `build/<syringe>/`, or
   open `cad/main.scad` in OpenSCAD and pick the syringe and the `part` in the Customizer. The parts
   are the frame, crank, rod, clip, cradle, body, lid and cap, and an optional front plate.
   `ring_test`, not in `build/` but in the Customizer and `just export`, prints the syringe's snap
   ring alone, to try it first.

3. **Buy the hardware.** `openscad -D 'syringe="3ml"' -D 'part="report"' -o r.csg cad/main.scad`
   lists it for a syringe:

   | Part | For | What |
   | --- | --- | --- |
   | Gearmotor | 1 to 5 mL | N20, 12 V, about 30 rpm (1000:1), such as Pololu #3046 |
   | Gearmotor | 10 to 30 mL | GA25YN370 (also JGA25-370), 12 V, 30 rpm |
   | Motor screws | N20 | 2 x M1.6 x 3 flat head, JIS cross drive No. 0, such as McMaster 91305A002 |
   | Motor screws | GA25 | 2 x M3 x 4 button head (ISO 7380) |
   | Pin screws | all | 2 x M3 x 10 socket head, with 2 x M3 washers |
   | Cap screws | all | 2 x M3 x 10 |
   | Crank | all | 1 x M3 x 6 socket head and 1 x M3 square nut |
   | Cradle | all | 2 x M3 x 8 socket head; if the motor can move in it, 2 x M3 x 6 set screw, cup point, and 2 x M3 square nut |
   | Front plate (optional) | all | 4 x M3 x 10 socket head and 4 x M3 square nuts |
   | Threadlocker | all | blue (medium strength), on every motor and cradle screw |

4. **Print.** PLA or PETG, no supports. The body stands on its front wall: 242 mm tall for the N20
   syringes, 223 to 313 mm for the GA25's, so check your printer's height first. The front wall is
   what the frame stops against, so it prints flat on the bed; turn on the slicer's elephant-foot
   compensation, and use a brim, as it stands tall on a small footprint.

5. **Assemble.**
   - **Motor:** screw it under the plate first, with threadlocker: its shaft comes up through the
     plate, and the crank goes on after.
   - **Cradle:** slide it up over the motor to the plate and screw it on from below. If the motor can
     move in it, drop the square nuts into its slots and turn the set screws in until the gearbox
     cannot move, and tighten them again after the first day of running, as the print settles.
   - **Crank:** drop the nut into its slot, press the crank onto the motor's shaft through the
     plate, and tighten the M3 screw onto the shaft's flat. Join the rod to the crank and the clip
     with the pin screws over their washers.
   - **Body:** fit any front mounting screws first (step 6), then slide the frame into the body from
     the back, slide the lid onto its rails from the back, then screw on the cap.
   - **Syringe:** load it through the window: the barrel snaps into its ring and the push-button
     into the clip.
   - **Tune:** if the clip or the ring holds too loosely or too tightly, change `grip` or
     `ring_grip` in the Customizer and reprint that part.

6. **Mount it**, if you need to. Drill or punch out the knockouts you use: four through the front
   wall and four through the roof's shoulders. Your adapter screws to them, M3, with the heads
   inside the body; fit the front ones before the frame goes in. An adapter drawn in OpenSCAD can
   take its numbers from the layout: `use <cad/main.scad>`, then `L = actuator("3ml")`; `front_x(L)`
   and `front_face(get(L, "body"))` give the front wall's outer face, the body's `mount_front` and
   `mount_top` the holes, and `tip_x(L)` the syringe's tip, once the syringe's `nozzle_l` is known.
   With nothing on the front, the optional `front_plate` closes it against light: the same four
   screws go through it, from inside the body, to nuts on the plate. Fit it after loading the
   syringe, as its hole only just passes the barrel.

## Using it from another project

Another OpenSCAD project can draw an adapter, or the actuator itself, from the layout:
`use <cad/main.scad>`, at a tagged release. These names are the public interface:

| Name | What it gives |
| --- | --- |
| `actuator(name, motor = "auto")` | the layout for a preset by its name below; `motor` is `"auto"`, `"n20"` or `"ga25"` |
| `front_x(L)` | the x of the front wall's outer face, the face an adapter meets |
| `tip_x(L)` | the x of the syringe's front end, where its `nozzle_l` is known |
| `front_face(get(L, "body"))` | the front wall's outline in [y, z] |
| `get(L, "axis_z")`, `"syringe"`, `"body"` | the syringe axis's height, the syringe's row, the body's spec |
| `get(L, "throw")` | the crank's throw: twice it is the stroke the crank drives, the syringe's `stroke` less 1 mm at each end |
| the body's `"mount_front"`, `"mount_top"`, `"end_t"`, `"x"` | the mounting holes, the front wall's thickness, the inside's [front, back] x |
| `body()`, `lid()`, `cap()` | the printed body, lid and cap, drawn from the body's spec |

The presets: `1ml`, `3ml`, `5ml-gnr1`, `5ml-gnr2`, `5ml-gnr1-ga25`, `5ml-gnr2-ga25`, `10ml`,
`20ml`, `30ml`. Renaming or removing a preset, or changing what one of these names gives, is a
breaking change; while the version is 0.x, it comes in a new minor version (0.2.0). A preset's
numbers can still change in any release when its syringe is re-measured, so pin a tag, not `main`.

## Repository layout

- `cad/`: the OpenSCAD source; `main.scad` draws the assembly or any printed part,
  `purchased/` holds the syringes, motors and fasteners, `parts/` the printed parts
- `docs/`: the design record and the measuring guide
- `tools/`: the mesh check behind `just test`, the geometry checks behind `just qa`, and the
  renderer behind `just render`

## Development

Tasks run through [`just`](https://github.com/casey/just); `just --list` shows them all.

```sh
just setup   # verify the toolchain: OpenSCAD, topiary
just check   # formatting and every SCAD file evaluating cleanly; CI runs setup, check and test
             # when anything outside the docs changes
just test    # every printed part, for every syringe, exports as one closed solid
just build   # every syringe's printed parts to build/<syringe>/, stamped with the commit
just qa      # slivers, collisions over a turn and overhangs, for every syringe
just render  # the pictures listed in cad/views.tsv, to output/figures/<syringe>/
just render-parts  # every printed part on its own, in its print orientation
just render-stroke # one turn of the crank as an animated GIF
```

## Contributing

Contributions are welcome. [`CONTRIBUTING.md`](CONTRIBUTING.md) covers this repository: its
scope, layout, commands, conventions and workflow. The organization
[contribution guide](https://github.com/uwo-fast/.github/blob/main/CONTRIBUTING.md) covers the rest.

## Citation

If you use this project in your work, please cite it. Use the **Cite this repository** button on
GitHub, or see
[`CITATION.cff`](https://github.com/uwo-fast/syringe-actuator/blob/main/CITATION.cff).

## License

Copyright (c) 2026 Syringe Actuator and its contributors.

This project is free software: you may redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version. The parametric CAD source (`.scad`) is also
licensed under
[CERN-OHL-S-2.0](https://github.com/uwo-fast/syringe-actuator/blob/main/LICENSES/CERN-OHL-S-2.0.txt),
and the geometry, drawings and bill of materials generated from it under CERN-OHL-S-2.0 alone.
See [`LICENSING.md`](https://github.com/uwo-fast/syringe-actuator/blob/main/LICENSING.md) for what
applies where, and the organization [licensing
policy](https://github.com/uwo-fast/.github/blob/main/LICENSING.md) for why.

## Contact

Maintained by the [FAST research group](https://uwo-fast.github.io/). For research collaboration
inquiries, contact Dr. Joshua Pearce (<joshua.pearce@uwo.ca>).
