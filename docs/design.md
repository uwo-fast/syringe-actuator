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
The body has two mounting interfaces, plain holes a user's own adapter screws to; the adapters are
not in scope.

## Mechanism

An in-line crank-slider. The motor's shaft stands vertical on the line of the syringe's axis, so the
crank, the rod and the plunger all move in one horizontal plane:

- **Frame.** A 5 mm plate, about 175 × 25 mm, as wide as the barrel flanges. They drop into a slot
  at one end, and the slot's walls take both the push and the pull. The barrel snaps into a ring 15
  mm in front of the slot. Two rails, 8 mm tall, run from the slot's back wall either side of the
  clip's travel, out to the plate's edges. The motor hangs under the plate's other end: its gearbox
  sits 2 mm up into a pocket, located by its bushing and held by two M1.6 × 3 JIS flat heads
  (McMaster 91305A002), counterbored below the crank's hub.
- **Crank.** It presses onto the 3 mm D-shaft and carries the pin at a throw of half the syringe's
  stroke less a 1 mm margin at each end: **27.6 mm** for the 3 mL's 57.25 mm. Its D-bore is blind,
  so pressed on, it stops on the shaft's tip, 1 mm over the plate.
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
  roof's middle the rest of its travel. Over the wider back, the lid's rails run out to the sides,
  filling the roof's shoulders flush with the rails' tops: the rails cannot snap off, and there is
  no inside corner to clean. Two mounting patterns, each four M3 clearance holes the same for every
  syringe, take a user's adapter: one through the front wall, 30 across by 10 up, centred 15 mm over
  the plate's underside, beside the barrel's slot; one through the roof's shoulders, 60 across by 20
  along, centred 15 mm in front of the back end, behind the crank's sweep. The screws' heads sit
  inside. The front ones can go in before the frame; the top ones too if the frame slides in with
  its crank along the axis, since one turned across carries its pin screws into them. The
  push-button snaps into the clip's cup past two small lips, so the syringe stays in whichever way
  up the unit is. The body prints standing on its back end, 217 mm tall, with no supports: its walls
  lean in at most 45 degrees, `layout()` starting the taper sooner where they would lean further
  (the 3 mL's lean 43), and the front wall bridges about 27 mm. Its rails start at the bed, so turn
  on the slicer's elephant-foot compensation, and use a brim. No edge on it, the lid or the frame's
  plate comes to a knife edge: the dovetails and the lid's bevels stand on short lands. Assembly:
  frame into the body from the back, lid onto its rails from the back, then the cap.

The motor never reverses: each revolution is one pull and one push. At a = 180° the plunger is in,
stopping 1 mm short of the barrel's end, and at 0° it is out, stopping 1 mm short of the plunger's
stop. The margin at each end takes up error in the measured exposed length and stroke, and in the
print.

**Side load.** The rod's angle `φ` puts a side load `F·tan(φ)` on the clip, where `F` is the force
along the stroke. The rod is at least three throws long, so `φ` peaks at `asin(27.6/90)` = 17.9° on
the 3 mL. The rails take that load. On the first print the clip had no guide. On the push stroke the
side load bowed the plunger sideways and the clip turned with it (video, 2026-09-30). The plunger
cannot carry a side load in compression.

**Torque (estimate).** The peak crank torque is about `F·r`. At an assumed 3 N of seal friction
(unmeasured) and `r` = 27.6 mm, that is about 0.08 N·m (0.8 kg·cm). A fully blocked line adds full
vacuum on the bore: about 5.9 N at 8.66 mm ID, which makes 2.5 kg·cm with the friction.

**Motor.** A 12 V N20 at about 30 rpm, which is a 1000:1-class gearbox: Pololu #3046 or a generic
"N20 12V 30RPM". Pololu's #3046 gives 35 rpm free-running and a 10 kg·cm extrapolated stall, and
recommends keeping instantaneous torque under 2.5 kg·cm on this gearbox
(<https://www.pololu.com/category/60/micro-metal-gearmotors>). The running load is about a third of
that limit, and a blocked line reaches about the limit. 35 rpm gives a 1.7 s cycle and a peak
plunger speed of about 101 mm/s. A lower supply voltage slows the motor roughly in proportion.

**Motor for the larger syringes.** A 20 mL plunger, pushed by hand on a kitchen scale with the tip
open (2026-10-02, rough), slides at about 250 g (2.5 N) and about 500 g (4.9 N) pushed hard and
fast. On a crank of 39 mm throw, for its measured 80 mm stroke, that is about 1.0 kg·cm running and
1.9 kg·cm at the hard push; a fully blocked line would add about 29 N of vacuum on the 19.1 mm bore
and stall any motor considered here. The motor chosen is a 25 mm GA25YN370 at 12 V and 30 rpm
(Parts, below): its seller gives a 12 kgf·cm stall, and Pololu recommends at most 4 kg·cm continuous
on its 25 mm metal gearboxes, so it runs at under a tenth of its stall and well within what a
gearbox of its size takes continuously. Rejected: the yellow plastic "TT" gearmotor (about 0.8 kg·cm
stall at 6 V, 1:48, about 200 rpm: Adafruit's datasheet for product 3777), and a 20 mm "turbo worm"
motor whose listing's 8 kg·cm a buyer measured at under 1. A 37 mm JGB37-520 has more margin but
costs about three times as much, and the measured load does not need it.

## Parts

### Syringes (measured)

The 3 mL measured 2026-09-29 (its barrel length and stroke 2026-10-02), the 1, 5 and 20 mL
2026-10-02. `syringe` in the Customizer picks which one the parts are built for: the 1, 3 or 5 mL,
or BD's 10 mL below. The 20 mL waits on the round 25 mm motor, which the frame does not take yet.
They are not BD's: the 3 and 5 mL carry no maker's mark (BD prints its logo at the scale's end), and
another maker's syringe of the same volume can differ by most of a millimetre, so a syringe from
elsewhere is measured and added as its own entry ([`measuring.md`](measuring.md)).

| Feature | 1 mL | 3 mL | 5 mL | 20 mL |
| --- | --- | --- | --- | --- |
| Barrel OD | 9.45 mm | 10.0 mm | 13.6 mm | 20.9 mm |
| Barrel, flange front face to the shoulder at the nozzle's root | 75.0 mm | 68.0 mm | 63.5 mm | 91.75 mm |
| Barrel flanges | 24.6 × 12.6 mm, 2.0 mm thick | 24.5 × 12.6 mm, 2.0 mm thick | 26.9 × 16.0 mm, 1.4 mm thick | 36.3 × 24.2 mm, 1.6 mm thick |
| Push-button | Ø10.2 mm, 1.8 mm thick | Ø12.6 mm, 1.6 mm thick | Ø16.6 mm, 1.8 mm thick | Ø20.9 mm, 1.4 mm thick |
| Working stroke | 64.25 mm | 57.25 mm | 52.5 mm | 80.0 mm |
| Plunger exposed, stopper bottomed (flange rear face to push-button front face) | 10.75 mm | 10.75 mm | 14.3 mm | 11.75 mm |
| Plunger, widest across (each narrows a little towards the push-button) | 3.8 mm, a solid rod | 7.5 mm, ribs about 1 mm thick; the last 9 mm before the push-button tapers to 6.6 mm | 11.5 mm | 18.3 mm |

### Syringes (BD, estimated)

BD Plastipak luer-lock syringes, estimated and not measured: from BD's photo of its range, scaled
against the 5 and 20 mL above, with outside diameters from published figures (Fisher's 16.21 mm
for the 10 mL, 23.77 and 29.5 mm for the 30 and 50 mL) and exposed lengths from a Terumo pump
manual's flange-to-plunger-end figures less the push-button. Good to about a millimetre; measure one
in hand and replace them. The 10 mL builds on the N20; the 30 and 50 mL need the round motor too.

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

The size is inferred to be 3 mL, because published 3 mL inner diameters (8.57–8.94 mm, BD and
Terumo, from syringe-pump libraries) give 3.3–3.6 mL over 57.25 mm. A 5 mL barrel (ID about 12 mm)
cannot have a 10 mm OD.

The part names follow ISO 7886-1: **barrel**, **barrel flanges** (finger grips), **plunger**,
**push-button** (thumb rest), **plunger stopper** (the rubber piston) and **nozzle** (the luer
tip).

### N20 inline gearmotor (the one used, for the 1, 3 and 5 mL)

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

### GA25YN370 gearmotor, 12 V 30 rpm (for the larger syringes)

Ordered 2026-10-02: HERCHR, Amazon.ca B0BX6B91L9; the same part is sold by aqxreight (B0BSC9CK13)
and as the JGA25-370 and 25GA-370. Outline from Seeed's JGA25-370 drawing
(<https://media.digikey.com/pdf/Data%20Sheets/Seeed%20Technology/114090046_Web.pdf>), the same 25 mm
form factor; ratings from the HERCHR listing.

| Feature | Size |
| --- | --- |
| Gearbox | Ø25 × L; L grows with the ratio (21 on Seeed's 350 rpm part) and is not given for this one: measure |
| Can | Ø24.4 × 30.8 |
| Shaft | Ø4.0, 3.5 across the flat, the flat 8 long from the tip; 10 long (listing) or 11.5 ± 0.5 (Seeed) from the gearbox face: measure |
| Boss | Ø7 × 2.5 |
| Mounting | 2 × M3 tapped, 17 apart across the shaft, at most 3.5 deep. The face's other two screws hold the gearbox together: leave them in |
| Rating (listing) | 12 V, 30 rpm no load; 25 rpm at 770 gf·cm; stall 12 kgf·cm at up to 2.1 A |

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
2. **Mounting:** adapters for the two hole patterns, for a stand, a rail or a breadboard, are a
   user's to design.
3. **Measure** the barrel's length, flange to luer tip, and the motor's end boss and terminals past
   its can. The body is sized with 3 mm nominal for the terminals.
4. **Measure the GA25YN370 when it arrives:** its gearbox length, the shaft's length from the gearbox
   face, where its two M3 holes sit relative to the D-flat, and its end boss and terminals.
