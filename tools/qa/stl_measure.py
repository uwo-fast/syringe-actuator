# SPDX-License-Identifier: GPL-3.0-or-later
"""The volume and extent of an STL, ASCII or binary: "volume size_x size_y size_z x_min x_max", or
"empty". A collision whose volume is under a thousandth of a mm3 is two faces touching.

usage: python3 tools/qa/stl_measure.py part.stl
"""

import re
import struct
import sys

b = open(sys.argv[1], "rb").read()
if b[:5] == b"solid" and b"facet" in b[:1000]:
    v = [tuple(map(float, m)) for m in re.findall(rb"vertex\s+(\S+)\s+(\S+)\s+(\S+)", b)]
else:
    n = struct.unpack("<I", b[80:84])[0]
    v = [struct.unpack_from("<3f", b, 84 + 50 * i + 12 + 12 * k) for i in range(n) for k in range(3)]
if not v:
    print("empty")
    sys.exit()
vol = 0.0
for i in range(0, len(v) - 2, 3):
    (ax, ay, az), (bx, by, bz), (cx, cy, cz) = v[i : i + 3]
    vol += ax * (by * cz - bz * cy) - ay * (bx * cz - bz * cx) + az * (bx * cy - by * cx)
lo = [min(p[k] for p in v) for k in range(3)]
hi = [max(p[k] for p in v) for k in range(3)]
print("%.6f %.3f %.3f %.3f %.3f %.3f" % (abs(vol) / 6, *(hi[k] - lo[k] for k in range(3)), lo[0], hi[0]))
