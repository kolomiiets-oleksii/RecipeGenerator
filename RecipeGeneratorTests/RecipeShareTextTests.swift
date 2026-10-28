import Foundation
import Testing

@testable import RecipeGenerator

@MainActor
@Suite("Recipe share text")
struct RecipeShareTextTests {

    private let text = Recipe(generated: .sample).shareText

    @Test("starts with the title and summary")
    func titleAndSummary() {
        let lines = text.split(separator: "\n", omittingEmptySubsequences: false)

        #expect(lines[0] == "Garlic Chicken and Rice")
        #expect(lines[1] == "A quick one-pan dinner with tender chicken, fluffy rice and broccoli.")
    }

    @Test("lists every ingredient with its grams, in order")
    func ingredients() {
        let chicken = text.range(of: "- Chicken breast: 300 g")
        let rice = text.range(of: "- White rice (dry): 120 g")
        let oil = text.range(of: "- Olive oil: 15 g")

        #expect(chicken != nil)
        #expect(rice != nil)
        #expect(oil != nil)
        if let chicken, let rice, let oil {
            #expect(chicken.lowerBound < rice.lowerBound)
            #expect(rice.lowerBound < oil.lowerBound)
        }
    }

    @Test("numbers the steps from 1")
    func steps() {
        #expect(text.contains("1. Cook the rice in salted water for 12 minutes, then drain."))
        #expect(text.contains("4. Stir in the rice and serve hot."))
    }

    @Test("ends with per-serving nutrition")
    func nutrition() {
        #expect(text.contains("Energy: 564 kcal"))
        #expect(text.contains("Protein: 53.5 g"))
        #expect(text.hasSuffix("Saturated Fat: 2.8 g"))
    }

    @Test("handles a recipe without steps or summary")
    func minimalRecipe() {
        let recipe = Recipe(title: "Water")

        #expect(recipe.shareText.hasPrefix("Water\n\n"))
        #expect(!recipe.shareText.contains("Instructions"))
    }
}
