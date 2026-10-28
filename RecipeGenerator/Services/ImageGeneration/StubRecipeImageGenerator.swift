import Foundation

/// A canned `RecipeImageGenerating` for tests and previews.
struct StubRecipeImageGenerator: RecipeImageGenerating {
    var isAvailable = true
    var result: Result<Data, any Error> = .success(Data())

    func imageData(for description: String) async throws -> Data {
        try result.get()
    }
}
