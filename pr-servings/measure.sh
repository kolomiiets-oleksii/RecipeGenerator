#!/bin/bash
# usage: measure.sh <label> <runs> "<ingredients>"   (iPad sim, real model, console log)
S=/private/tmp/claude-501/-Users-oleksiikolomiiets-Developer-Applications-RecipeGenerator/e70f9908-dd99-4c44-99a7-ffef1ebb2491/scratchpad
U=6A41C331-8EBD-47C1-9C85-0D986D370A53; B=io.snappmobile.RecipeGenerator
label=$1; runs=$2; ing=$3
for i in $(seq 1 $runs); do
  f=$S/measure/$label-$i.log; : > $f
  xcrun simctl terminate $U $B >/dev/null 2>&1
  xcrun simctl launch --console $U $B -presentGenerator -autoGenerate "$ing" > $f 2>&1 &
  pid=$!
  for t in $(seq 1 60); do sleep 2; grep -q "\[GEN\] step" $f && sleep 2 && break; done
  xcrun simctl terminate $U $B >/dev/null 2>&1; kill $pid >/dev/null 2>&1
done
echo finished $label
