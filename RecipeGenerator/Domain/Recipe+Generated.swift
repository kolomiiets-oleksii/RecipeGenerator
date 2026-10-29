import Foundation

extension Ingredient {
    /// Maps one model-generated ingredient. Values for foods in `FoodReference` are replaced by the reference
    /// values, because the model recalls them inconsistently (cooked values for dry rice, 14 kcal for garlic).
    /// For any other food the model's values are kept, with those that cannot be true fixed.
    convenience init(generated: GeneratedIngredient, order: Int) {
        let reported = NutritionFacts(
            energy: generated.energyPer100g,
            protein: generated.proteinPer100g,
            carbs: generated.carbsPer100g,
            fiber: generated.fiberPer100g,
            sugar: generated.sugarPer100g,
            fat: generated.fatPer100g,
            saturatedFat: generated.saturatedFatPer100g
        )
        let name = generated.name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.init(
            name: name,
            grams: max(generated.grams, 0),
            order: order,
            per100g: FoodReference.facts(forIngredient: name) ?? reported.sanitizedPer100g
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
            servings: NutritionCalculator.suggestedServings(totalMass: ingredients.reduce(0) { $0 + $1.grams }),
            steps: steps,
            ingredients: ingredients
        )
    }
}
