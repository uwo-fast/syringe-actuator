# Design

**Status:** working prototype. Every syringe builds and passes `just test` and `just qa`. N20 units
run as designed, one for 2 hours with no wear (2026-10-07); the 10 and 30 mL are built from
estimates and not yet printed. The syringe figures below were measured by hand unless marked as
estimates; the motor figures are measured or come from the drawings named beside them.

## Scope

Printed parts that connect a DC gearmotor to a luer syringe so the plunger strokes back and forth
continuously: an N20 for the 1, 3 and 5 mL, a 25 mm GA25 for the 10, 20 and 30 mL. The motor runs in
one direction straight off a supply; each revolution is one full pull and one full push.

Not in scope: what the syringe is connected to, anything that powers or controls the motor, and the
adapters a user mounts the body with. The body has two mounting patterns for them.

## Mechanism

An in-line crank-slider. The motor's shaft stands vertical on the line of the syringe's axis, so the
crank, the rod and the plunger all move in one horizontal plane. Figures for one syringe are the 3
mL's; `part="report"` gives any syringe's.

- **Frame.** A 5 mm plate as wide as the barrel's flanges, which drop into a slot at one end; the
  slot's walls take both the push and the pull. The barrel snaps into a ring 15 mm in front of the
  flange's block, past two arms 1.6 mm thick that stand free from 45° below the axis, so they bend
  over a long arc. The opening is `ring_grip` (0.5 mm) a side narrower than the barrel, with a 45°
  lead-in at each tip. Two rails, 8 mm tall, run from the slot's back wall either side of the clip's
  travel. The motor hangs under the plate's other end, its gearbox 2 mm up into a pocket, located by
  its bushing and held by two screws counterbored under the crank's hub.
- **Crank.** It presses onto the motor's D-shaft and carries the pin at a throw of half the
  syringe's stroke less a 1 mm margin at each end: 27.6 mm for the 3 mL. Its D-bore is blind, so it
  stops on the shaft's tip, 1 mm over the plate. An M3 × 6 grub screw (ISO 4026, cup point) runs
  back through a lobe behind the hub onto the shaft's flat, which faces it, through an M3 nut
  dropped into a slot from the top: steel on steel carries the torque and holds the crank down.
- **Rod.** At least three throws long, 90 mm at the shortest, from the crank pin to the clip, lying
  on both parts' top faces. Each end turns on a printed boss 0.3 mm taller than the rod; an M3 × 10
  screw and washer clamp the boss, not the rod, so the joint turns freely with the screw tight.
- **Plunger clip.** The push-button drops into a cup and snaps past two lips (`grip` in the
  Customizer), so the syringe stays in whichever way up the unit is; the plunger passes a slot in
  the cup's front wall. A sled under the clip runs 20 mm past the rod's pin between the frame's
  rails, 0.3 mm a side, 2 mm below the rod.
