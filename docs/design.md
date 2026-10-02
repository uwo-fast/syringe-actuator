# Design

**Status:** working prototype. The third print (2026-10-02) runs as designed at the default
settings: the frame slides into the body, the cap's post squares it, the push-button snaps into the
clip, and the lid slides and clicks shut. The syringe figures below were measured by hand; the motor
figures come from published drawings and are labelled with their source.

## Scope

Printed parts that connect an N20 gearmotor to a 3 mL luer syringe so the plunger strokes back and
forth continuously. The motor runs in one direction straight off a supply; each revolution is one
full pull and one full push.

Not in scope: what the syringe is connected to, and anything that powers or controls the motor.
Mounting the assembly is deferred until the prototype works; it is held by hand until then.

## Mechanism

An in-line crank-slider. The motor's shaft stands vertical on the line of the syringe's axis, so the
crank, the rod and the plunger all move in one horizontal plane:

- **Frame.** A 5 mm plate, about 175 × 25 mm, as wide as the barrel flanges. They drop into a slot
  at one end, and the slot's walls take both the push and the pull. The barrel snaps into a ring 15
  mm in front of the slot. Two rails, 8 mm tall, run from the slot's back wall either side of the
  clip's travel, out to the plate's edges. The motor hangs under the plate's other end: its gearbox
  sits 2 mm up into a pocket, located by its bushing and held by two M1.6 × 3 pan heads,
  counterbored below the crank's hub.
- **Crank.** It presses onto the 3 mm D-shaft and carries the pin at a **29 mm throw**, half the
  58 mm stroke. Its D-bore is blind, so pressed on, it stops on the shaft's tip, 1 mm over the
  plate.
- **Rod.** A 90 mm rod runs from the crank pin to the clip, lying on both parts' top faces. Each end
  turns on a printed boss 0.3 mm taller than the rod. An M3 × 10 screw and an M3 washer clamp down
  on the boss, not on the rod, so the joint turns freely with the screw tight. A screw clamping the
  rod itself would either lock the joint or work loose.
- **Plunger clip.** The push-button drops into a cup, and the plunger through a slot in its front
  wall. A sled under the clip runs 20 mm past the rod's pin, between the frame's rails with 0.3 mm
  a side. It stays 2 mm below the rod and clear of the plate.

- **Body.** A shell fitted round what the frame carries: narrow and shallow at the front, where
  there is only the syringe, the plate and the clip (about 39 wide × 34 high outside), tapering from
  where the rod starts to swing out to full width and the motor's depth where the crank turns (about
  77 × 64), about 220 long. Each section is symmetric about the syringe axis's vertical plane,
  square at the top and chamfered at the bottom as far as its contents allow; `layout()` sizes them
  from the extremes of what the frame carries over a whole turn, and checks the taper clears the
  rod's swing. The frame slides in from the back on two rails that take the plate's dovetailed long
  edges, up to the front wall at the snap ring; a cap screwed to the back end (2 × M3 × 10) holds it
  there with a post and lets the motor's wires out through a hole. The syringe goes in and out
  through a 28 mm window in the roof, at any clip position, and the barrel passes the front wall
  through a slot. A lid slides on rails along the roof, between a lip on the front wall and the cap:
  its edges rest on the roof either side of the window; a bump under the middle of its back end
  drops into a notch at the window's back edge when it is shut, and runs in a groove along the
  roof's middle the rest of its travel. The bottom is not flat, so a desk stand is an add-on; the
  narrow front is a constant section a bracket can grip. The push-button snaps into the clip's cup
  past two small lips, so the syringe stays in whichever way up the unit is. The body prints
  standing on its back end, 217 mm tall, with no supports: its walls lean in at most 43 degrees, and
  the front wall bridges about 27 mm. Its rails start at the bed, so turn on the slicer's
  elephant-foot compensation, and use a brim. No edge on it, the lid or the frame's plate comes to a
  knife edge: the dovetails and the lid's bevels stand on short lands. Assembly: frame into the body
  from the back, lid onto its rails from the back, then the cap.

The motor never reverses: each revolution is one pull and one push. At a = 180° the plunger is in,
stopping 1 mm short of the barrel's end, and at 0° it is out 58 mm.

**Side load.** The rod's angle `φ` puts a side load `F·tan(φ)` on the clip, where `F` is the
force along the stroke. The rod is three throws long, so `φ` peaks at `asin(29/90)` = 18.8°. The
rails take that load. On the first print the clip had no guide. On the push stroke the side load
bowed the plunger sideways and the clip turned with it (video, 2026-09-30). The plunger cannot carry
a side load in compression.

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
| Plunger ribs, widest across | 7.5 mm (ribs about 1 mm thick); the last 9 mm before the push-button tapers to 6.6 mm |

The size is inferred to be 3 mL, because published 3 mL inner diameters (8.57–8.94 mm, BD and
Terumo, from syringe-pump libraries) give 3.4–3.6 mL over 58 mm. A 5 mL barrel (ID about 12 mm)
cannot have a 10 mm OD.

The part names follow ISO 7886-1: **barrel**, **barrel flanges** (finger grips), **plunger**,
**push-button** (thumb rest), **plunger stopper** (the rubber piston) and **nozzle** (the luer
tip).

### N20 inline gearmotor (the one used)

From Pololu's micro metal gearmotor dimension drawing
(<https://www.pololu.com/file/0J949/micro-metal-gearmotor-dimensions.pdf>, 2024-04-03), except the
shaft's length, measured on the motor in hand (2026-09-29):

| Feature | Size |
| --- | --- |
| Can | 12.0 wide × 10.0 across flats × 15 long; end cap 1.2, then a Ø5 boss |
| Gearbox | 12.0 × 10.0 × 9 long (12.5 at 1000:1) |
| Shaft | Ø3.0, 2.5 across the flat; 9 long from the gearbox face (measured), D-profile over its whole length |
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

No usable OpenSCAD model of either motor was found (NopSCADlib has none), so `cad/main.scad`
draws the inline one, simplified, from the figures above.

## Open

1. **Measure** the plan shape of the barrel flanges; the slot is open at the sides and 12.6 tall
   with clearance, and 24.5 sets only the frame's width. For the worm motor, if it is ever used,
   measure its shaft length and boss.
2. **Mounting:** the desk stand and the vertical mount are add-ons still to design.
3. **Measure** the barrel's length, flange to luer tip, and the motor's end boss and terminals past
   its can. The body is sized with 3 mm nominal for the terminals.
