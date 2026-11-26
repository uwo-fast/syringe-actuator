# Design

**Status:** every syringe builds and passes `just test` and `just qa`. N20 units of the
per-syringe design ran as designed, one of them for 2 hours with no wear (2026-10-07). The shared
N20 body has not been printed yet. The 10 and 30 mL builds use estimated dimensions and have not
been printed yet. The syringe dimensions below were measured by hand unless marked as estimates. The
motor dimensions were measured or come from the drawings cited next to them.

## Scope

Printed parts that connect a DC gearmotor to a luer syringe so that the plunger moves back and forth
continuously. An N20 drives the 1, 3 and 5 mL syringes, and a 25 mm GA25 drives the 10, 20 and
30 mL. The motor runs in one direction directly from a DC supply. Each revolution is one full pull
and one full push.

Not in scope: what the syringe is connected to, anything that powers or controls the motor, and the
adapters used to mount the body. The body has two mounting hole patterns for these adapters.

## Mechanism

The mechanism is an in-line crank-slider. The motor shaft is vertical and lies on the line of the
syringe axis, so the crank, the rod and the plunger all move in one horizontal plane. Where a
figure applies to one syringe, it is for the 3 mL. `part="report"` gives the figures for any
syringe.

- **Frame.** A 5 mm plate as wide as the widest barrel flanges in its body group (27.3 mm for the
  N20 syringes, set by the 5 mL). The flanges drop into a slot at one end, and the slot walls take
  both the push and the pull. The barrel snaps into a ring 15 mm in front of the flange block,
  past two arms 1.6 mm thick. The arms are free from 45 deg below the axis, so they bend over a long
  arc. The opening is `ring_grip` (0.5 mm) per side narrower than the barrel, with a 45 deg lead-in
  at each tip. Two rails, 10 mm tall, run from the back wall of the slot on either side of the clip
  travel. The motor hangs under the other end of the plate, with its gearbox 2 mm up into a pocket.
  It is located by its bushing and held by two screws in counterbores under the crank hub. The
  screws lie along the stroke, so they resist the push and pull of the rod. An N20 is mounted with
  its 12 mm side along x.
- **Cradle.** A sleeve under the plate that grips the gearbox over its whole length below the
  plate: 10.5 mm on an N20 and 24.8 mm on a GA25. The rod force acts about 15 mm above the gearbox
  face and reverses every stroke. With only the 2 mm pocket and the two screws to restrain it, the
  motor rocks and the screws work loose. Two set screws in trapped nuts push the gearbox against the
  opposite walls, so it has no play to rock in. On an N20, one goes through the front wall and one
  through the -y wall. On a GA25, both go through the front, 30 deg either side of -x. Two M3 x 8
  screws hold the cradle to the plate from below, through flanges at its front and back, threaded
  4 mm into the plate. The plate is wider where the cradle needs it to be, to pass between the body
  rails. The cradle prints top face down.
- **Crank.** The crank presses onto the motor D-shaft and carries the pin at a throw of half the
  syringe stroke, less a 1 mm margin at each end: 27.6 mm for the 3 mL. The D-bore is blind, so the
  crank stops on the tip of the shaft, 1 mm above the plate. An M3 x 6 socket-head screw runs
  through a lobe behind the hub onto the flat of the shaft, which faces it. The screw threads
  through an M3 square nut dropped into a slot from the top. A hex nut turns in the slot; the
  square nut cannot. The steel-on-steel contact carries the torque and holds the crank down.
- **Rod.** At least three throws long, and 90 mm at the shortest, from the crank pin to the clip.
  It lies on the top faces of both parts. Each end turns on a printed boss 0.3 mm taller than the
  rod. An M3 x 10 screw and washer clamp the boss, not the rod, so the joint turns freely with the
  screw tight.
- **Plunger clip.** The push-button drops into a cup and snaps past two lips (`grip` in the
  Customizer), so the syringe stays in place whichever way up the unit is. The plunger passes
  through a slot in the front wall of the cup. A sled under the clip extends 20 mm past the rod pin
  and runs between the frame rails with 0.3 mm clearance per side, 2 mm below the rod.
