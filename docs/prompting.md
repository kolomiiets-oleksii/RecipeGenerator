# Prompting notes

What was tried against the real on-device model, and what it changed. The prompt itself lives in
`RecipeGenerator/Services/Intelligence/RecipePrompts.swift`; this file records the evidence behind it.

How the numbers were produced: a Debug build runs the real `SystemLanguageModel` in the iOS Simulator and logs each
result (`[GEN]` lines on stderr). Small samples, one machine, one or two ingredient lists, so treat the differences as
indicative, not as benchmarks. To repeat a comparison interactively, open
`RecipeGenerator/PreviewSupport/RecipePromptPlaygrounds.swift` in Xcode 26 and run a `#Playground`.
Choose an iPhone **simulator** as the run destination (a device older than the iPhone 15 Pro has no Apple Intelligence),
and when Xcode asks, trust the `#Playground` macro. Until it is trusted, the build fails with only
"Failed to build the scheme".

## What the model gets wrong

| Problem | Seen as |
| --- | --- |
| Uses oil, salt, spices in the steps without listing them | Nutrition misses them |
| Ignores serving-size instructions | Far too many servings, so each serving looked like 200 g |
| Cooked-food values for raw ingredients | Chicken 165 kcal, rice 130 kcal per 100 g; garlic 14; olive oil up to 998 |
| Values vary between runs for the same ingredient | Rice 111–130 kcal per 100 g |

## Changes and results

| Change | Before | After | Kept? |
| --- | --- | --- | --- |
| Pantry rule (every ingredient used in the steps must be listed) plus servings derived from total grams (about 400 g each) instead of asked for. Measured together, 6 runs each | 0 of 6 plausible meals, 4 of 6 used an unlisted pantry item | 6 of 6 plausible, 0 of 6 unlisted (plausible: 250-600 g and 300-900 kcal per serving) | Yes |
| The same two changes, replayed offline on 18 logged runs | 5 of 18 plausible | 17 of 18 plausible | Yes |
| Tell the model to give raw "dry weight" | | Rice came back at 1200 g dry, worse | No |
| Ask for a serving size in the prompt | | Ignored by the model | No (the app derives it) |
| Dietary options as a prompt line ("must be vegetarian...") | Without it: 2 of 2 runs broke the rule (vegetarian), 2 of 2 (vegan) | With it: 0 of 2, 0 of 2 | Yes |
| Ask for the recipe in Ukrainian | | Garbled words and grammar ("брокілі", "жир" for oil) | No; the UI is localized, recipes stay English |
| Temperature 0.3 or greedy sampling instead of the default | Rice spread 19 kcal/100 g | 14 and 0; the other ingredients were already identical | No; greedy makes every recipe identical |
| `lookupNutrition` Tool for per-100 g values | About 50 s per recipe | 14–32 tool calls per recipe, 7 of 7 runs unfinished after 2–5 min | No |
| Replace the model's values with a raw-food table in code | Same run: about 473 kcal per serving | 637 kcal per serving, matching the table | Yes |
| Prewarm the session while the person types (needs streaming to see it) | First output at a median of 7.7 s | Median 3.3 s; whole recipe about 2 s faster | Yes |

## Rules of thumb

- Don't ask the model for what the app can compute or look up: totals, servings and common nutrition values are done
  in code (`NutritionCalculator`, `FoodReference`).
- Keep instructions short and concrete; every sentence costs context in a 4096-token window.
- Measure with the same ingredient list several times. One good run proves nothing.

## Profile (Instruments, Foundation Models template)

One generation in the iPhone simulator (iOS 27.1) for "chicken, rice, broccoli, garlic", recorded with the Foundation
Models instrument in Deferred mode:

| | |
| --- | --- |
| Requests | 1 (one session) |
| Request and Model Inference duration | 74.17 s |
| Tokens | 1825 (as counted by the instrument) |
| Throughput | about 24.6 tokens per second (1825 / 74.17) |

Read off the timeline: Model Loading events appear at the start of the request, so this was a cold run. Model Inference
shows two stretches, about 16 s followed by about 59 s. The app's own log for warm runs puts the first snapshot at about
3 to 9 s and the whole recipe at 37 to 50 s, so this run is slower than usual. A cold model and profiler overhead are
the likely reasons, though I did not isolate either.

Caveats: one run, simulator, a profiler attached, and the first-token time is not shown as a number by the instrument
in this view, so the app's log (`[GEN] first ... total ...`) remains the source for first-output times. The instrument
labels the instructions and prompt "No instructions" and "No prompt", so it does not record their text by default.

