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
- What another project needs to mount the actuator, read with `use <cad/main.scad>`: `actuator()`,
  the layout for a syringe by name; `front_x()` and the body's `front_face()`, the front wall's
  outer face; `tip_x()`, where the syringe's front end is, from each syringe's new `nozzle_l`
