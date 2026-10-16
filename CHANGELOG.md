# Changelog

All notable changes to this project are documented in this file.

The format loosely follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- The printed crank-slider: frame, crank, rod and plunger clip (`cad/`), with an animated assembly
  and a report of the screws to buy
- The body: a shell fitted round the mechanism, with a sliding lid over the syringe's window and a
  cap the motor's wires leave through; `part="housed"` shows it, and `section()` cuts any view open
- Design record: the crank-slider mechanism, the syringe and N20 gearmotor dimensions, and what is
  open (`docs/design.md`)
- `just check` / `just test` gates for the OpenSCAD source, CI, and the pre-commit config
- Syringe presets, picked in the Customizer: 1, 3, 5 and 20 mL measured, BD's 10 and 30 mL
  estimated, BD's 50 mL estimated in the catalog but not built, and a guide to measuring another
  syringe (`docs/measuring.md`)
- The GA25 gearmotor for the 10, 20 and 30 mL, the motor picked by syringe or by name, and the
  crank's estimated torque in the report beside the motor's limit
- Two four-hole M3 mounting patterns on the body, sealed by knockout skins
- What another project needs to mount the actuator, read with `use <cad/main.scad>`: `actuator()`,
  the layout for a syringe by name; `front_x()` and the body's `front_face()`, the front wall's
  outer face; `tip_x()`, where the syringe's front end is, from each syringe's new `nozzle_l`
- `grip` and `ring_grip` in the Customizer, and a `ring_test` part to try the snap ring
- `just qa` (slivers, collisions over a turn, overhangs), `just build` for every syringe, and a
  `BUILT_FROM` stamp on every export

### Changed

- The bought parts' rows moved from `cad/catalog.scad` to `cad/purchased/`
- `just test` judges each part from its exported mesh, so it reads the same on any OpenSCAD
- The body's roof shoulders are filled flush with the lid's rails

### Fixed

- The plunger stopped 1 mm past its stop at the top of the stroke; it now stops 1 mm short of
  each end
- The snap ring's arms snapped in PLA; they are thinner, free over a longer arc, with a fixed grip
  and a lead-in
- The crank's printed D-bore wore round on the shaft; a grub screw onto the flat now holds it
- The 1 mL clip and the 5 mL body's taper, which did not print as one solid and within 45°
