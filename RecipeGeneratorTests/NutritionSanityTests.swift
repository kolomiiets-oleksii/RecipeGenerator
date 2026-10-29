import Testing

@testable import RecipeGenerator

@MainActor
@Suite("NutritionFacts sanity rules")
struct NutritionSanityTests {

    @Test("keeps realistic values unchanged")
    func realisticValuesUnchanged() {
        let chicken = NutritionFacts(
            energy: 165,
            protein: 31,
            carbs: 0,
            fiber: 0,
            sugar: 0,
            fat: 3.6,
            saturatedFat: 1
        )
        let rice = NutritionFacts(
            energy: 360,
            protein: 7,
            carbs: 79,
            fiber: 1.3,
            sugar: 0,
            fat: 0.6,
            saturatedFat: 0.2
        )
        let oil = NutritionFacts(energy: 884, protein: 0, carbs: 0, fiber: 0, sugar: 0, fat: 100, saturatedFat: 14)

        #expect(chicken.sanitizedPer100g == chicken)
        #expect(rice.sanitizedPer100g == rice)
        #expect(oil.sanitizedPer100g == oil)
    }

    @Test("removes negative values")
    func negativesBecomeZero() {
        let facts = NutritionFacts(energy: -5, protein: -1, carbs: -2, fiber: -3, sugar: -4, fat: -5, saturatedFat: -6)

        #expect(facts.sanitizedPer100g == .zero)
    }

    @Test("scales protein, carbs and fat down when they exceed 100 g together")
    func macroMassCappedAtHundred() {
        let facts = NutritionFacts(energy: 600, protein: 60, carbs: 60, fiber: 0, sugar: 0, fat: 80, saturatedFat: 0)

        let result = facts.sanitizedPer100g

        #expect(abs(result.protein + result.carbs + result.fat - 100) < 0.0001)
        // Proportions are preserved.
        #expect(abs(result.protein / result.fat - 60.0 / 80.0) < 0.0001)
    }

    @Test("fiber and sugar cannot exceed carbs; saturated fat cannot exceed fat")
    func subtotalsCappedByParents() {
        let facts = NutritionFacts(energy: 200, protein: 0, carbs: 10, fiber: 30, sugar: 25, fat: 5, saturatedFat: 9)

        let result = facts.sanitizedPer100g

        #expect(result.fiber == 10)
        #expect(result.sugar == 10)
        #expect(result.saturatedFat == 5)
    }

    @Test("energy cannot exceed 900 kcal per 100 g")
    func energyCapped() {
        let facts = NutritionFacts(energy: 5000, protein: 0, carbs: 0, fiber: 0, sugar: 0, fat: 100, saturatedFat: 0)

        #expect(facts.sanitizedPer100g.energy == 900)
    }

    @Test("replaces energy that contradicts the macros")
    func inconsistentEnergyUsesMacros() {
        // 20 g protein, 5 g carbs, 10 g fat adds up to about 190 kcal, not 600.
        let facts = NutritionFacts(energy: 600, protein: 20, carbs: 5, fiber: 0, sugar: 0, fat: 10, saturatedFat: 0)

        #expect(facts.sanitizedPer100g.energy == 190)
    }

    @Test("keeps energy that is close to the macros")
    func closeEnergyIsKept() {
        let facts = NutritionFacts(energy: 210, protein: 20, carbs: 5, fiber: 0, sugar: 0, fat: 10, saturatedFat: 0)

        #expect(facts.sanitizedPer100g.energy == 210)
    }

    @Test("does not second-guess tiny values such as spices")
    func smallDifferencesAreIgnored() {
        let facts = NutritionFacts(energy: 20, protein: 0.5, carbs: 3, fiber: 0, sugar: 0, fat: 0.1, saturatedFat: 0)

        #expect(facts.sanitizedPer100g.energy == 20)
    }

    @Test("mapping a generated ingredient applies the rules")
    func mappingAppliesRules() {
        let generated = GeneratedIngredient(
            name: "Test grain",
            grams: 250,
            energyPer100g: 600,
            proteinPer100g: 7,
            carbsPer100g: 79,
            fiberPer100g: 90,
            sugarPer100g: 0,
            fatPer100g: 0.6,
            saturatedFatPer100g: 0.2
        )

        let ingredient = Ingredient(generated: generated, order: 0)

        #expect(ingredient.fiberPer100g == 79)
        #expect(ingredient.energyPer100g == ingredient.per100g.energyFromMacros)
    }
}
