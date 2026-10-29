import SwiftData
import Testing

@testable import RecipeGenerator

@MainActor
@Suite("Recipe mapping and persistence")
struct RecipeMappingTests {

    @Test("maps a generated recipe, keeping ingredient order")
    func mapsGeneratedRecipe() {
        let recipe = Recipe(generated: .sample)

        #expect(recipe.title == "Garlic Chicken and Rice")
        #expect(recipe.servings == 2)
        #expect(
            recipe.sortedIngredients.map(\.name) == ["Chicken breast", "White rice (dry)", "Broccoli", "Olive oil"]
        )
        #expect(recipe.steps.count == 4)
    }

    @Test("reference values replace the model's for foods in the table, and only for those")
    func referenceValuesReplaceRecall() throws {
        // Macros agree with the energy, so the sanity rules leave the model's values alone.
        func ingredient(
            _ name: String,
            energy: Double,
            protein: Double,
            carbs: Double,
            fat: Double
        ) -> GeneratedIngredient {
            GeneratedIngredient(
                name: name,
                grams: 100,
                energyPer100g: energy,
                proteinPer100g: protein,
                carbsPer100g: carbs,
                fiberPer100g: 0,
                sugarPer100g: 0,
                fatPer100g: fat,
                saturatedFatPer100g: 0
            )
        }
        let generated = GeneratedRecipe(
            title: "Test",
            summary: "",
            ingredients: [
                ingredient("Garlic", energy: 14, protein: 0.5, carbs: 2.5, fat: 0.1),
                ingredient("Cooked rice", energy: 130, protein: 2.7, carbs: 28, fat: 0.3),
                ingredient("Chicken broth", energy: 5, protein: 1, carbs: 0.2, fat: 0.1),
            ],
            steps: ["Cook."]
        )

        let recipe = Recipe(generated: generated)
        let energies = recipe.sortedIngredients.map(\.per100g.energy)

        #expect(energies == [149, 130, 5])
    }

    @Test("drops blank ingredients and steps, trims text, and clamps negatives")
    func sanitizesGeneratedValues() {
        let generated = GeneratedRecipe(
            title: "  Soup  ",
            summary: "",
            ingredients: [
                GeneratedIngredient(
                    name: "  Dragonfruit ",
                    grams: -10,
                    energyPer100g: -1,
                    proteinPer100g: 1,
                    carbsPer100g: 1,
                    fiberPer100g: 1,
                    sugarPer100g: 1,
                    fatPer100g: 1,
                    saturatedFatPer100g: 1
                ),
                GeneratedIngredient(
                    name: "   ",
                    grams: 50,
                    energyPer100g: 10,
                    proteinPer100g: 1,
                    carbsPer100g: 1,
                    fiberPer100g: 1,
                    sugarPer100g: 1,
                    fatPer100g: 1,
                    saturatedFatPer100g: 1
                ),
            ],
            steps: ["Boil.", "  ", "Serve."]
        )

        let recipe = Recipe(generated: generated)

        #expect(recipe.title == "Soup")
        #expect(recipe.servings == 1)
        #expect(recipe.sortedIngredients.count == 1)
        #expect(recipe.sortedIngredients[0].name == "Dragonfruit")
        #expect(recipe.sortedIngredients[0].grams == 0)
        #expect(recipe.sortedIngredients[0].energyPer100g == 0)
        #expect(recipe.steps == ["Boil.", "Serve."])
    }

    @Test("derives the serving count from the total weight of the ingredients")
    func servingsComeFromWeight() {
        // 300 + 120 + 200 + 15 = 635 g, about 1.6 servings of 400 g.
        #expect(Recipe(generated: .sample).servings == 2)
    }

    @Test("derives per-serving nutrition from ingredients")
    func nutritionIsDerived() {
        let recipe = Recipe(generated: .sample)

        // 300 g chicken, 120 g rice, 200 g broccoli, 15 g oil, over 2 servings, with FoodReference values.
        let expectedEnergy = (300 * 1.20 + 120 * 3.65 + 200 * 0.34 + 15 * 8.84) / 2
        #expect(abs(recipe.nutritionPerServing.energy - expectedEnergy) < 0.001)
        #expect(recipe.servingMass == 317.5)
    }

    @Test("changing servings rescales per-serving nutrition and serving size")
    func servingsRescaleNutrition() {
        let recipe = Recipe(generated: .sample)
        let atTwo = recipe.nutritionPerServing
        let massAtTwo = recipe.servingMass

        recipe.servings = 4

        #expect(abs(recipe.nutritionPerServing.energy - atTwo.energy / 2) < 0.0001)
        #expect(abs(recipe.nutritionPerServing.protein - atTwo.protein / 2) < 0.0001)
        #expect(abs(recipe.servingMass - massAtTwo / 2) < 0.0001)
    }

    @Test("changing an ingredient's grams recalculates nutrition and serving size")
    func editingGramsRecalculates() throws {
        let recipe = Recipe(generated: .sample)
        let before = recipe.nutritionPerServing.energy
        let chicken = try #require(recipe.sortedIngredients.first { $0.name == "Chicken breast" })

        chicken.grams += 100  // +100 g at 120 kcal per 100 g, over 2 servings

        #expect(abs(recipe.nutritionPerServing.energy - (before + 120 / 2)) < 0.0001)
        #expect(recipe.servingMass == (735.0 / 2))
    }

    @Test("saves and fetches through an in-memory store")
    func persistsRoundTrip() throws {
        let container = try ModelContainerFactory.make(inMemory: true)
        let context = container.mainContext

        context.insert(Recipe(generated: .sample))
        try context.save()

        let fetched = try context.fetch(FetchDescriptor<Recipe>())
        #expect(fetched.count == 1)
        #expect(fetched[0].ingredients?.count == 4)
        #expect(try context.fetch(FetchDescriptor<Ingredient>()).count == 4)
    }

    @Test("deleting a recipe deletes its ingredients")
    func deleteCascades() throws {
        let container = try ModelContainerFactory.make(inMemory: true)
        let context = container.mainContext
        let recipe = Recipe(generated: .sample)
        context.insert(recipe)
        try context.save()

        context.delete(recipe)
        try context.save()

        #expect(try context.fetch(FetchDescriptor<Ingredient>()).isEmpty)
    }
}
