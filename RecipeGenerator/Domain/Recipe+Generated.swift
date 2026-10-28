import Foundation

extension Ingredient {
    /// Maps one model-generated ingredient, clamping nonsense values to zero.
    convenience init(generated: GeneratedIngredient, order: Int) {
        self.init(
            name: generated.name.trimmingCharacters(in: .whitespacesAndNewlines),
            grams: max(generated.grams, 0),
            order: order,
            per100g: NutritionFacts(
                energy: max(generated.energyPer100g, 0),
                protein: max(generated.proteinPer100g, 0),
                carbs: max(generated.carbsPer100g, 0),
                fiber: max(generated.fiberPer100g, 0),
                sugar: max(generated.sugarPer100g, 0),
                fat: max(generated.fatPer100g, 0),
                saturatedFat: max(generated.saturatedFatPer100g, 0)
            )
        )
    }
}

extension Recipe {
    /// Maps a model-generated recipe into a saveable one. Blank ingredients and
    /// steps are dropped and the serving count is kept at 1 or more.
    convenience init(generated: GeneratedRecipe) {
        let ingredients = generated.ingredients
            .filter { !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .enumerated()
            .map { Ingredient(generated: $1, order: $0) }

        let steps = generated.steps
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        self.init(
            title: generated.title.trimmingCharacters(in: .whitespacesAndNewlines),
            summary: generated.summary.trimmingCharacters(in: .whitespacesAndNewlines),
            servings: generated.servings,
            steps: steps,
            ingredients: ingredients
        )
    }
}
