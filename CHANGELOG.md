# Changelog

## [Unreleased]

### Added
- iPad support with a `NavigationSplitView` recipe book (collapses to a stack on iPhone)
- Saved recipe book using SwiftData (local store, models kept CloudKit-compatible)
- On-device recipe illustrations with Image Playground
- Nutrition now calculated by the app from ingredient masses and per-100 g values
- Search, delete, and a review step before saving a generated recipe
- Ukrainian and English interface (string catalog, plural-aware servings); a note when Apple Intelligence doesn't support the device language
- Dietary options, servings stepper, editable ingredient grams, macro chart and plain-text sharing

### Changed
- Recipe ingredients and steps are structured lists instead of comma/period-split text
- Code reorganized into App, Domain, Persistence, Services, Features and Shared layers; services sit behind protocols
- Reduce Motion respected; deprecated SwiftUI API replaced

## [1.0.0] - 2025-09-16

### Added
- AI-powered recipe generation using FoundationModels
- Nutritional information display
- Animated state transitions
- Error handling for unsupported devices
