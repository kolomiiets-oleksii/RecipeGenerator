import Testing

@testable import RecipeGenerator

@Suite("FoodReference")
struct FoodReferenceTests {

    @Test("finds common ingredients regardless of case, plurals and extra words")
    func findsIngredients() {
        #expect(FoodReference.find("Chicken Breasts")?.name == "chicken breast")
        #expect(FoodReference.find("white rice (dry)")?.name == "rice")
        #expect(FoodReference.find("Tomatoes")?.name == "tomato")
        #expect(FoodReference.find("eggs")?.name == "egg")
    }

    @Test("the longest matching name wins")
    func longestMatchWins() {
        #expect(FoodReference.find("extra virgin olive oil")?.name == "olive oil")
        #expect(FoodReference.find("red bell pepper")?.name == "bell pepper")
    }

    @Test("unknown or empty names are not found")
    func unknown() {
        #expect(FoodReference.find("dragonfruit") == nil)
        #expect(FoodReference.find("  ") == nil)
    }

    @Test("values are raw or dry, not cooked")
    func rawValues() throws {
        let rice = try #require(FoodReference.find("rice")).facts
        #expect(rice.energy > 300)
        let garlic = try #require(FoodReference.find("garlic")).facts
        #expect(garlic.energy > 100)
    }

    @Test("reference facts are used for raw foods and skipped for cooked or processed ones")
    func processedFoodsAreSkipped() {
        #expect(FoodReference.facts(forIngredient: "Chicken breast")?.energy == 120)
        #expect(FoodReference.facts(forIngredient: "white rice (dry)")?.energy == 365)
        #expect(FoodReference.facts(forIngredient: "cooked rice") == nil)
        #expect(FoodReference.facts(forIngredient: "chicken broth") == nil)
        #expect(FoodReference.facts(forIngredient: "dried oregano") == nil)
        #expect(FoodReference.facts(forIngredient: "dragonfruit") == nil)
    }

    @Test("every entry is plausible: macros fit in 100 g and energy roughly matches")
    func entriesAreConsistent() {
        for entry in FoodReference.entries {
            let facts = entry.facts
            #expect(facts.protein + facts.carbs + facts.fat <= 100.5, "\(entry.name) macros exceed 100 g")
            #expect(facts.fiber <= facts.carbs + 0.01, "\(entry.name) fiber exceeds carbs")
            #expect(facts.sugar <= facts.carbs + 0.01, "\(entry.name) sugar exceeds carbs")
            let fromMacros = facts.protein * 4 + facts.carbs * 4 + facts.fat * 9
            let tolerance = max(40, fromMacros * 0.2)
            let difference = abs(facts.energy - fromMacros)
            #expect(difference <= tolerance, "\(entry.name) energy \(facts.energy) vs \(fromMacros)")
        }
    }
}
