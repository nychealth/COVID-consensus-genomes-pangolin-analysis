#!/usr/bin/env python

import os
import csv
import itertools

from pango_aliasor.aliasor import Aliasor

aliasor = Aliasor()

print("\t".join(["maple", "pangolin", "isAncestral", "distance"]))
with open('unique_mismatches_maple_vs_pangolin.tsv', 'r') as f:
    reader = csv.DictReader(f, delimiter="\t")
    for row in reader:
        mUnc = aliasor.uncompress(row["maple"])
        pUnc = aliasor.uncompress(row["pangolin"])
        if mUnc.startswith(pUnc) or pUnc.startswith(mUnc):
            isAnc = "1"
        else:
            isAnc = "0"
        mUncL = mUnc.split('.')
        pUncL = pUnc.split('.')
        distance = 0
        for pair in itertools.zip_longest(mUncL, pUncL, fillvalue=None):
            if pair[0] != pair[1]:
                distance += 1
                if pair[0] and pair[1]:
                    distance += 1
        if mUnc.startswith("X") or pUnc.startswith("X"):
            distS = "R"
        else:
            distS = str(distance)
        print("\t".join([row["maple"], row["pangolin"], isAnc, distS]))
