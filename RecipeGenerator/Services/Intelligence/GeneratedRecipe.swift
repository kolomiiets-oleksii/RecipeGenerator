import FoundationModels

/// A recipe as returned by the language model, before it becomes a saved `Recipe`.
@Generable
struct GeneratedRecipe: Equatable {
    @Guide(description: "A short, descriptive recipe title without numbers or serving counts.")
    let title: String

    @Guide(description: "One appetizing sentence describing the dish.")
    let summary: String

    @Guide(description: "Number of servings the whole recipe makes.", .range(1...12))
    let servings: Int

    @Guide(description: "Every ingredient in the recipe, each with its mass in grams.", .minimumCount(1))
    let ingredients: [GeneratedIngredient]

    @Guide(
        description:
            "Cooking instructions, one short sentence per step, in order, without step numbers. Include the time each step takes.",
        .minimumCount(1)
    )
    let steps: [String]
}
