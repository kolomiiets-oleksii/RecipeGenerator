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

    func generate(
        from ingredients: String,
        dietary: Set<DietaryOption>,
        onProgress: (RecipeProgress) -> Void
    ) async throws -> GeneratedRecipe {
        if case .success(let recipe) = result, delay > .zero {
            // Reveal the recipe in stages so previews and screenshots show the streaming screen.
            let stage = delay / 3
            onProgress(RecipeProgress(title: recipe.title))
            try await Task.sleep(for: stage)
            onProgress(RecipeProgress(title: recipe.title, ingredientNames: recipe.ingredients.map(\.name)))
            try await Task.sleep(for: stage)
            onProgress(
                RecipeProgress(
                    title: recipe.title,
                    ingredientNames: recipe.ingredients.map(\.name),
                    stepCount: recipe.steps.count
                )
            )
            try await Task.sleep(for: stage)
            return recipe
        }
        if delay > .zero {
            try await Task.sleep(for: delay)
        }
        return try result.get()
    }
}
