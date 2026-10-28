import Testing

@testable import RecipeGenerator

@MainActor
@Suite("RecipePrompts")
struct RecipePromptsTests {

    @Test("prompt includes the ingredients the person typed")
    func promptIncludesIngredients() {
        let prompt = RecipePrompts.prompt(ingredients: "eggs, spinach")

        #expect(prompt.contains("eggs, spinach"))
    }

    @Test("every used ingredient must be listed, pantry items included")
    func pantryItemsMustBeListed() {
        #expect(RecipePrompts.instructions.contains("must appear in the ingredient list"))
        #expect(RecipePrompts.prompt(ingredients: "x").contains("list every one you use"))
    }
}
