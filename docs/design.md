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

An in-line crank-slider. The motor's shaft stands vertical on the line of the syringe's axis, so the
crank, the rod and the plunger all move in one horizontal plane:

- **Frame.** A 5 mm plate, about 174 × 31 mm. The barrel's flanges drop into a slot at one end,
  and the slot's walls take both the push and the pull. The barrel snaps into a ring 15 mm in front
  of the slot, and is the only guide the plunger has. The motor hangs under the plate's other end:
  its gearbox sits 2 mm up into a pocket, located by its bushing and held by two M1.6 × 3 pan
  heads, counterbored below the crank's hub.
- **Crank.** It presses onto the 3 mm D-shaft and carries the pin at a **29 mm throw**, half the
  58 mm stroke.
- **Rod.** A 90 mm rod runs from the crank pin to the clip. Both ends turn on M3 × 10 screws that
  thread into the crank and the clip below it, and the rod lies on both parts' top faces.
- **Plunger clip.** The push-button drops into a cup, and the plunger through a slot in its front
  wall.

The motor never reverses: each revolution is one pull and one push. At a = 180° the plunger is in,
stopping 1 mm short of the barrel's end, and at 0° it is out 58 mm.

**Side load.** The rod's angle `φ` puts a side load `F·tan(φ)` on the plunger, where `F` is the
force along the stroke. The rod is three throws long, so `φ` peaks at `asin(29/90)` = 18.8°.

**Torque (estimate).** The peak crank torque is about `F·r`. At an assumed 3 N of seal friction
(unmeasured) and `r` = 29 mm, that is about 0.09 N·m (0.9 kg·cm). A fully blocked line adds full
vacuum on the bore: about 5.9 N at 8.66 mm ID, which makes 2.6 kg·cm with the friction.

**Motor.** A 12 V N20 at about 30 rpm, which is a 1000:1-class gearbox: Pololu #3046 or a generic
"N20 12V 30RPM". Pololu's #3046 gives 35 rpm free-running and a 10 kg·cm extrapolated stall, and
recommends keeping instantaneous torque under 2.5 kg·cm on this gearbox
(<https://www.pololu.com/category/60/micro-metal-gearmotors>). The running load is about a third
of that limit, and a blocked line reaches about the limit. 35 rpm gives a 1.7 s cycle and a peak
plunger speed of about 106 mm/s. A lower supply voltage slows the motor roughly in proportion.

## Parts

### Syringe (measured, 2026-09-29)

| Feature | Size |
| --- | --- |
| Barrel OD | 10.0 mm |
| Barrel flanges | 24.5 × 12.6 mm, 2.0 mm thick |
| Push-button | Ø12.6 mm, 1.6 mm thick |
| Working stroke | 58 mm |
| Plunger exposed, stopper bottomed (flange rear face to push-button front face) | 10.75 mm |
| Plunger ribs, widest across | 7.5 mm (ribs about 1 mm thick) |

The size is inferred to be 3 mL, because published 3 mL inner diameters (8.57–8.94 mm, BD and
Terumo, from syringe-pump libraries) give 3.4–3.6 mL over 58 mm. A 5 mL barrel (ID about 12 mm)
cannot have a 10 mm OD.

The part names follow ISO 7886-1: **barrel**, **barrel flanges** (finger grips), **plunger**,
**push-button** (thumb rest), **plunger stopper** (the rubber piston) and **nozzle** (the luer
tip).

### N20 inline gearmotor (the one used)

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

No usable OpenSCAD model of either motor was found (NopSCADlib has none), so `cad/assembly.scad`
draws the inline one, simplified, from the figures above.

## Open

1. **Measure** the plan shape of the barrel flanges; the slot is the 24.5 × 12.6 envelope with
   clearance. For the worm motor, if it is ever used, measure its shaft length and boss.
2. **Mounting:** deferred until the prototype works.
