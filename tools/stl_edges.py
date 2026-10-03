# SPDX-License-Identifier: GPL-3.0-or-later
"""Check that an ASCII STL is one closed solid: every edge joins exactly two facets, and every facet
is connected to every other.

Two solids that meet only along an edge export with that edge shared by four facets, which slicers
then repair however they like; two that do not touch at all, or a solid with a sealed void inside,
export as more than one closed shell, as do two that touch at a single point. This counts both from
the mesh, so it reads the same whichever OpenSCAD wrote the file. Vertices within 0.0001 of each
other are welded first and the facets that collapse are dropped, as a slicer does: OpenSCAD's
Manifold backend keeps coordinates in single precision and writes near-duplicates of a vertex a few
billionths apart. Standard library only, so CI needs nothing installed.

usage: python3 tools/stl_edges.py part.stl [...]   exit 0 when every file is one closed shell
"""

import collections
import sys


def check(path):
    facets, verts = [], []
    with open(path) as f:
        for line in f:
            w = line.split()
            if w[:1] == ["vertex"]:
                verts.append(tuple(round(float(v), 4) + 0.0 for v in w[1:4]))
                if len(verts) == 3:
                    if len(set(verts)) == 3:
                        facets.append(verts)
                    verts = []
    edges = collections.defaultdict(list)
    for i, (a, b, c) in enumerate(facets):
        for e in ((a, b), (b, c), (c, a)):
            edges[tuple(sorted(e))].append(i)
    # facets joined through shared edges only, so solids touching at a point stay separate shells
    parent = list(range(len(facets)))

    def root(i):
        while parent[i] != i:
            parent[i] = parent[parent[i]]
            i = parent[i]
        return i

    for fs in edges.values():
        for i in fs[1:]:
            parent[root(i)] = root(fs[0])
    shells = len({root(i) for i in range(len(facets))})
    return len(facets), sum(1 for fs in edges.values() if len(fs) != 2), shells


def main():
    failed = False
    for path in sys.argv[1:]:
        n, bad, shells = check(path)
        if n == 0:
            problem = "no facets"
        elif bad:
            problem = f"{bad} edge(s) not joining exactly two facets"
        elif shells != 1:
            problem = f"{shells} closed shells (solids apart or touching, or a sealed void); a printed part is one"
        else:
            problem = None
        if problem:
            failed = True
            print(f"FAIL  {path}  {problem}")
        else:
            print(f"ok    {path}  {n} facets, one shell, every edge joins two")
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
