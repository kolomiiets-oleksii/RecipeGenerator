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
            return response.content
        } catch let error as LanguageModelSession.GenerationError {
            throw IntelligenceError(generationError: error)
        }
    }
}
