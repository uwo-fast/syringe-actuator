# Measuring a syringe

Each syringe has its own frame, clip, crank and rod, generated from the dimensions in
`cad/purchased/syringes.scad`. Syringes in the same body group share the body, lid and cap.
Syringe makers do not publish these dimensions. BD, for example, provides its syringe-pump
dimensions only on request, and ISO 7886-2 notes that diameters overlap between makers and that
lengths and flange thicknesses vary from mould to mould. A "3 mL syringe" therefore does not have
one shape: a 3 mL Norm-Ject barrel is 10.8 mm across, and a 3 mL BD barrel is about 10.1 mm. The
measured presets are the unbranded syringes the actuator was built and tested with. The BD 10, 30
and 50 mL presets are estimates. Measure the syringe you will use, and enter it as a separate
preset, named for its volume and maker.

## The numbers

All dimensions are in millimetres. The barrel axis runs from front (the nozzle) to back (the
push-button).

| Key | What | Where | How much it matters |
| --- | --- | --- | --- |
| `stroke` | Usable plunger travel | Plunger from bottomed to its stop, as the change in `exposed` | **Most.** If it is too long, the crank drives the stopper into its stop near the end of the crank swing, where the crank force is greatest |
| `exposed` | Exposed plunger length, stopper bottomed | Rear face of the flange to the front face of the push-button | **Most**, for the same reason at the other end |
| `button_d` | Push-button diameter | Across the push-button | **High.** The clip snap grips the edge by a fraction of a millimetre |
| `barrel_od` | Barrel outside diameter | Across the barrel, clear of the graduations | Medium. The barrel snaps into a ring |
| `button_t` | Push-button thickness | Through the push-button at its edge | Low. Sets a slot with clearance |
| `flange_t` | Flange thickness | Through a flange, clear of its ribs | Low. Sets a slot with clearance |
| `flange` | Flange `[width, height]` | Across the flanges the long way, and across them the short way | Low. Sets the width of the frame and of the window |
| `plunger_span` | Widest part of the plunger | Across the plunger ribs (or the rod, if solid), in front of the push-button | Low. Sets slots with clearance |
| `barrel_l` | Barrel length | Front face of the flange to the shoulder at the root of the nozzle | Low. Checked against `stroke`, and drawn |
| `bore_d` | Barrel bore | Not measured: BD's published bore for the volume | Only for the torque estimate in the report |
| `nozzle_l` | Nozzle length | Barrel shoulder to the front end of the syringe: the nozzle tip or the face of the luer-lock collar, whichever extends further | Only for `tip_x()`, which a mounting adapter uses to locate the tip; may stay `undef` |

## How

Syringes are made of soft polypropylene, and metal caliper jaws squeeze them. A barrel measured
with firm pressure reads about 0.1 mm small. Therefore:

- **Lengths and widths: scan the syringe.** A flatbed scanner at 600 dpi works as a calibrated,
  square-on camera (0.04 mm per pixel) that does not touch the part. Lay the syringe flat with a
  ruler beside it, and scan it twice: once with the plunger bottomed and once with the plunger at
  its stop. `exposed`, `stroke`, `barrel_l`, `flange[0]`, `button_d`, `barrel_od` and
  `plunger_span` can all be read from the two scans. Measure from the scan pixels against the ruler,
  not by eye.
- **Thicknesses: use calipers lightly.** Close the jaws until they just touch, and read without
  squeezing. This applies to `flange_t` and `button_t`.
- **Several units.** Measure three of the same syringe if you have them, and enter the median
  value.
- **A photo from the side** is a poor substitute. Perspective makes near parts look larger than far
  ones, so a phone photo is only accurate to about a millimetre.

## Adding one

Copy an entry in `cad/purchased/syringes.scad` and name it for the volume and maker, for example
`syringe_3ml_terumo`, selected as `3ml-terumo`. The selection name uses a hyphen, not an underscore,
because `tools/qa/qa.sh` splits its job names on underscores. In the entry's comment, record how and
when the syringe was measured.

Add the syringe to:

- the `syringes` list at the bottom of that file, with the body group of the syringes it should
  share a body with. A syringe larger than the others enlarges the body for the whole group, and
  bodies already printed then no longer fit;
- the `syringe` choice in `cad/main.scad`;
- `SYRINGES` in the justfile.

Then run `just check` and `just test`. `layout()` stops the build with a message if the dimensions
cannot work (for example, a barrel shorter than its stroke). Print the clip first and check that the
push-button snaps in, then print the rest. If the clip is loose or the push-button will not go in,
raise or lower `grip` in the Customizer and print the clip again.
