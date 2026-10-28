import Foundation
import FoundationModels

/// Generates recipes with Apple's on-device language model.
///
/// - Note: Requires a device with Apple Intelligence enabled.
struct FoundationModelsRecipeGenerator: RecipeGenerating {

    var unavailabilityMessage: String? {
        guard case .unavailable(let reason) = SystemLanguageModel.default.availability else {
            return nil
        }
        return IntelligenceError.modelUnavailable(reason).errorDescription
    }

    func generate(from ingredients: String) async throws -> GeneratedRecipe {
        if case .unavailable(let reason) = SystemLanguageModel.default.availability {
            throw IntelligenceError.modelUnavailable(reason)
        }

        let session = LanguageModelSession(instructions: RecipePrompts.instructions)

        do {
            let response = try await session.respond(
                to: RecipePrompts.prompt(ingredients: ingredients),
                generating: GeneratedRecipe.self
            )
            #if DEBUG
                Self.log(response.content)
            #endif
            return response.content
        } catch let error as LanguageModelSession.GenerationError {
            throw IntelligenceError(generationError: error)
        }
    }

    #if DEBUG
        /// Prints what the model returned so prompt changes can be compared run to run.
        private static func log(_ recipe: GeneratedRecipe) {
            // stderr is unbuffered, so lines survive when the app is killed after generating.
            func emit(_ line: String) { fputs(line + "\n", stderr) }
            emit("[GEN] \(recipe.title)")
            for item in recipe.ingredients {
                emit(
                    "[GEN] ingredient \(item.name) | \(item.grams) g | \(item.energyPer100g) kcal/100g"
                        + " | P \(item.proteinPer100g) C \(item.carbsPer100g) F \(item.fatPer100g)"
                )
            }
            for step in recipe.steps {
                emit("[GEN] step \(step)")
            }
        }
    #endif
}
