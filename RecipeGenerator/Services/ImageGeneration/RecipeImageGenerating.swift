import Foundation

/// Creates an illustration for a recipe.
protocol RecipeImageGenerating {
    /// Whether image creation can run on this device right now.
    var isAvailable: Bool { get }

    /// Returns encoded image data (JPEG) for the given description.
    func imageData(for description: String) async throws -> Data
}
