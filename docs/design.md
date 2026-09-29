# Design

**Status:** prototype. Nothing has been printed. The syringe figures below were measured by hand;
the motor figures come from published drawings and are labelled with their source.

## Scope

Printed parts that connect an N20 gearmotor to a 3 mL luer syringe so the plunger strokes back and
forth continuously. The motor runs in one direction straight off a supply; each revolution is one
full pull and one full push.

Not in scope: what the syringe is connected to, and anything that powers or controls the motor.
Mounting the assembly is deferred until the prototype works; it is held by hand until then.

## Mechanism

A crank-slider:

- **Crank** on the motor's output shaft (3 mm D-shaft), throw **29 mm** (half the 58 mm stroke).
- **Connecting rod** from the crank pin (an M3 screw) to a **plunger clip** that captures the
  push-button.
- **Cradle** holding the barrel and capturing the barrel flanges, so the barrel takes the push and
  the pull. The barrel is the only guide for the plunger.

The rod's angle `φ` puts a side load `F·tan(φ)` on the plunger, where `F` is the force along the
stroke. Its peak is at `sin(φ) = r/L` for throw `r` and rod length `L`; a rod of at least `3r`
(about 90 mm) keeps `φ` under 20°. That is a starting point, not a requirement.

**Torque (estimate).** The peak crank torque is about `F·r`. At an assumed 3 N of seal friction
(unmeasured) and `r` = 29 mm, that is about 0.09 N·m (0.9 kg·cm). Whether a given N20 turns it
depends on its gear ratio; see the open items.

## Parts

### Syringe (measured, 2026-09-29)

| Feature | Size |
| --- | --- |
| Barrel OD | 10.0 mm |
| Barrel flanges | 24.5 × 12.6 mm, 2.0 mm thick |
| Push-button | Ø12.6 mm, 1.6 mm thick |
| Working stroke | 58 mm |

The size is inferred to be 3 mL, because published 3 mL inner diameters (8.57–8.94 mm, BD and
Terumo, from syringe-pump libraries) give 3.4–3.6 mL over 58 mm. A 5 mL barrel (ID about 12 mm)
cannot have a 10 mm OD.

The part names follow ISO 7886-1: **barrel**, **barrel flanges** (finger grips), **plunger**,
**push-button** (thumb rest), **plunger stopper** (the rubber piston) and **nozzle** (the luer
tip).

### N20 inline gearmotor

From Pololu's micro metal gearmotor dimension drawing
(<https://www.pololu.com/file/0J949/micro-metal-gearmotor-dimensions.pdf>, 2024-04-03):

| Feature | Size |
| --- | --- |
| Can | 12.0 wide × 10.0 across flats × 15 long; end cap 1.2, then a Ø5 boss |
| Gearbox | 12.0 × 10.0 × 9 long (12.5 at 1000:1) |
| Shaft | Ø3.0, 2.5 across the flat, 10 long from the gearbox face |
| Bushing | Ø4.0, 0.7 proud |
| Mounting | 2 × M1.6 tapped, 9.0 apart, either side of the shaft |

### N20 worm (90°) gearmotor

From a vendor outline drawing that is not to scale
(<https://ineedmicromotors.com/wp-content/uploads/2023/06/IND-12GMWN20-Drawing-1.jpg>):

| Feature | Size |
| --- | --- |
| Gearbox | 18.0 long × 12.0 wide × 10.0 thick |
| Overall length | 33.1 |
| Shaft | Ø3.0, 2.5 across the flat; centre 3.96 from the gearbox's far end, on its centreline |
| Mounting | 2 × Ø1.5 holes, 8.5 apart across the width, 2.2 from the far end |

Not dimensioned by any source: the shaft's exposed length (6.4 to the start of the flat; one listing
gives 8.3 overall), the boss's protrusion, and the side screw.

No usable OpenSCAD model of either motor was found (NopSCADlib has none), so they are modelled
here from the figures above.

## Open

1. **Which motor for the first prototype, and its gear ratio.** The ratio sets the stroke rate and
   whether the crank torque above is within reach.
2. **Measure:** the plunger's cross-section, the plan shape of the barrel flanges (model the
   24.5 × 12.6 envelope with clearance until then), and for the worm motor the shaft length and the
   boss.
3. **Mounting:** deferred until the prototype works.