- **Body.** A shell fitted around the parts the frame carries. It is symmetric about the vertical
  plane through the axis, square at the top, and chamfered at the bottom as far as the contents
  allow. `layout()` sizes each section from the extreme positions of the frame's contents over a
  full turn.
  - _Shared._ The N20 syringes (1, 3 and both 5 mL) share one body, lid and cap, sized for the
    largest requirement of each syringe, measured from the motor shaft. Their axis height and plate
    width are the largest in the group, and the plate of each frame extends forward to the shared
    front wall. Swapping syringes therefore means reprinting only the frame, clip, crank and rod.
    The group is the fourth column of `syringes`. Each GA25 syringe still has its own body.
  - _Shape._ Narrow and shallow at the front, where there is only the syringe, the plate and the
    clip. Full width and motor depth where the crank turns. A taper in between, which `layout()`
    checks against the rod swing and keeps within 45 deg of the body axis.
  - _Frame and cap._ The frame slides in from the back, up to the front wall, on rails that take the
    dovetailed edges of the plate. A cap screwed to the back end (2 x M3 x 10) holds the frame in
    place with a post in the same rails, and has an exit for the motor wires.
  - _Window and lid._ The syringe is loaded and removed through a window in the roof at any clip
    position, with the barrel passing through a slot in the front wall. The window ends in a 45 deg
    point. A lid slides on rails along the roof between a lip on the front wall and the cap. A bump
    under its back end clicks into a notch when the lid is shut, and runs in a groove for the rest
    of its travel. Over the wider back section the rails extend out to the sides and fill the roof
    shoulders flush with the rail tops, so the rails cannot snap off and there is no inside corner
    to clean. A tab on the front end of the lid fills the barrel slot through the lip on the front
    wall, so the shut lid closes the slot at its own level. When nothing is mounted on the front, an
    optional front plate closes the rest of the slot. It has the outline of the front face, is held
    by the four front mounting screws and nuts, and has a hole just larger than the barrel.
  - _Mounting._ Two patterns of four M3 clearance holes. Each hole is sealed by a 0.6 mm knockout
    skin at the outer face until the user drills or punches it out. The screw heads sit inside.
    - The front pattern goes through the front wall beside the barrel slot. Its holes are 10 mm
      apart vertically. Horizontally they are the narrowest multiple of 10 mm apart at which the
      screw heads clear the snap ring on the frame, for the widest ring in the body group: 30 mm for
      the N20 syringes and the 10 mL, and 40 mm for the 20 and 30 mL. The pattern is centred 15 mm
      above the underside of the plate.
    - The top pattern goes through the roof shoulders, 60 mm across by 20 mm along, centred 15 mm
      in front of the back end, behind the crank sweep.

    Another OpenSCAD project draws its adapter from the layout with `use <cad/main.scad>`.
    `actuator(syringe, motor)` returns the layout, `front_x()` and the body's `front_face()` give
    the outer face of the front wall, the body's `mount_front` and `mount_top` give the holes, and
    `tip_x()` gives the front end of the syringe, from its `nozzle_l`.
  - _Printing._ The body prints standing on its front wall with no supports. It is 242 mm tall for
    the N20 syringes. The frame stops against the front wall, so that wall prints flat on the bed
    rather than bridged. In this orientation nothing overhangs by more than 45 deg. The walls lean
    in by at most 45 deg, the window ends in a 45 deg point, and the cap bosses taper into the wall.
    The four roof mounting holes print as small horizontal holes. Turn on elephant-foot compensation
    in the slicer, and use a brim, because the body is tall on a small footprint. No edge on the
    body, the lid or the plate is a knife edge: the dovetails and the lid bevels end in short lands.
  - _Assembly._ Fit the front mounting screws, if any. Slide the frame into the body from the back,
    then the lid onto its rails from the back, then fit the cap. Fit the top mounting screws after
    the frame, or before it if the frame slides in with the crank along the axis, because a crank
    turned across the axis carries its pin screws into them.

The motor never reverses. At a = 180 deg the plunger is in, stopping 1 mm short of the end of the
barrel. At 0 deg it is out, stopping 1 mm short of the plunger stop. The margin at each end absorbs
error in the measured exposed length and stroke, and in the print.

**Side load.** The rod angle `phi` puts a side load `F * tan(phi)` on the clip, where `F` is the
force along the stroke. The rod is at least three throws long, so `phi` peaks below 19.5 deg:
`asin(27.6/90)` = 17.9 deg on the 3 mL. The rails take that load, because the plunger cannot carry a
side load in compression.

## Motors

