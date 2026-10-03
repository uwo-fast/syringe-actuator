# SPDX-License-Identifier: GPL-3.0-or-later
"""The bounding boxes of the closed paths in an OpenSCAD 2D SVG, as [h0..h1, v0..v1] with v flipped
back to the section's; at most five, then "...". Paths under 0.001 mm2 are dropped: OpenSCAD's
Manifold backend leaves zero-area residue along edges after an offset, where 2021.01 leaves none.

usage: python3 tools/qa/svg_boxes.py section.svg
"""

import re
import sys

MIN_AREA = 0.001

boxes = []
for d in re.findall(r'd="([^"]+)"', open(sys.argv[1]).read()):
    for sub in re.split(r"(?=M)", d):
        n = list(map(float, re.findall(r"-?\d+\.?\d*(?:e-?\d+)?", sub)))
        h, v = n[0::2], n[1::2]
        if len(h) < 3 or len(h) != len(v):
            continue
        area = abs(sum(h[i] * v[i - 1] - h[i - 1] * v[i] for i in range(len(h)))) / 2
        if area >= MIN_AREA:
            boxes.append("[%.2f..%.2f, %.2f..%.2f]" % (min(h), max(h), -max(v), -min(v)))
print(" ".join(boxes[:5]) + (" ..." if len(boxes) > 5 else "") if boxes else "none")
