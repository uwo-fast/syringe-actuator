# Measuring a syringe

The parts are built for one syringe at a time, from the numbers in `cad/purchased/syringes.scad`.
Syringe makers do not publish these: BD, for one, gives its syringe-pump dimensions only on request,
and ISO 7886-2 notes that diameters overlap between makers and that lengths and flange thicknesses
vary from mould to mould. A "3 mL syringe" is therefore not one shape; a 3 mL Norm-Ject is 10.8 mm
across the barrel where a 3 mL BD is about 10.1. The measured presets are the unbranded syringes
this was built and tested with; the BD 10, 30 and 50 mL are estimates. Measure the syringe you will
use, and enter it as its own preset, named for its maker and size.

## The numbers

All in millimetres. The barrel's axis runs front (the nozzle) to back (the push-button).

| Key | What | Where | How much it matters |
| --- | --- | --- | --- |
| `stroke` | Usable plunger travel | Plunger from bottomed to its stop, as the change in `exposed` | **Most.** Too long and the crank drives the stopper into its stop near the end of its swing, where a crank's force is greatest |
| `exposed` | Plunger showing, stopper bottomed | Flange's rear face to the push-button's front face | **Most**, for the same reason at the other end |
| `button_d` | Push-button diameter | Across the push-button | **High.** The clip's snap grips its edge by a fraction of a millimetre |
| `barrel_od` | Barrel's outside diameter | Across the barrel, clear of the graduations | Medium. The barrel snaps into a ring |
| `button_t` | Push-button thickness | Through the push-button at its edge | Low. Sets a slot with clearance |
| `flange_t` | Flange thickness | Through a flange, clear of its ribs | Low. Sets a slot with clearance |
| `flange` | Flange `[width, height]` | Across the flanges the long way, and across them the short way | Low. Sets the frame's width and the window's |
| `plunger_span` | The plunger's widest | Across the plunger's ribs (or its rod, if solid), in front of the push-button | Low. Sets slots with clearance |
| `barrel_l` | Barrel length | Flange's front face to the shoulder at the nozzle's root | Low. Checked against `stroke`, and drawn |
| `nozzle_l` | Nozzle length | The barrel's shoulder to the syringe's front end, the nozzle's tip or its luer-lock collar's face, whichever reaches further | Only for `tip_x()`, where a mounting adapter finds the tip; may stay `undef` |

## How

Syringes are soft polypropylene, and metal caliper jaws squeeze them: a hard reading of a barrel
comes out a tenth or so small. So:

- **Lengths and widths: scan it.** A flatbed scanner at 600 dpi is a calibrated, square-on camera
  (0.04 mm a pixel) that touches nothing. Lay the syringe flat with a ruler beside it, and scan it
  twice, plunger bottomed and plunger at its stop. `exposed`, `stroke`, `barrel_l`, `flange[0]`,
  `button_d`, `barrel_od` and `plunger_span` all read from the two scans; measure from the scan's
  pixels against the ruler, not by eye.
- **Thicknesses: calipers, lightly.** Close the jaws until they just touch, and read without
  squeezing. `flange_t` and `button_t`.
- **Several units.** Measure three of the same syringe if you have them, and enter the middle
  value.
- **A photo from the side** is a poor substitute: perspective makes near parts larger than far ones,
  so a phone photo is only good to a millimetre or so.

## Adding one

Copy an entry in `cad/purchased/syringes.scad`, name it for the maker and size (`terumo_3ml`, say),
and say in its comment how and when it was measured. Add it to the `syringes` list at the bottom of
that file, to the `syringe` choice in `cad/main.scad`, and to `SYRINGES` in the justfile, then run
`just check` and `just test`: `layout()` stops the build with a message if the numbers cannot work
(a barrel shorter than its stroke, say). Print the clip and check the push-button snaps in, then the
rest; if it is loose or will not go in, raise or lower `grip` in the Customizer and print the clip
again.
