#!/usr/bin/env python3
import glob, re, sys
MEAT = ["chicken","beef","pork","fish","bacon","ham","turkey","lamb","shrimp","salmon","tuna","sausage"]
ANIMAL = MEAT + ["egg","cheese","milk","butter","cream","honey","yogurt","yoghurt","parmesan","mozzarella"]
prefix, rule = sys.argv[1], sys.argv[2]
words = MEAT if rule == "veg" else ANIMAL
bad_runs = 0; n = 0
for p in sorted(glob.glob(prefix + "-*.log")):
    names = [m.group(1).lower() for l in open(p, errors="ignore") for m in [re.search(r"ingredient (.+?) \|", l)] if m]
    if not names: print(p.split("/")[-1], "NO OUTPUT"); continue
    n += 1
    hits = [x for x in names if any(w in x for w in words)]
    bad_runs += bool(hits)
    print(p.split("/")[-1], "->", ", ".join(names), "|| violates:", ", ".join(hits) or "none")
print(f"{prefix}: runs={n} violating={bad_runs}")
