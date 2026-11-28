# Changelog

All notable changes to this project are documented in this file.

The format loosely follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.3] - 2026-11-28

### Changed

- The bill of materials and the report specify M3 square nuts at the crank, the cradle and the
  front plate, and an M3 socket-head screw instead of the cup-point set screw to clamp the crank on
  the flat of the shaft. A hex nut turns in the crank slot; a square nut cannot. The cradle set
  screws and nuts are fitted only if the motor can move in the cradle. No part geometry changes.

## [0.1.2] - 2026-11-22

### Added

- The layout's `throw` in the public interface. Twice the throw is the stroke the crank drives

## [0.1.1] - 2026-11-22

### Added

- A tab on the front end of the lid that closes the barrel slot at the lid level, and an optional
  front plate, held by the front mounting screws, that closes the front against light

## [0.1.0] - 2026-11-21

### Added

- The public interface for other projects, listed in the README: `actuator()`, `front_x()`,
  `tip_x()`, `front_face()`, the layout's and the body's named fields, the body, lid and cap, and
  the preset names
- A cradle under the plate that grips the motor gearbox with two set screws, so the motor cannot
  rock its screws loose. The motor is now mounted with its screws along the stroke
- GA25 builds of both 5 mL syringes, `5ml-gnr1-ga25` and `5ml-gnr2-ga25`, sharing one body
- One body, lid and cap for the N20 syringes (1, 3 and both 5 mL). Switching between them means
  reprinting only the frame, clip, crank and rod
- A second generic 5 mL syringe, shorter than the first. The presets are now `5ml-gnr1` and
  `5ml-gnr2`, and a unit printed for the first accepts the second with a new crank and rod
- The printed crank-slider: frame, crank, rod and plunger clip (`cad/`), with an animated assembly
  and a report of the screws to buy
- The body: a shell fitted around the mechanism, with a sliding lid over the syringe window and a
  cap that the motor wires exit through. `part="housed"` shows it, and `section()` cuts any view
  open
- Design record: the crank-slider mechanism, the syringe and N20 gearmotor dimensions, and the open
  questions (`docs/design.md`)
- `just check` / `just test` gates for the OpenSCAD source, CI, and the pre-commit config
- Syringe presets, picked in the Customizer: 1, 3, 5 and 20 mL measured, BD's 10 and 30 mL
  estimated, BD's 50 mL estimated in the catalog but not built, and a guide to measuring another
  syringe (`docs/measuring.md`)
- The GA25 gearmotor for the 10, 20 and 30 mL, motor selection by syringe or by name, and the
  estimated crank torque in the report next to the motor's limit
- Two four-hole M3 mounting patterns on the body, sealed by knockout skins
- The values another project needs to mount the actuator, read with `use <cad/main.scad>`:
  `actuator()`, the layout for a syringe by name; `front_x()` and the body's `front_face()`, the
  outer face of the front wall; `tip_x()`, the position of the syringe's front end, from the new
  `nozzle_l` of each syringe
- `grip` and `ring_grip` in the Customizer, and a `ring_test` part to try the snap ring
- `just qa` (slivers, collisions over a turn, overhangs), `just build` for every syringe, and a
  `BUILT_FROM` stamp on every export
- `just render`, which renders the views listed in `cad/views.tsv`, and `just render-parts`, which
  renders every printed part on its own, as PNGs in `output/figures/`; `just render-stroke`, which
  renders one turn of the crank as a GIF

### Changed

- The SCAD sources are formatted by topiary 0.8.0, which parses OpenSCAD, instead of
  clang-format, which treated it as C. CI installs the same version
- The body prints standing on its front wall, which the frame stops against, so the wall prints
  flat rather than bridged. To allow this, the window ends in a 45 degree point and the cap bosses
  taper into the wall. The lid is extended to cover the point, and every body grows 15 to 24 mm
  (226.4 to 241.6 mm tall as printed for the N20 syringes)
- The N20 syringe body is longer, to fit all four syringes: 229.4 mm, against 214 mm for the 3 mL,
  and 226.4 mm tall as printed. Every N20 frame, body, lid, cap and ring test is new, as are the 1
  and 3 mL cranks, because their axis rose to the 17 mm of the 5 mL. Units printed earlier can use
  none of these parts. An adapter drawn to the old front no longer fits any N20 syringe. The front
  face is 41.3 × 36.5 mm outside for all four. The wall sits further forward of the 3 and 5 mL
  (7.7 and 6.9 mm; the tip of the second 5 mL is 32.7 mm past it, against 39.6). The front holes
  for the 1 mL are 30 mm apart, not 20. The axis of the 1 and 3 mL rose 3.2 and 2 mm relative to
  the holes, which are still centred 15 mm up
- The lid exports from the body's back end, like the body and the cap
- The rows for purchased parts moved from `cad/catalog.scad` to `cad/purchased/`
- `just test` checks each part from its exported mesh, so it gives the same result on any OpenSCAD
  version
- The shoulders of the body roof are filled flush with the lid rails

### Fixed

- The plunger went 1 mm past its stop at the top of the stroke. It now stops 1 mm short of each
  end
- The snap ring arms broke in PLA. They are now thinner and free over a longer arc, with a fixed
  grip and a lead-in
- The printed D-bore of the crank wore round on the shaft. A grub screw onto the flat now holds it
- The 1 mL clip and the taper of the 5 mL body, which did not print as one solid and within 45°