- **Body.** A shell fitted round what the frame carries, symmetric about the axis's vertical plane,
  square at the top and chamfered at the bottom as far as its contents allow. `layout()` sizes each
  section from the extremes of what the frame carries over a whole turn.
  - _Shape._ Narrow and shallow at the front, where there is only the syringe, the plate and the
    clip; full width and the motor's depth where the crank turns; a taper between, which `layout()`
    checks against the rod's swing and keeps within 45° of the body's axis.
  - _Frame and cap._ The frame slides in from the back on rails that take the plate's dovetailed
    edges, up to the front wall. A cap screwed to the back end (2 × M3 × 10) holds it there with a
    post in the same rails, and lets the motor's wires out.
  - _Window and lid._ The syringe goes in and out through a window in the roof at any clip
    position, the barrel through a slot in the front wall. A lid slides on rails along the roof
    between a lip on the front wall and the cap; a bump under its back end clicks into a notch when
    it is shut and runs in a groove the rest of its travel. Over the wider back the rails run out to
    the sides, filling the roof's shoulders flush with their tops, so they cannot snap off and leave
    no inside corner to clean.
  - _Mounting._ Two patterns of four M3 clearance holes, each sealed by a 0.6 mm knockout skin at
    the outer face until a user drills or punches the ones they use; the screws' heads sit inside.
    One is through the front wall beside the barrel's slot, 10 up and the narrowest multiple of 10
    across whose heads clear the frame's snap ring: 20 for the 1 mL, 30 up to the 10 mL, 40 for the
    20 and 30 mL, centred 15 mm over the plate's underside; the other through the roof's shoulders,
    60 across by 20 along, centred 15 mm in front of the back end, behind the crank's sweep. Another
    OpenSCAD project draws its adapter from the layout with `use <cad/main.scad>`:
    `actuator(syringe, motor)` gives it, `front_x()` and the body's `front_face()` the front wall's
    outer face, the body's `mount_front` and `mount_top` the holes, and `tip_x()` the syringe's
    front end, from its `nozzle_l`.
  - _Printing._ The body prints standing on its back end with no supports: 211 mm tall for the 3 mL,
    its walls leaning in at most 45°, and its front wall bridges about 27 mm (39 on the 30 mL). Its
    rails start at the bed, so turn on the slicer's elephant-foot compensation, and use a brim. No
    edge on the body, the lid or the plate comes to a knife edge: the dovetails and the lid's bevels
    stand on short lands.
  - _Assembly._ Front mounting screws, if any; the frame into the body from the back; the lid onto
    its rails from the back; then the cap. Top mounting screws go in after the frame, or before it
    if the frame slides in with its crank along the axis, as a crank turned across carries its pin
    screws into them.

The motor never reverses. At a = 180° the plunger is in, stopping 1 mm short of the barrel's end,
and at 0° it is out, stopping 1 mm short of the plunger's stop. The margin at each end takes up
error in the measured exposed length and stroke, and in the print.

**Side load.** The rod's angle `φ` puts a side load `F·tan(φ)` on the clip, where `F` is the force
along the stroke. The rod is at least three throws long, so `φ` peaks under 19.5°: `asin(27.6/90)` =
17.9° on the 3 mL. The rails take that load; the plunger cannot carry a side load in compression.

## Motors

