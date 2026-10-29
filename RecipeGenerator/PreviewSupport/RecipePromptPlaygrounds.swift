#if DEBUG
    import FoundationModels
    import Playgrounds

    /// Runs the real recipe prompt against fixed ingredient lists, so a prompt change can be compared before and after.
    /// In Xcode 26, open this file and run a playground from the gutter or the Playground editor.
    /// See `docs/prompting.md` for what has been tried.
    private let fixedIngredientLists = [
        "chicken, rice, broccoli, garlic",
        "eggs, spinach, feta, tomatoes",
        "pasta, tomatoes, basil, parmesan",
        "salmon, potatoes, lemon, dill",
        "lentils, carrots, onion, cumin",
    ]

    #Playground("Recipe prompt: first list") {
        let session = LanguageModelSession(instructions: RecipePrompts.instructions)
        let recipe = try await session.respond(
            to: RecipePrompts.prompt(ingredients: fixedIngredientLists[0]),
            generating: GeneratedRecipe.self
        ).content
        _ = recipe
    }

    #Playground("Recipe prompt: all fixed lists") {
        for ingredients in fixedIngredientLists {
            let session = LanguageModelSession(instructions: RecipePrompts.instructions)
            let recipe = try await session.respond(
                to: RecipePrompts.prompt(ingredients: ingredients),
                generating: GeneratedRecipe.self
            ).content
            _ = recipe
        }
    }

    #Playground("Recipe prompt: vegan") {
        let session = LanguageModelSession(instructions: RecipePrompts.instructions)
        let recipe = try await session.respond(
            to: RecipePrompts.prompt(ingredients: fixedIngredientLists[1], dietary: [.vegan]),
            generating: GeneratedRecipe.self
        ).content
        _ = recipe
    }
#endif
