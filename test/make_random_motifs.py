#!/usr/bin/env python

"""
Generate a simple 5000bp genome with base modifications at GTAC and CTAG sites,
for quick testing of motif finding.
"""

import random
import sys

from pbcore.io import FastaWriter, Gff3Record, GffWriter

def run(argv):
    nuc = []
    basemods = []
    while len(nuc) < 5000:
        x = random.random()
        if x > 0.99 and len(nuc) < 4880:
            n = len(nuc) + 3
            basemods.append(Gff3Record("genome", n, n, "modified_base", 100, "+", ".", "kinModCall", [("coverage", "100"), ("IPDRatio", "4.0"), ("identificationQv", "50")]))
            nuc.extend(["G", "T", "A", "C"])
        elif x < 0.01 and len(nuc) < 4880:
            n = len(nuc) + 3
            basemods.append(Gff3Record("genome", n, n, "modified_base", 100, "+", ".", "kinModCall", [("coverage", "100"), ("IPDRatio", "4.0"), ("identificationQv", "50")]))
            nuc.extend(["C", "T", "A", "G"])
        else:
            b = "ACGT"[random.randint(0, 3)]
            if ((b == "C" and nuc[-3:] == ["G", "T", "A"]) or
                (b == "G" and nuc[-3:] == ["C", "T", "A"])):
                nuc.append("T")
            else:
                nuc.append(b)
    seq = "".join(nuc)
    with FastaWriter("genome.fasta") as fa_out:
        fa_out.writeRecord("genome", "".join(nuc))
    with GffWriter("basemods.gff") as gff_out:
        for rec in basemods:
            ctx_start = max(0, rec.start - 21)
            ctx_end = min(len(seq), rec.end + 20)
            context = seq[ctx_start:ctx_end]
            rec.attributes["context"] = context
            gff_out.writeRecord(rec)
    return 0

if __name__ == "__main__":
    sys.exit(run(sys.argv[1:]))
