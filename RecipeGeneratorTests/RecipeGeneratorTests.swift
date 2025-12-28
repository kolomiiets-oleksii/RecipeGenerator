//
//  RecipeGeneratorTests.swift
//  RecipeGeneratorTests
//
//  Created by Oleksii Kolomiiets on 9/15/25.
//

import Testing
@testable import RecipeGenerator

// MARK: - Generating State Tests

@MainActor
@Suite("GeneratingState Tests")
struct GeneratingStateTests {

    // MARK: - State Properties

    @Test("isGenerating returns true only for generating state")
    func isGeneratingProperty() {
        #expect(GeneratingState.generating.isGenerating == true)
        #expect(GeneratingState.idle.isGenerating == false)
        #expect(GeneratingState.error("Error").isGenerating == false)
        #expect(GeneratingState.generated(Recipe.sample).isGenerating == false)
    }

    @Test("isIdle returns true only for idle state")
    func isIdleProperty() {
        #expect(GeneratingState.idle.isIdle == true)
        #expect(GeneratingState.generating.isIdle == false)
        #expect(GeneratingState.error("Error").isIdle == false)
        #expect(GeneratingState.generated(Recipe.sample).isIdle == false)
    }

    // MARK: - Action Text

    @Test("actionText returns correct text for each state")
    func actionTextProperty() {
        #expect(GeneratingState.idle.actionText == "Generate Recipe")
        #expect(GeneratingState.generating.actionText == "Generating...")
        #expect(GeneratingState.error("Error").actionText == "Try Again")
        #expect(GeneratingState.generated(Recipe.sample).actionText == "New Recipe")
    }

    // MARK: - Icon Symbol

    @Test("iconSymbol returns correct SF Symbol for each state")
    func iconSymbolProperty() {
        #expect(GeneratingState.idle.iconSymbol == "sparkles")
        #expect(GeneratingState.generating.iconSymbol == "sparkles")
        #expect(GeneratingState.error("Error").iconSymbol == "exclamationmark.octagon")
        #expect(GeneratingState.generated(Recipe.sample).iconSymbol == "arrow.2.circlepath.circle")
    }

    // MARK: - Equatable

    @Test("same states are equal")
    func equalStates() {
        #expect(GeneratingState.idle == GeneratingState.idle)
        #expect(GeneratingState.generating == GeneratingState.generating)
        #expect(GeneratingState.error("Error") == GeneratingState.error("Error"))
        #expect(GeneratingState.generated(Recipe.sample) == GeneratingState.generated(Recipe.sample))
    }

    @Test("different states are not equal")
    func differentStates() {
        #expect(GeneratingState.idle != GeneratingState.generating)
        #expect(GeneratingState.error("Error 1") != GeneratingState.error("Error 2"))
    }
}

// MARK: - Recipe Tests

@Suite("Recipe Tests")
struct RecipeTests {

    @Test("Recipe model equality works correctly")
    func recipeEquality() {
        let recipe1 = Recipe.sample
        let recipe2 = Recipe.sample
        #expect(recipe1 == recipe2)
    }

    @Test("Recipes with different titles are not equal")
    func recipeDifferentTitles() {
        let recipe1 = Recipe.sample
        let recipe2 = Recipe(
            title: "Different Recipe",
            energy: recipe1.energy,
            protein: recipe1.protein,
            carbs: recipe1.carbs,
            fiber: recipe1.fiber,
            sugar: recipe1.sugar,
            fatTotal: recipe1.fatTotal,
            fatSaturated: recipe1.fatSaturated,
            servingSize: recipe1.servingSize,
            ingredients: recipe1.ingredients,
            steps: recipe1.steps
        )
        #expect(recipe1 != recipe2)
    }

    @Test("Recipe handles nil ingredients gracefully")
    func recipeNilIngredients() {
        let recipe = Recipe(
            title: "Test Recipe",
            energy: 100,
            protein: 10,
            carbs: 20,
            fiber: 5,
            sugar: 3,
            fatTotal: 5,
            fatSaturated: 2,
            servingSize: 200,
            ingredients: nil,
            steps: nil
        )
        #expect(recipe.ingredients == nil)
        #expect(recipe.steps == nil)
    }
}

// MARK: - Test Helpers

extension Recipe {
    /// A sample recipe for testing purposes.
    static let sample = Recipe(
        title: "Test Recipe",
        energy: 320.5,
        protein: 28.3,
        carbs: 12.7,
        fiber: 4.2,
        sugar: 8.1,
        fatTotal: 18.6,
        fatSaturated: 3.4,
        servingSize: 250.0,
        ingredients: "Chicken, Lettuce, Tomato",
        steps: "Cook chicken. Add vegetables. Serve."
    )
}
