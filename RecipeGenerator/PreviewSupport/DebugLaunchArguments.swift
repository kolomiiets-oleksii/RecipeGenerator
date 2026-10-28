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
    /// | `-seedServings 4` | Sets the seeded recipe's serving count |
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
        static var seedServings: Int? { value(after: "-seedServings").flatMap(Int.init) }

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
}