**N20, for the 1, 3 and 5 mL.** A 12 V N20 at about 30 rpm, a 1000:1-class gearbox: Pololu #3046 or
a generic "N20 12V 30RPM". Pololu gives #3046 35 rpm free-running and a 10 kg·cm extrapolated stall,
and recommends keeping instantaneous torque under 2.5 kg·cm on this gearbox
(<https://www.pololu.com/category/60/micro-metal-gearmotors>). 35 rpm gives a 1.7 s cycle and, on
the 3 mL, a peak plunger speed of about 101 mm/s. A lower supply voltage slows it roughly in
proportion.

**GA25, for the 10, 20 and 30 mL.** A 20 mL plunger, pushed by hand on a kitchen scale with the tip
open (2026-10-02, rough), slides at about 250 g (2.5 N), and about 500 g (4.9 N) pushed hard and
fast: 1.0 and 1.9 kg·cm on the 20 mL's 39 mm throw. The GA25YN370 at 12 V and 30 rpm gives a 12
kgf·cm stall by its seller, and Pololu recommends at most 4 kg·cm continuous on its 25 mm metal
gearboxes. Rejected: the yellow plastic "TT" gearmotor (about 0.8 kg·cm stall at 6 V: Adafruit's
datasheet for product 3777), a 20 mm "turbo worm" motor whose listing's 8 kg·cm a buyer measured at
under 1, and a 37 mm JGB37-520, with more margin than the load needs at about three times the cost.

**Which motor.** Friction differs little between sizes, but vacuum or back-pressure acts on the
bore's area, which grows fast: the 10 mL's is nearly three times the 3 mL's. Peak crank torque is
about the plunger's force times the throw; estimated from 3 N of seal friction up to 10 mL and 5 N
from 20 mL (assumed, bar the 20 mL's scale test) and BD's published bores:

| Syringe | Open line | Against full vacuum, or 1 bar of back-pressure |
| --- | --- | --- |
| 1 mL | 1.0 kg·cm | 1.5 kg·cm |
| 3 mL | 0.8 kg·cm | 2.5 kg·cm |
| 5 mL | 0.8 | 3.8 |
| 10 mL | 1.1 | 6.9 |
| 20 mL | 2.0 | 13.6 |
| 30 mL | 2.3 | 19.6 |

On an open line the N20 drives up to the 10 mL; against vacuum or pressure it suits only the 1 mL,
and the 3 mL right at its limit, the GA25 the 10 mL, and a blocked 20 or 30 mL stalls either.
Positive pressure has no ceiling, unlike vacuum. So `motor` in the Customizer is `auto`, the N20 up
to the 5 mL and the GA25 from the 10 mL, or either by name, and the report gives the estimated
torque for the syringe and motor chosen beside that motor's limit; it assumes 3 N of friction
throughout, so for the 20 and 30 mL it gives less than the table.

## Parts

### Syringes (measured)

The 3 mL measured 2026-09-29 (its barrel length and stroke 2026-10-02), the 1, 5 and 20 mL
2026-10-02. They are not BD's: the 3 and 5 mL carry no maker's mark (BD prints its logo at the
scale's end), and another maker's syringe of the same volume can differ by most of a millimetre, so
a syringe from elsewhere is measured and added as its own entry ([`measuring.md`](measuring.md)).

| Feature | 1 mL | 3 mL | 5 mL | 20 mL |
| --- | --- | --- | --- | --- |
| Barrel OD | 9.45 mm | 10.0 mm | 13.6 mm | 20.9 mm |
| Barrel, flange front face to the shoulder at the nozzle's root | 75.0 mm | 68.0 mm | 63.5 mm | 91.75 mm |
| Barrel flanges | 24.6 × 12.6 mm, 2.0 mm thick | 24.5 × 12.6 mm, 2.0 mm thick | 26.9 × 16.0 mm, 1.4 mm thick | 36.3 × 24.2 mm, 1.6 mm thick |
| Push-button | Ø10.2 mm, 1.8 mm thick | Ø12.6 mm, 1.6 mm thick | Ø16.6 mm, 1.8 mm thick | Ø20.9 mm, 1.4 mm thick |
| Working stroke | 64.25 mm | 57.25 mm | 52.5 mm | 80.0 mm |
| Plunger exposed, stopper bottomed (flange rear face to push-button front face) | 10.75 mm | 10.75 mm | 14.3 mm | 11.75 mm |
| Plunger, widest across (each narrows a little towards the push-button) | 3.8 mm, a solid rod | 7.5 mm, ribs about 1 mm thick; the last 9 mm before the push-button tapers to 6.6 mm | 11.5 mm | 18.3 mm |
| Nozzle, the barrel's shoulder to the syringe's front end | not measured | not measured | 10.2 mm, derived from the assembled unit, not measured | not measured |

### Syringes (BD, estimated)

BD Plastipak luer-lock syringes, estimated and not measured: from BD's photo of its range, scaled
against the 5 and 20 mL above, with outside diameters from published figures (Fisher's 16.21 mm for
the 10 mL, 23.77 and 29.5 mm for the 30 and 50 mL) and exposed lengths from a Terumo pump manual's
flange-to-plunger-end figures less the push-button. Good to about a millimetre; measure one in hand
and replace them. The 10 and 30 mL build; the 50 mL is not built.

| Feature | 10 mL | 30 mL | 50 mL |
| --- | --- | --- | --- |
| Barrel OD | 16.2 mm | 23.8 mm | 29.4 mm |
| Barrel, flange front face to the shoulder at the nozzle's root | 82.5 mm | 104.5 mm | 130.0 mm |
| Barrel flanges | 30.0 × 19.0 mm, 1.5 mm thick | 44.0 × 27.5 mm, 1.8 mm thick | 53.0 × 33.2 mm, 2.2 mm thick |
| Push-button | Ø18.0 mm, 1.6 mm thick | Ø26.0 mm, 1.8 mm thick | Ø31.0 mm, 2.0 mm thick |
| Working stroke | 71.0 mm | 92.5 mm | 117.0 mm |
| Plunger exposed, stopper bottomed | 11.5 mm | 14.5 mm | 15.0 mm |
| Plunger, widest across | 13.7 mm | 20.8 mm | 25.7 mm |

The parts drive 2 mm less than the working stroke, stopping 1 mm short of each end. The barrel must
be longer than the stroke plus that margin, or the stroke pulls the stopper out; `layout()` asserts
it.

The part names follow ISO 7886-1: **barrel**, **barrel flanges** (finger grips), **plunger**,
**push-button** (thumb rest), **plunger stopper** (the rubber piston) and **nozzle** (the luer
tip).

### N20 inline gearmotor

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

Held by two M1.6 × 3 JIS flat heads (McMaster 91305A002), which sit in counterbores sized for an
ISO 7045 pan head, their cone on the clearance hole's rim, 1.4 mm into the gearbox.

### GA25YN370 gearmotor, 12 V 30 rpm

HERCHR, Amazon.ca B0BX6B91L9; the same part is sold by aqxreight (B0BSC9CK13) and as the JGA25-370
and 25GA-370. Measured on the motor in hand, 2026-10-03; it agrees with Seeed's JGA25-370 drawing
(<https://media.digikey.com/pdf/Data%20Sheets/Seeed%20Technology/114090046_Web.pdf>) bar the
gearbox's length, longer at this ratio. Ratings from the HERCHR listing.

| Feature | Size |
| --- | --- |
| Gearbox | Ø25 × 26.8 |
| Can | Ø24.3 × 30.8, and 1.75 of end boss and terminals past it |
| Shaft | Ø4.0, centred, 12.5 from the gearbox face (10 past the boss); 3.5 across the flat, the flat 8 long from the tip |
| Boss | Ø7 × 2.5 |
| Mounting | 2 × M3 tapped, 17 apart across the shaft, at most 3.5 deep (Seeed's drawing; not measured). The face's other two screws hold the gearbox together: leave them in |
| Rating (listing) | 12 V, 30 rpm no load; 25 rpm at 770 gf·cm; stall 12 kgf·cm at up to 2.1 A |

Its gearbox goes 2 mm up into a round pocket, held by two M3 × 4 button heads (ISO 7380), 2.85 mm
into its holes: the plate over the pocket is 3 mm, too thin for socket heads. The crank's bore is
D-shaped only as far as the shaft's flat runs, round below. The motor hangs 57 mm under the plate,
so its bodies are deep: the 10, 20 and 30 mL's stand 239, 257 and 289 mm tall as they print.

No usable OpenSCAD model of either motor was found (NopSCADlib has none), so
`cad/purchased/motor.scad` draws them, simplified, from the figures above.

## What printing taught us

- **The rod's side load needs a guide.** On the first print the clip had no rails; on the push
  stroke the side load bowed the plunger sideways and the clip turned with it (video, 2026-09-30).
- **A short snap arm breaks.** The first snap rings, 2 mm thick and free only above the axis with an
  opening 80% of the barrel's width, snapped in PLA on every size as the barrel went in, worse as it
  grew and squashed less (reported 2026-10-05); a PETG one with its tips cut back held. The ring
  above works in PLA and in PETG (2026-10-07). `ring_test` prints the ring alone on a stub of plate,
  to try the snap on a syringe in a few minutes.
- **A printed D-bore does not hold a shaft.** Keyed only by the flat's half millimetre, a PETG
  crank's bore wore round and rode up an N20's shaft within an hour, as the load reverses every
  stroke (reported 2026-10-05). With the grub screw, cranks printed in PLA and in PETG held, and a
  2-hour run left the bore unworn (2026-10-07).

## Open

1. **Measure the 10 and 30 mL** syringes in hand and replace their estimates.
2. **Measure the GA25's mounting holes' depth.** Its screws are sized to Seeed's 3.5 mm.
3. **Measure the N20's end boss and terminals** past its can; the body allows 3 mm, nominal.
4. **Measure `nozzle_l`**, the barrel's shoulder to the syringe's front end, on every syringe but
   the 5 mL, whose figure is derived: `tip_x()` stops the build without it.
5. **Measure the plan shape of the barrel flanges.** The slot is open at the sides and sized only by
   the flanges' width, height and thickness.