**N20, for the 1, 3 and 5 mL.** A 12 V N20 at about 30 rpm with a 1000:1-class gearbox, such as
Pololu #3046 or a generic "N20 12V 30RPM". Pololu rates #3046 at 35 rpm free-running with a
10 kg.cm extrapolated stall torque, and recommends keeping instantaneous torque under 2.5 kg.cm on
this gearbox (<https://www.pololu.com/category/60/micro-metal-gearmotors>). At 35 rpm the cycle
time is 1.7 s, and the peak plunger speed on the 3 mL is about 101 mm/s. A lower supply voltage
reduces the speed roughly in proportion.

**GA25, for the 10, 20 and 30 mL.** A 20 mL plunger, pushed by hand on a kitchen scale with the tip
open (2026-10-02, rough), slides at about 250 g (2.5 N), and at about 500 g (4.9 N) when pushed hard
and fast. On the 39 mm throw of the 20 mL, that is 1.0 and 1.9 kg.cm. The seller rates the
GA25YN370 at 12 V and 30 rpm at 12 kgf.cm stall torque, and Pololu recommends at most 4 kg.cm
continuous on its 25 mm metal gearboxes. Rejected alternatives:

- the yellow plastic "TT" gearmotor (about 0.8 kg.cm stall at 6 V, from Adafruit's datasheet for
  product 3777);
- a 20 mm "turbo worm" motor, listed at 8 kg.cm, which a buyer measured at under 1;
- a 37 mm JGB37-520, which has more margin than the load needs at about three times the cost.

**Which motor.** Friction differs little between syringe sizes, but vacuum or back-pressure acts on
the bore area, which increases quickly: the 10 mL bore area is nearly three times that of the 3 mL.
Peak crank torque is about the plunger force times the throw. The table estimates it from 3 N of
seal friction up to 10 mL and 5 N from 20 mL (assumed, except for the 20 mL scale test), and from
BD's published bores:

| Syringe | Open line | Against full vacuum (1.013 bar) |
| --- | --- | --- |
| 1 mL | 1.0 kg.cm | 1.5 kg.cm |
| 3 mL | 0.8 kg.cm | 2.5 kg.cm |
| 5 mL, the first | 0.8 | 3.8 |
| 5 mL, the second | 0.7 | 3.4 |
| 10 mL | 1.1 | 6.9 |
| 20 mL | 2.0 | 13.6 |
| 30 mL | 2.3 | 19.4 |

On an open line the N20 can drive up to the 10 mL. Against vacuum or pressure it suits only the
1 mL, with the 3 mL right at its limit. The 6.9 kg.cm of the 10 mL against vacuum is below the
12 kg.cm stall torque of the GA25, but above the 4 kg.cm continuous limit that the report applies.
A blocked 20 or 30 mL stalls either motor. Unlike vacuum, positive pressure has no upper limit.
`motor` in the Customizer is therefore `auto` (the N20 up to the 5 mL and the GA25 from the 10 mL),
or either motor by name. The report gives the estimated torque for the chosen syringe and motor
next to that motor's limit. The report assumes 3 N of friction for all syringes, so for the 20 and
30 mL it gives less than the table.

## Parts

### Syringes (measured)

The 3 mL was measured on 2026-09-29 (its barrel length and stroke on 2026-10-02), the 1, 5 and
20 mL on 2026-10-02, and a second 5 mL before 2026-11-06. They are not BD syringes: the 3 and 5 mL
have no maker's mark (BD prints its logo at the end of the scale). A syringe of the same volume from
another maker can differ by most of a millimetre, so any other syringe is measured and added as a
separate entry ([`measuring.md`](measuring.md)).

| Feature | 1 mL | 3 mL | 5 mL | 20 mL |
| --- | --- | --- | --- | --- |
| Barrel OD | 9.45 mm | 10.0 mm | 13.6 mm | 20.9 mm |
| Barrel, flange front face to the shoulder at the nozzle's root | 75.0 mm | 68.0 mm | 63.5 mm | 91.75 mm |
| Barrel flanges | 24.6 x 12.6 mm, 2.0 mm thick | 24.5 x 12.6 mm, 2.0 mm thick | 26.9 x 16.0 mm, 1.4 mm thick | 36.3 x 24.2 mm, 1.6 mm thick |
| Push-button | dia 10.2 mm, 1.8 mm thick | dia 12.6 mm, 1.6 mm thick | dia 16.6 mm, 1.8 mm thick | dia 20.9 mm, 1.4 mm thick |
| Working stroke | 64.25 mm | 57.25 mm | 52.5 mm | 80.0 mm |
| Plunger exposed, stopper bottomed (flange rear face to push-button front face) | 10.75 mm | 10.75 mm | 14.3 mm | 11.75 mm |
| Plunger, widest across (each narrows a little towards the push-button) | 3.8 mm, a solid rod | 7.5 mm, ribs about 1 mm thick; the last 9 mm before the push-button tapers to 6.6 mm | 11.5 mm | 18.3 mm |
| Nozzle, the barrel's shoulder to the syringe's front end | not measured | not measured | 10.2 mm, derived from the assembled unit, not measured | not measured |

A second generic 5 mL (`5ml-gnr2`) has the same cross-axis dimensions as the 5 mL in the table, but
is shorter: stroke 47.3, exposed 13.6, barrel 56.8 and nozzle 10.0 mm, measured. Its `crank_as`
field points to the row of the first 5 mL (`5ml-gnr1`), so `layout()` gives it a 93.3 mm rod that
keeps the crank in the same position as on the first. A unit printed for the first 5 mL therefore
accepts the second with only a new crank and rod; the frame, clip, body, lid and cap carry over.
The nozzle tip of the second then sits 6.9 mm further back from the front face of the body
(32.7 mm past it, against 39.6), so an adapter drawn to the `tip_x()` of the first does not reach
it. The 5 mL column in the table is the first 5 mL.

### Syringes (BD, estimated)

BD Plastipak luer-lock syringes, estimated and not measured. The dimensions are scaled from BD's
photo of its range against the 5 and 20 mL above. Outside diameters come from published figures
(Fisher's 16.21 mm for the 10 mL, and 23.77 and 29.5 mm for the 30 and 50 mL). Exposed lengths come
from the flange-to-plunger-end figures in a Terumo pump manual, less the push-button. The estimates
are good to about a millimetre; replace them with measurements of a real syringe. The 10 and 30 mL
are built; the 50 mL is not.

| Feature | 10 mL | 30 mL | 50 mL |
| --- | --- | --- | --- |
| Barrel OD | 16.2 mm | 23.8 mm | 29.4 mm |
| Barrel, flange front face to the shoulder at the nozzle's root | 82.5 mm | 104.5 mm | 130.0 mm |
| Barrel flanges | 30.0 x 19.0 mm, 1.5 mm thick | 44.0 x 27.5 mm, 1.8 mm thick | 53.0 x 33.2 mm, 2.2 mm thick |
| Push-button | dia 18.0 mm, 1.6 mm thick | dia 26.0 mm, 1.8 mm thick | dia 31.0 mm, 2.0 mm thick |
| Working stroke | 71.0 mm | 92.5 mm | 117.0 mm |
| Plunger exposed, stopper bottomed | 11.5 mm | 14.5 mm | 15.0 mm |
| Plunger, widest across | 13.7 mm | 20.8 mm | 25.7 mm |

The parts drive 2 mm less than the working stroke, stopping 1 mm short of each end. The barrel must
be longer than the stroke plus that margin, or the stroke pulls the stopper out. `layout()` asserts
this.

The part names follow ISO 7886-1: **barrel**, **barrel flanges** (finger grips), **plunger**,
**push-button** (thumb rest), **plunger stopper** (the rubber piston) and **nozzle** (the luer
tip).

### N20 inline gearmotor

From Pololu's micro metal gearmotor dimension drawing
(<https://www.pololu.com/file/0J949/micro-metal-gearmotor-dimensions.pdf>, 2024-04-03), except the
shaft length, which was measured on the motor (2026-09-29):

| Feature | Size |
| --- | --- |
| Can | 12.0 wide x 10.0 across flats x 15 long; end cap 1.2, then a dia 5 boss |
| Gearbox | 12.0 x 10.0 x 9 long (12.5 at 1000:1) |
| Shaft | dia 3.0, 2.5 across the flat; 9 long from the gearbox face (measured), D-profile over its whole length |
| Bushing | dia 4.0, 0.7 proud |
| Mounting | 2 x M1.6 tapped, 9.0 apart, either side of the shaft |

The motor is held by the cradle under the plate and by two M1.6 x 3 JIS flat-head screws (McMaster
91305A002), which engage 1.4 mm into the gearbox. The screws sit in counterbores sized for an
ISO 7045 pan head, with their cone seated on the rim of the clearance hole.

### GA25YN370 gearmotor, 12 V 30 rpm

HERCHR, Amazon.ca B0BX6B91L9. The same part is sold by aqxreight (B0BSC9CK13) and as the JGA25-370
and 25GA-370. Measured on the motor, 2026-10-03. The measurements agree with Seeed's JGA25-370
drawing (<https://media.digikey.com/pdf/Data%20Sheets/Seeed%20Technology/114090046_Web.pdf>) except
for the gearbox length, which is longer at this ratio. Ratings are from the HERCHR listing.

| Feature | Size |
| --- | --- |
| Gearbox | dia 25 x 26.8 |
| Can | dia 24.3 x 30.8, and 1.75 of end boss and terminals past it |
| Shaft | dia 4.0, centred, 12.5 from the gearbox face (10 past the boss); 3.5 across the flat, the flat 8 long from the tip |
| Boss | dia 7 x 2.5 |
| Mounting | 2 x M3 tapped, 17 apart across the shaft, at most 3.5 deep (Seeed's drawing; not measured). The face's other two screws hold the gearbox together: leave them in |
| Rating (listing) | 12 V, 30 rpm no load; 25 rpm at 770 gf.cm; stall 12 kgf.cm at up to 2.1 A |

The gearbox goes 2 mm up into a round pocket and is held by two M3 x 4 button-head screws
(ISO 7380), which engage 2.85 mm into its holes. The plate over the pocket is 3 mm thick, too thin
for socket heads. The crank bore is D-shaped only as far as the flat on the shaft extends, and
round below it. The motor hangs 57 mm under the plate, so the GA25 bodies are deep: the 5, 10, 20
and 30 mL bodies are 223, 256, 277 and 313 mm tall as printed.

No usable OpenSCAD model of either motor was found (NopSCADlib has none), so
`cad/purchased/motor.scad` draws simplified models from the dimensions above.

## Lessons from printing

- **The side load from the rod needs a guide.** On the first print the clip had no rails. On the
  push stroke the side load bowed the plunger sideways and the clip turned with it (video,
  2026-09-30).
- **A short snap arm breaks.** The first snap rings were 2 mm thick, free only above the axis, and
  had an opening 80% of the barrel width. They broke in PLA on every size as the barrel went in,
  and more so on larger sizes, where the barrel deforms less (reported 2026-10-05). A PETG ring with
  its tips cut back held. The ring described above works in PLA and in PETG (2026-10-07).
  `ring_test` prints the ring alone on a stub of plate, so the snap can be tried on a syringe in a
  few minutes.
- **A printed D-bore does not hold a shaft.** Keyed only by the half-millimetre flat, the bore of a
  PETG crank wore round and rode up an N20 shaft within an hour, because the load reverses every
  stroke (reported 2026-10-05). With the grub screw, cranks printed in PLA and in PETG held, and a
  2-hour run left the bore unworn (2026-10-07).
- **A crank set screw tightened hard tips the crank.** On the unit in the next item, an
  overtightened grub screw tipped the crank on its shaft and stalled the stroke (2026-11-06 to
  11-07).
- **Two screws do not hold a motor against a reversing load.** A 5 mL unit (`5ml-gnr2`) on an N20
  drove the sampler of a turbidity column. It drew a full 5 mL of algae culture from an
  unpressurized, sparged column through a 3 mm riser, in one 18.5 s burst every 15 minutes: 1 s at
  full throttle, then 17.5 s at half. From its first burst, 2026-11-06 22:46, to the last burst
  that moved liquid, 2026-11-15 08:19, it ran 8.40 days, 863 bursts, and 4.43 h with the motor on.
  The motor screws worked loose until the motor rocked, and the crank D-bore cammed out on the
  shaft. Threadlocker only delayed the failure. Each burst time is taken from its own 50 Hz log
  rows, in
  [turbidity-sensor](https://github.com/uwo-fast/turbidity-sensor/tree/9afcb18/data/bench/2026-11-05).
  At that time the screws lay across the stroke, on the line the motor tipped about, so only the
  2 mm pocket held the motor. The motor now stands with its screws along the stroke, and the cradle
  grips the gearbox. The 5 mL also builds on the GA25 (`5ml-gnr1-ga25`, `5ml-gnr2-ga25`) while both
  are tested.

## Open

1. **Measure the 10 and 30 mL** syringes in hand and replace their estimates.
2. **Measure the GA25's mounting holes' depth.** Its screws are sized to Seeed's 3.5 mm.
3. **Measure the N20's end boss and terminals** past its can; the body allows 3 mm, nominal.
4. **Measure `nozzle_l`** (barrel shoulder to the front end of the syringe) on the 1, 3, 10, 20 and
   30 mL, where `tip_x()` stops the build without it, and on the first 5 mL, whose figure is
   derived.
5. **Measure the plan shape of the barrel flanges.** The slot is open at the sides and sized only by
   the width, height and thickness of the flanges.
