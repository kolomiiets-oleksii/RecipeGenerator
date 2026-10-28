import Testing

@testable import RecipeGenerator

@MainActor
@Suite("NutritionCalculator")
struct NutritionCalculatorTests {

    private let chicken = NutritionCalculator.Item(
        grams: 200,
        per100g: NutritionFacts(energy: 165, protein: 31, carbs: 0, fiber: 0, sugar: 0, fat: 3.6, saturatedFat: 1)
    )
    private let rice = NutritionCalculator.Item(
        grams: 100,
        per100g: NutritionFacts(energy: 360, protein: 7, carbs: 79, fiber: 1.3, sugar: 0, fat: 0.6, saturatedFat: 0.2)
    )

    @Test("scales per-100g values by mass and sums them")
    func totalSumsScaledItems() {
        let total = NutritionCalculator.total(of: [chicken, rice])

        #expect(total.energy == 165 * 2 + 360)
        #expect(total.protein == 31 * 2 + 7)
        #expect(total.carbs == 79)
    }

    @Test("divides totals by servings")
    func perServingDividesByServings() {
        let perServing = NutritionCalculator.perServing(of: [chicken, rice], servings: 2)

        #expect(perServing.energy == (165 * 2 + 360) / 2)
    }

    @Test("treats zero or negative servings as one")
    func invalidServingsClampToOne() {
        let one = NutritionCalculator.perServing(of: [chicken], servings: 1)

        #expect(NutritionCalculator.perServing(of: [chicken], servings: 0) == one)
        #expect(NutritionCalculator.perServing(of: [chicken], servings: -3) == one)
    }

    @Test("ignores negative masses")
    func negativeMassIsIgnored() {
        let bad = NutritionCalculator.Item(grams: -50, per100g: chicken.per100g)

        #expect(NutritionCalculator.total(of: [bad]) == .zero)
        #expect(NutritionCalculator.totalMass(of: [bad]) == 0)
    }

    @Test("empty recipe has no nutrition and no mass")
    func emptyRecipe() {
        #expect(NutritionCalculator.total(of: []) == .zero)
        #expect(NutritionCalculator.servingMass(of: [], servings: 2) == 0)
    }

    @Test("serving mass is total mass over servings")
    func servingMass() {
        #expect(NutritionCalculator.servingMass(of: [chicken, rice], servings: 3) == 100)
    }

    @Test("suggests about one serving per 400 g")
    func suggestedServingsFromMass() {
        #expect(NutritionCalculator.suggestedServings(totalMass: 400) == 1)
        #expect(NutritionCalculator.suggestedServings(totalMass: 635) == 2)
        #expect(NutritionCalculator.suggestedServings(totalMass: 965) == 2)
        #expect(NutritionCalculator.suggestedServings(totalMass: 1_200) == 3)
        #expect(NutritionCalculator.suggestedServings(totalMass: 1_800) == 5)
    }

    @Test("suggested servings stay between 1 and 12")
    func suggestedServingsClamped() {
        #expect(NutritionCalculator.suggestedServings(totalMass: 0) == 1)
        #expect(NutritionCalculator.suggestedServings(totalMass: -50) == 1)
        #expect(NutritionCalculator.suggestedServings(totalMass: 100) == 1)
        #expect(NutritionCalculator.suggestedServings(totalMass: 3_075) == 8)
        #expect(NutritionCalculator.suggestedServings(totalMass: 50_000) == 12)
    }
}
