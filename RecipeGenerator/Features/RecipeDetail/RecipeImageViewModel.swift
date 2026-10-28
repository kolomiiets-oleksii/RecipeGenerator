import Foundation
import Observation

/// Creates an illustration for a recipe and stores it on the recipe.
@Observable
final class RecipeImageViewModel {
    private(set) var isGenerating = false
    private(set) var errorMessage: String?

    func createImage(for recipe: Recipe, using generator: any RecipeImageGenerating) async {
        guard !isGenerating else { return }
        isGenerating = true
        errorMessage = nil
        defer { isGenerating = false }

        do {
            recipe.imageData = try await generator.imageData(for: recipe.imageDescription)
        } catch is CancellationError {
            // The person left the screen; nothing to report.
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
