# Syringe Actuator

> A printed crank that drives a syringe plunger back and forth from a continuously running
> gearmotor.

[![Licensing](https://img.shields.io/badge/Licensing-by_component-lightgrey.svg)](LICENSING.md)
[![Contributions welcome](https://img.shields.io/badge/Contributions-welcome-brightgreen.svg)](https://github.com/uwo-fast/.github/blob/main/CONTRIBUTING.md)

## Overview

An N20 gearmotor, or a 25 mm GA25 for the larger syringes, runs in one direction straight off a
supply. A printed crank and connecting rod turn that into a continuous pull and push over nearly the
whole stroke of a 1 to 30 mL luer syringe, the plunger's clip guided on rails. The mechanism sits in
a printed body: the syringe loads through a lidded window in the roof, and the motor's two wires
come out the back. The bought hardware is the syringe, the motor and a few screws.

**Status:** working prototype. The third print (2026-10-02), body and all, runs as designed.
[`docs/design.md`](docs/design.md) records the mechanism, the part dimensions and what is open.

## Repository layout

- `docs/` — design record
- `cad/` — the OpenSCAD source: `main.scad` draws the assembly or any printed part for the chosen
  syringe; `just export` writes one syringe's parts to `output/`, and `just build` every syringe's
  to `build/`

## Getting started

Tasks run through [`just`](https://github.com/casey/just); `just --list` shows them all.

```sh
just setup   # verify the toolchain: OpenSCAD, clang-format
just check   # what CI runs: formatting and every SCAD file evaluating cleanly
just test    # every printed part exports as one closed solid
just build   # every syringe's printed parts to build/<syringe>/, stamped with the commit
just qa      # slivers, collisions over a turn and overhangs, for every syringe
```

## Contributing

Contributions are welcome. See the organization
[contribution guide](https://github.com/uwo-fast/.github/blob/main/CONTRIBUTING.md).

## Citation

If you use this project in your work, please cite it. Use the **Cite this repository** button on
GitHub, or see [`CITATION.cff`](CITATION.cff).

## License

Copyright © 2026 Syringe Actuator and its contributors.

This project is free software: you may redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version. Hardware design files and the outputs generated
from them are licensed instead under [CERN-OHL-S-2.0](LICENSES/CERN-OHL-S-2.0.txt). See
[`LICENSING.md`](LICENSING.md) for what applies where, and the organization
[licensing policy](https://github.com/uwo-fast/.github/blob/main/LICENSING.md) for why.

## Contact

Maintained by the [FAST research group](https://uwo-fast.github.io/). For research collaboration
inquiries, contact Dr. Joshua Pearce (<joshua.pearce@uwo.ca>).
