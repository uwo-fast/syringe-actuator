# SPDX-License-Identifier: GPL-3.0-or-later
"""Count the edges of an ASCII STL that do not join exactly two facets.

Two solids that meet only along an edge export with that edge shared by four facets, which slicers
then repair however they like. OpenSCAD 2021.01 warns about that case too; this counts it without
relying on OpenSCAD's wording. Every printed part must report zero. Standard library only, so CI
needs nothing installed.

usage: python3 tools/stl_edges.py part.stl [...]   exit 0 when every file is clean
"""

import collections
import sys


def bad_edges(path):
    facets, verts = [], []
    with open(path) as f:
        for line in f:
            w = line.split()
            if w[:1] == ["vertex"]:
                verts.append(tuple(round(float(v), 4) for v in w[1:4]))
                if len(verts) == 3:
                    facets.append(verts)
                    verts = []
    count = collections.Counter()
    for a, b, c in facets:
        for e in ((a, b), (b, c), (c, a)):
            count[tuple(sorted(e))] += 1
    return len(facets), sum(1 for n in count.values() if n != 2)


def main():
    failed = False
    for path in sys.argv[1:]:
        n, bad = bad_edges(path)
        if n == 0 or bad:
            failed = True
            print(f"FAIL  {path}  {'no facets' if n == 0 else f'{bad} edge(s) not joining exactly two facets'}")
        else:
            print(f"ok    {path}  {n} facets, every edge joins two")
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
