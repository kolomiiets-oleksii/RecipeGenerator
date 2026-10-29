import FoundationModels

/// What the model has written so far, for showing progress while a recipe streams in.
struct RecipeProgress: Equatable {
    var title: String?
    var ingredientNames: [String] = []
    var stepCount = 0

    static let empty = RecipeProgress()
}

extension RecipeProgress {
    init(_ partial: GeneratedRecipe.PartiallyGenerated) {
        title = partial.title
        ingredientNames = (partial.ingredients ?? []).compactMap(\.name).filter { !$0.isEmpty }
        stepCount = partial.steps?.count ?? 0
    }
}
