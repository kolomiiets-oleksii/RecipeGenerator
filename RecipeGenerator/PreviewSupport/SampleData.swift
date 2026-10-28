import Foundation

extension GeneratedRecipe {
    static let sample = GeneratedRecipe(
        title: "Garlic Chicken and Rice",
        summary: "A quick one-pan dinner with tender chicken, fluffy rice and broccoli.",
        servings: 2,
        ingredients: [
            GeneratedIngredient(
                name: "Chicken breast",
                grams: 300,
                energyPer100g: 165,
                proteinPer100g: 31,
                carbsPer100g: 0,
                fiberPer100g: 0,
                sugarPer100g: 0,
                fatPer100g: 3.6,
                saturatedFatPer100g: 1
            ),
            GeneratedIngredient(
                name: "White rice (dry)",
                grams: 120,
                energyPer100g: 360,
                proteinPer100g: 7,
                carbsPer100g: 79,
                fiberPer100g: 1.3,
                sugarPer100g: 0,
                fatPer100g: 0.6,
                saturatedFatPer100g: 0.2
            ),
            GeneratedIngredient(
                name: "Broccoli",
                grams: 200,
                energyPer100g: 34,
                proteinPer100g: 2.8,
                carbsPer100g: 7,
                fiberPer100g: 2.6,
                sugarPer100g: 1.7,
                fatPer100g: 0.4,
                saturatedFatPer100g: 0.1
            ),
            GeneratedIngredient(
                name: "Olive oil",
                grams: 15,
                energyPer100g: 884,
                proteinPer100g: 0,
                carbsPer100g: 0,
                fiberPer100g: 0,
                sugarPer100g: 0,
                fatPer100g: 100,
                saturatedFatPer100g: 14
            ),
        ],
        steps: [
            "Cook the rice in salted water for 12 minutes, then drain.",
            "Sear the sliced chicken in olive oil for 6 minutes until golden.",
            "Add garlic and broccoli and cook for 5 minutes.",
            "Stir in the rice and serve hot.",
        ]
    )
}

extension Recipe {
    /// A fresh, unsaved sample recipe.
    static var sample: Recipe {
        Recipe(generated: .sample)
    }
}
