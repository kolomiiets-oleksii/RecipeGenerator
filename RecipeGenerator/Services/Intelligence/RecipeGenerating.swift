/// Turns a list of ingredients into a generated recipe.
///
/// Views and view models depend on this protocol, not on FoundationModels, so
/// tests and previews can substitute a stub.
protocol RecipeGenerating {
    /// A message explaining why generation can't run right now, or `nil` if it can.
    var unavailabilityMessage: String? { get }

    /// A note about a limitation that doesn't block generation, such as an unsupported language, or `nil`.
    var languageNotice: String? { get }

    /// Writes the recipe. `onProgress` is called as the model produces text, so the screen can show it.
    func generate(
        from ingredients: String,
        dietary: Set<DietaryOption>,
        onProgress: (RecipeProgress) -> Void
    ) async throws -> GeneratedRecipe
}

extension RecipeGenerating {
    var languageNotice: String? { nil }
}

extension RecipeGenerating {
    func generate(from ingredients: String, dietary: Set<DietaryOption>) async throws -> GeneratedRecipe {
        try await generate(from: ingredients, dietary: dietary, onProgress: { _ in })
    }
}
