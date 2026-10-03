# SPDX-License-Identifier: GPL-3.0-or-later
"""Overhangs in an ASCII STL in its print orientation: facets facing down more than 45 degrees from vertical, off
the bed. Prints the part's size and height, then each cluster of such facets with its area and extent.

usage: python3 tools/qa/overhangs.py part.stl [...]
"""
import math
import re
import sys

LIMIT = math.sin(math.radians(45))  # a face whose downward normal exceeds this is steeper than 45 deg from vertical


def facets(path):
    txt = open(path).read()
    for m in re.finditer(r"outer loop\s+vertex\s+(\S+) (\S+) (\S+)\s+vertex\s+(\S+) (\S+) (\S+)\s+vertex\s+(\S+) (\S+) (\S+)", txt):
        v = [float(c) for c in m.groups()]
        yield (v[0:3], v[3:6], v[6:9])


def sub(a, b):
    return [a[i] - b[i] for i in range(3)]


def cross(a, b):
    return [a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]]


for path in sys.argv[1:]:
    fs = list(facets(path))
    pts = [p for f in fs for p in f]
    lo = [min(p[i] for p in pts) for i in range(3)]
    hi = [max(p[i] for p in pts) for i in range(3)]
    down = []
    for f in fs:
        n = cross(sub(f[1], f[0]), sub(f[2], f[0]))
        area = math.sqrt(sum(c * c for c in n)) / 2
        if area < 1e-9:
            continue
        nz = n[2] / (2 * area)
        if nz < -LIMIT and min(p[2] for p in f) > lo[2] + 0.3:
            down.append((f, area, nz))
    # cluster by height band and position
    clusters = []
    for f, area, nz in down:
        fl = [min(p[i] for p in f) for i in range(3)]
        fh = [max(p[i] for p in f) for i in range(3)]
        for c in clusters:
            if all(fl[i] <= c["hi"][i] + 1 and fh[i] >= c["lo"][i] - 1 for i in range(3)):
                c["lo"] = [min(c["lo"][i], fl[i]) for i in range(3)]
                c["hi"] = [max(c["hi"][i], fh[i]) for i in range(3)]
                c["area"] += area
                c["flat"] = c["flat"] or nz < -0.999
                break
        else:
            clusters.append({"lo": fl, "hi": fh, "area": area, "flat": nz < -0.999})
    name = path.rsplit("/", 1)[-1]
    print(f"{name}: {hi[0]-lo[0]:.1f} x {hi[1]-lo[1]:.1f} on the bed, {hi[2]-lo[2]:.1f} tall; "
          f"{len(down)} overhanging facets, {sum(a for _, a, _ in down):.0f} mm2")
    for c in sorted(clusters, key=lambda c: -c["area"]):
        kind = "flat (bridge or ceiling)" if c["flat"] else "sloped"
        print(f"   {c['area']:8.1f} mm2  {kind:24s} x {c['lo'][0]:.1f}..{c['hi'][0]:.1f}  "
              f"y {c['lo'][1]:.1f}..{c['hi'][1]:.1f}  z {c['lo'][2]:.1f}..{c['hi'][2]:.1f}")
