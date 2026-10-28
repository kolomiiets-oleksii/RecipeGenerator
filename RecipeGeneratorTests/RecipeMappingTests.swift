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

    @Test("drops blank ingredients and steps, trims text, and clamps negatives")
    func sanitizesGeneratedValues() {
        let generated = GeneratedRecipe(
            title: "  Soup  ",
            summary: "",
            ingredients: [
                GeneratedIngredient(
                    name: "  Carrot ",
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
        #expect(recipe.sortedIngredients[0].name == "Carrot")
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

        // 300 g chicken, 120 g rice, 200 g broccoli, 15 g oil, over 2 servings.
        let expectedEnergy = (300 * 1.65 + 120 * 3.60 + 200 * 0.34 + 15 * 8.84) / 2
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

        chicken.grams += 100  // +100 g at 165 kcal per 100 g, over 2 servings

        #expect(abs(recipe.nutritionPerServing.energy - (before + 165 / 2)) < 0.0001)
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
