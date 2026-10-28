import SwiftUI

extension EnvironmentValues {
    /// Produces recipes from ingredient lists. Override in tests and previews.
    @Entry var recipeGenerator: any RecipeGenerating = FoundationModelsRecipeGenerator()

    /// Produces recipe illustrations. Override in tests and previews.
    @Entry var recipeImageGenerator: any RecipeImageGenerating = ImagePlaygroundRecipeImageGenerator()
}
