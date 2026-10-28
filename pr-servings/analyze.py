#!/usr/bin/env python3
"""Summarise real-model runs: dry-vs-cooked energy for starches and pantry items missing from the ingredient list."""
import glob, re, sys

# (word in ingredient name, kcal/100g range that means "uncooked/dry")
DRY_EXPECT = {"rice": (330, 380), "pasta": (330, 380), "spaghetti": (330, 380), "quinoa": (330, 390), "oats": (350, 400)}
PANTRY = ["oil", "butter", "salt", "pepper", "sugar", "soy sauce", "vinegar", "lemon", "paprika", "cumin", "oregano", "basil"]

prefix = sys.argv[1]
rows = []
for path in sorted(glob.glob(f"{prefix}-*.log")):
    ings, steps, title, servings = [], [], "", 0
    for line in open(path, errors="ignore"):
        if "[GEN] ingredient" in line:
            m = re.search(r"ingredient (.+?) \| ([\d.]+) g \| ([\d.]+) kcal/100g", line)
            if m:
                ings.append((m.group(1).strip().lower(), float(m.group(2)), float(m.group(3))))
        elif "[GEN] step" in line:
            steps.append(line.split("[GEN] step", 1)[1].strip().lower())
        elif "[GEN] " in line and "servings" in line:
            m = re.search(r"\[GEN\] (.+) \| servings (\d+)", line)
            if m:
                title, servings = m.group(1), int(m.group(2))
    if not servings and ings:
        servings = min(max(round(sum(g for _, g, _ in ings) / 400), 1), 12)  # the app's rule
    if not ings:
        rows.append((path.split("/")[-1], "NO OUTPUT"))
        continue
    dry_flags = []
    for name, grams, kcal in ings:
        for word, (lo, hi) in DRY_EXPECT.items():
            if word in name and "cooked" not in name:
                dry_flags.append(f"{name}: {kcal:.0f} kcal/100g {'DRY ok' if lo <= kcal <= hi else 'COOKED-LIKE' if kcal < lo else 'high'}")
    text = " ".join(steps)
    names = " ".join(n for n, _, _ in ings)
    missing = [w for w in PANTRY if w in text and w not in names]
    total = sum(g * k / 100 for _, g, k in ings)
    mass = sum(g for _, g, _ in ings) / max(servings, 1)
    plausible = 250 <= mass <= 600 and 300 <= total / max(servings, 1) <= 900
    rows.append((path.split("/")[-1], f"{title} | {servings} servings | {mass:.0f} g/serving | {total / max(servings, 1):.0f} kcal/serving"
                 f" {'PLAUSIBLE' if plausible else 'IMPLAUSIBLE'} | "
                 f"{'; '.join(dry_flags) or 'no starch'} | missing from list: {', '.join(missing) or 'none'}"))

for name, summary in rows:
    print(f"{name}: {summary}")
ok = sum(1 for _, s in rows if "COOKED-LIKE" not in s and "NO OUTPUT" not in s)
miss = sum(1 for _, s in rows if "missing from list: none" not in s and "NO OUTPUT" not in s)
plaus = sum(1 for _, s in rows if " PLAUSIBLE" in s)
print(f"runs={len(rows)} plausible-meal={plaus} runs-with-missing-pantry={miss}")
