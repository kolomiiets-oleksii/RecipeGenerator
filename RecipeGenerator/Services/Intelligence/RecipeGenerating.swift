/// Turns a list of ingredients into a generated recipe.
///
/// Views and view models depend on this protocol, not on FoundationModels, so
/// tests and previews can substitute a stub.
protocol RecipeGenerating {
    /// A message explaining why generation can't run right now, or `nil` if it can.
    var unavailabilityMessage: String? { get }

    func generate(from ingredients: String) async throws -> GeneratedRecipe
}
