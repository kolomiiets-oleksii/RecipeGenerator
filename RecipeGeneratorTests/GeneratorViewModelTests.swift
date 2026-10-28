import Foundation
import Testing

@testable import RecipeGenerator

@MainActor
@Suite("GeneratorViewModel")
struct GeneratorViewModelTests {

    private struct SampleError: LocalizedError {
        var errorDescription: String? { "Boom" }
    }

    @Test("cannot generate until ingredients are entered")
    func requiresIngredients() {
        let viewModel = GeneratorViewModel(generator: StubRecipeGenerator(result: .success(.sample)))
        #expect(!viewModel.canGenerate)

        viewModel.ingredientsText = "   "
        #expect(!viewModel.canGenerate)

        viewModel.ingredientsText = "eggs, spinach"
        #expect(viewModel.canGenerate)
    }

    @Test("cannot generate when the model is unavailable")
    func respectsUnavailability() {
        let generator = StubRecipeGenerator(result: .success(.sample), unavailabilityMessage: "Not supported")
        let viewModel = GeneratorViewModel(generator: generator)
        viewModel.ingredientsText = "eggs"

        #expect(!viewModel.canGenerate)
        #expect(viewModel.unavailabilityMessage == "Not supported")
    }

    @Test("a successful generation produces an unsaved recipe")
    func success() async {
        let viewModel = GeneratorViewModel(generator: StubRecipeGenerator(result: .success(.sample)))
        viewModel.ingredientsText = "chicken, rice"

        await viewModel.generate()

        guard case .generated(let recipe) = viewModel.state else {
            Issue.record("Expected .generated, got \(viewModel.state)")
            return
        }
        #expect(recipe.title == "Garlic Chicken and Rice")
    }

    @Test("a failure surfaces the error message")
    func failure() async {
        let viewModel = GeneratorViewModel(generator: StubRecipeGenerator(result: .failure(SampleError())))
        viewModel.ingredientsText = "chicken"

        await viewModel.generate()

        #expect(viewModel.state == .error("Boom"))
    }

    @Test("cancelling during generation returns to idle and discards the result")
    func cancelDiscardsResult() async throws {
        let generator = StubRecipeGenerator(result: .success(.sample), delay: .milliseconds(200))
        let viewModel = GeneratorViewModel(generator: generator)
        viewModel.ingredientsText = "chicken"

        viewModel.start()
        #expect(viewModel.state == .generating)

        viewModel.cancel()
        #expect(viewModel.state == .idle)

        try await Task.sleep(for: .milliseconds(400))
        #expect(viewModel.state == .idle)
    }

    @Test("reset keeps the ingredient text")
    func resetKeepsText() async {
        let viewModel = GeneratorViewModel(generator: StubRecipeGenerator(result: .failure(SampleError())))
        viewModel.ingredientsText = "chicken"
        await viewModel.generate()

        viewModel.reset()

        #expect(viewModel.state == .idle)
        #expect(viewModel.ingredientsText == "chicken")
    }
}
