import Foundation
import Testing

@testable import RecipeGenerator

@MainActor
@Suite("RecipeImageViewModel")
struct RecipeImageViewModelTests {

    private struct SampleError: LocalizedError {
        var errorDescription: String? { "No image" }
    }

    @Test("stores generated image data on the recipe")
    func storesImage() async {
        let recipe = Recipe.sample
        let data = Data([1, 2, 3])
        let generator = StubRecipeImageGenerator(result: .success(data))
        let viewModel = RecipeImageViewModel()

        await viewModel.createImage(for: recipe, using: generator)

        #expect(recipe.imageData == data)
        #expect(viewModel.errorMessage == nil)
        #expect(!viewModel.isGenerating)
    }

    @Test("reports a failure and leaves the recipe untouched")
    func reportsFailure() async {
        let recipe = Recipe.sample
        let generator = StubRecipeImageGenerator(result: .failure(SampleError()))
        let viewModel = RecipeImageViewModel()

        await viewModel.createImage(for: recipe, using: generator)

        #expect(recipe.imageData == nil)
        #expect(viewModel.errorMessage == "No image")
        #expect(!viewModel.isGenerating)
    }

    @Test("image description names the dish and its main ingredients")
    func imageDescription() {
        let description = Recipe.sample.imageDescription

        #expect(description.contains("Garlic Chicken and Rice"))
        #expect(description.contains("Chicken breast"))
    }
}
