import Foundation
import FoundationModels

/// Generates recipes with Apple's on-device language model.
///
/// - Note: Requires a device with Apple Intelligence enabled.
final class FoundationModelsRecipeGenerator: RecipeGenerating {

    /// A session warmed up before the person tapped Generate. Used once, then discarded, so one recipe never
    /// sees the previous one in its transcript.
    private var prewarmedSession: LanguageModelSession?

    var unavailabilityMessage: String? {
        guard case .unavailable(let reason) = SystemLanguageModel.default.availability else {
            return nil
        }
        return IntelligenceError.modelUnavailable(reason).errorDescription
    }

    /// Apple's model doesn't officially support every language. Where it doesn't (Ukrainian today), it still
    /// accepts the ingredients but writes the recipe in English, so we say so instead of blocking.
    var languageNotice: String? {
        guard !SystemLanguageModel.default.supportsLocale(.current) else { return nil }
        return String(
            localized: "Apple Intelligence doesn't support your language yet. Recipes are written in English."
        )
    }

    func prewarm() {
        guard prewarmedSession == nil, case .available = SystemLanguageModel.default.availability else { return }
        let session = LanguageModelSession(instructions: RecipePrompts.instructions)
        session.prewarm(promptPrefix: Prompt(RecipePrompts.promptLead))
        prewarmedSession = session
    }

    /// Sampling settings for recipes. Debug builds can override them to compare settings.
    private static var options: GenerationOptions {
        #if DEBUG
            if let override = DebugLaunchArguments.generationOptions { return override }
        #endif
        return GenerationOptions()
    }

    func generate(
        from ingredients: String,
        dietary: Set<DietaryOption>,
        onProgress: (RecipeProgress) -> Void
    ) async throws -> GeneratedRecipe {
        if case .unavailable(let reason) = SystemLanguageModel.default.availability {
            throw IntelligenceError.modelUnavailable(reason)
        }

        let session = prewarmedSession ?? LanguageModelSession(instructions: RecipePrompts.instructions)
        prewarmedSession = nil
        let prompt = RecipePrompts.prompt(ingredients: ingredients, dietary: dietary)

        #if DEBUG
            let start = ContinuousClock.now
            var firstSnapshot: Duration?
        #endif
        do {
            var latest: GeneratedContent?
            let stream = session.streamResponse(to: prompt, generating: GeneratedRecipe.self, options: Self.options)
            for try await snapshot in stream {
                #if DEBUG
                    firstSnapshot = firstSnapshot ?? ContinuousClock.now - start
                #endif
                onProgress(RecipeProgress(snapshot.content))
                latest = snapshot.rawContent
            }
            guard let latest else { throw IntelligenceError.generationFailed }
            let recipe = try GeneratedRecipe(latest)
            #if DEBUG
                Self.log(recipe, firstSnapshot: firstSnapshot, total: ContinuousClock.now - start)
            #endif
            return recipe
        } catch let error as LanguageModelSession.GenerationError {
            throw IntelligenceError(generationError: error)
        }
    }

    #if DEBUG
        /// Prints what the model returned so prompt changes can be compared run to run.
        private static func log(_ recipe: GeneratedRecipe, firstSnapshot: Duration?, total: Duration) {
            // stderr is unbuffered, so lines survive when the app is killed after generating.
            func emit(_ line: String) { fputs(line + "\n", stderr) }
            let seconds = Duration.UnitsFormatStyle.units(allowed: [.seconds], fractionalPart: .show(length: 2))
            emit("[GEN] first \((firstSnapshot ?? .zero).formatted(seconds)) total \(total.formatted(seconds))")
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
