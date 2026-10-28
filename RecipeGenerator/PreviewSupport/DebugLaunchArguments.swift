import SwiftUI

#if DEBUG
    /// Launch arguments for screenshots, demos and PR proof. Everything here is compiled out of Release builds.
    ///
    /// | Argument | Effect |
    /// | --- | --- |
    /// | `-seedSampleData` | In-memory store with a sample recipe |
    /// | `-selectFirstRecipe` | Selects the first recipe (shows the detail screen) |
    /// | `-presentGenerator` | Opens the New Recipe sheet |
    /// | `-stubGenerator success\|slow\|failure` | Replaces the model with a stub |
    /// | `-autoGenerate "chicken, rice"` | Fills the ingredients and starts generating |
    /// | `-dietary vegan,glutenFree` | Pre-selects dietary options |
    /// | `-scrollToEnd` | Opens recipe screens scrolled to the bottom |
    /// | `-seedServings 4` | Sets the seeded recipe's serving count |
    /// | `-seedIngredient "Chicken breast=600"` | Sets one seeded ingredient's grams |
    enum DebugLaunchArguments {
        enum StubMode: String {
            case success
            case slow
            case failure
        }

        static var seedSampleData: Bool { arguments.contains("-seedSampleData") }
        static var selectFirstRecipe: Bool { arguments.contains("-selectFirstRecipe") }
        static var presentGenerator: Bool { arguments.contains("-presentGenerator") }
        static var autoGenerate: String? { value(after: "-autoGenerate") }
        /// `-dietary vegan,glutenFree` pre-selects dietary options.
        static var dietary: Set<DietaryOption> {
            guard let raw = value(after: "-dietary") else { return [] }
            return Set(raw.split(separator: ",").compactMap { DietaryOption(rawValue: String($0)) })
        }

        static var scrollToEnd: Bool { arguments.contains("-scrollToEnd") }
        static var seedServings: Int? { value(after: "-seedServings").flatMap(Int.init) }

        /// `-seedIngredient "Chicken breast=600"` changes one seeded ingredient's grams.
        static var seedIngredient: (name: String, grams: Double)? {
            guard let raw = value(after: "-seedIngredient") else { return nil }
            let parts = raw.split(separator: "=", maxSplits: 1).map(String.init)
            guard parts.count == 2, let grams = Double(parts[1]) else { return nil }
            return (parts[0], grams)
        }

        static var stubGenerator: (any RecipeGenerating)? {
            guard let raw = value(after: "-stubGenerator"), let mode = StubMode(rawValue: raw) else { return nil }
            switch mode {
            case .success:
                return StubRecipeGenerator(result: .success(.sample), delay: .seconds(2))
            case .slow:
                return StubRecipeGenerator(result: .success(.sample), delay: .seconds(600))
            case .failure:
                return StubRecipeGenerator(result: .failure(IntelligenceError.generationFailed), delay: .seconds(1))
            }
        }

        /// Applies the `-seed...` overrides to the seeded sample recipe.
        static func applySeedOverrides(to recipe: Recipe) {
            if let servings = seedServings {
                recipe.servings = servings
            }
            if let seed = seedIngredient, let ingredient = recipe.ingredients?.first(where: { $0.name == seed.name }) {
                ingredient.grams = seed.grams
            }
        }

        private static var arguments: [String] { CommandLine.arguments }

        private static func value(after flag: String) -> String? {
            guard let index = arguments.firstIndex(of: flag), arguments.indices.contains(index + 1) else { return nil }
            return arguments[index + 1]
        }
    }
#endif

extension View {
    /// Applies debug launch overrides in Debug builds. Does nothing in Release.
    @ViewBuilder
    func applyingDebugLaunchArguments() -> some View {
        #if DEBUG
            if let generator = DebugLaunchArguments.stubGenerator {
                environment(\.recipeGenerator, generator)
            } else {
                self
            }
        #else
            self
        #endif
    }

    /// Starts scrolled to the bottom when `-scrollToEnd` is given (Debug only), so lower sections can be photographed.
    @ViewBuilder
    func applyingDebugScroll() -> some View {
        #if DEBUG
            if DebugLaunchArguments.scrollToEnd {
                defaultScrollAnchor(.bottom)
            } else {
                self
            }
        #else
            self
        #endif
    }
}
