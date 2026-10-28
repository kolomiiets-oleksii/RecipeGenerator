import Foundation

/// A canned `RecipeGenerating` for tests and previews.
struct StubRecipeGenerator: RecipeGenerating {
    var result: Result<GeneratedRecipe, any Error>
    var delay: Duration = .zero
    var unavailabilityMessage: String?

    init(
        result: Result<GeneratedRecipe, any Error>,
        delay: Duration = .zero,
        unavailabilityMessage: String? = nil
    ) {
        self.result = result
        self.delay = delay
        self.unavailabilityMessage = unavailabilityMessage
    }

    func generate(from ingredients: String) async throws -> GeneratedRecipe {
        if delay > .zero {
            try await Task.sleep(for: delay)
        }
        return try result.get()
    }
}
