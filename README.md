# RecipeGenerator

![Platform](https://img.shields.io/badge/Platform-iOS%2026%20%7C%20iPadOS%2026-blue.svg)
![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-purple.svg)
![On-device](https://img.shields.io/badge/AI-on--device-green.svg)

A small recipe book where Apple's on-device model does the creative work. List what's in your kitchen, and
Foundation Models writes a recipe with every ingredient in grams. The app, not the model, adds up the nutrition.
Everything runs on the device: no server, no account, no network.

<p align="center">
  <img src="https://raw.githubusercontent.com/kolomiiets-oleksii/RecipeGenerator/a59b8f68de386d3e90e559946766e434f305f641/readme/demo-uk.gif" width="300" alt="Generating a recipe, saving it, and reading its nutrition, in Ukrainian">
</p>

[Full-quality video](https://raw.githubusercontent.com/kolomiiets-oleksii/RecipeGenerator/a59b8f68de386d3e90e559946766e434f305f641/readme/demo-uk.mp4)
(Ukrainian UI, iPhone simulator, stubbed generator).

## What it does

- **Generate** a recipe from a list of ingredients, optionally vegetarian, vegan, gluten-free or nut-free.
- **Nutrition from grams**: the model returns each ingredient's mass and its per-100 g values; the app computes the
  totals, the per-serving numbers and the macro chart. Edit a gram value or the servings and everything updates.
- **Recipe book** with search, share as plain text, and delete. Saved with SwiftData on the device.
- **Illustrations** with Image Playground (on-device), when the device supports it.
- **iPhone and iPad**: a `NavigationSplitView` that collapses to a stack on iPhone.
- **Ukrainian and English** interface.

## Requirements

- iOS / iPadOS 26 and Xcode 26
- A device with Apple Intelligence turned on (the model is `SystemLanguageModel.default`)
- Image Playground illustrations need a device that supports it. They are unavailable in the Simulator.

The Simulator on an Apple-silicon Mac with Apple Intelligence runs the real on-device model, so you can develop
without a phone. Image creation will report that it isn't available.

## Getting started

1. Open `RecipeGenerator.xcodeproj` in Xcode.
2. Xcode asks you to trust the `SwiftFormatLintPlugin` build tool plugin (it lints the sources while building).
   Choose *Trust & Enable*. From the command line, pass `-skipPackagePluginValidation` to `xcodebuild`.
3. Run on an iPhone or iPad (Cmd+R). Run the tests with Cmd+U.

## Languages

The interface is localized in Ukrainian (first) and English through a string catalog,
`RecipeGenerator/Localizable.xcstrings`, including plural forms for servings.

Apple's on-device model doesn't support Ukrainian (`SystemLanguageModel.default.supportsLocale(_:)` returns
`false`). I tried telling it to answer in Ukrainian and the output was garbled ("брокілі", "брусок" for broccoli,
"жир" for oil, ungrammatical steps), so the app doesn't do that. It accepts Ukrainian ingredient names and
returns the recipe in English. When the device language isn't supported, the generator shows a note saying so
instead of blocking generation.

## How it uses Foundation Models

- `@Generable` types (`GeneratedRecipe`, `GeneratedIngredient`) with `@Guide` constraints give typed output.
- The prompt asks for ingredient masses in grams and per-100 g nutrition, and requires every ingredient used in the
  steps, including oil and salt, to appear in the list. The model ignored instructions about serving size,
  so servings are derived from the total weight (about 400 g each).
- Model numbers are not trusted: values are clamped, macro mass is capped at 100 g per 100 g, fiber and sugar are
  capped by carbs, and energy that disagrees with the macros is recomputed.
- Measured on the real model, 6 runs per variant: the original prompt produced a plausible single meal 0 of 6 times
  and added unlisted pantry items in 4 of 6; the current prompt 6 of 6 and 0 of 6. Small samples, but the
  difference is large. The logs are attached to the pull requests.

## Architecture

```
RecipeGenerator/
├── App/             App entry point, model container, service wiring
├── Domain/          SwiftData models (Recipe, Ingredient), nutrition math, dietary options
├── Persistence/     ModelContainer setup (local store; models stay CloudKit-compatible)
├── Services/
│   ├── Intelligence/     RecipeGenerating protocol, Foundation Models implementation, prompts, stub
│   └── ImageGeneration/  RecipeImageGenerating protocol, Image Playground implementation, stub
├── Features/
│   ├── RecipeBook/      Split view, list, search
│   ├── RecipeDetail/    Ingredients, steps, servings, nutrition and macro chart
│   └── Generator/       Input, progress, review; the generator view model
├── Shared/          Design tokens, formatting, reusable views
└── PreviewSupport/  Sample data and Debug-only launch arguments
```

Views depend on protocols (`RecipeGenerating`, `RecipeImageGenerating`) passed through the SwiftUI environment, so
tests and previews use stubs and never touch the model. The nutrition logic is plain Swift with unit tests
(Swift Testing).

## Debug launch arguments

Debug builds accept launch arguments for reproducible screenshots and demos, for example
`-seedSampleData -selectFirstRecipe`, `-presentGenerator -stubGenerator success -autoGenerate "chicken, rice"`
and `-AppleLanguages "(uk)"`. See `PreviewSupport/DebugLaunchArguments.swift`. They compile to nothing in Release.

## Roadmap

Planned work is tracked as small issues in the repository.

## Inspiration

Based on "[Building AI features using Foundation Models](https://swiftwithmajid.com/2025/08/26/building-ai-features-using-foundation-models-structured-content/)" by Majid Jabrayilov.

## License

MIT
