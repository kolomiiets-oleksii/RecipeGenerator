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

    @Test("no dietary options adds no dietary line")
    func noDietaryLine() {
        #expect(!RecipePrompts.prompt(ingredients: "eggs").contains("The recipe must be"))
    }

    @Test("each dietary option is described to the model")
    func dietaryOptionsAppear() {
        let vegetarian = RecipePrompts.prompt(ingredients: "eggs", dietary: [.vegetarian])
        let both = RecipePrompts.prompt(ingredients: "eggs", dietary: [.glutenFree, .nutFree])

        #expect(vegetarian.contains("The recipe must be vegetarian (no meat or fish)"))
        #expect(both.contains("gluten-free"))
        #expect(both.contains("nut-free"))
        #expect(both.contains("Leave out any given ingredient that does not fit"))
    }

    @Test("dietary options always come out in the same order")
    func dietaryOrderIsStable() {
        let first = RecipePrompts.prompt(ingredients: "x", dietary: [.nutFree, .vegan, .glutenFree])
        let second = RecipePrompts.prompt(ingredients: "x", dietary: [.glutenFree, .vegan, .nutFree])

        #expect(first == second)
    }
}
