import Foundation
import Observation

/// Drives the "New Recipe" flow: collects ingredients, runs generation, and
/// holds the unsaved result until the person saves or discards it.
@Observable
final class GeneratorViewModel {
    var ingredientsText = ""
    private(set) var state: GeneratorState = .idle

    private let generator: any RecipeGenerating
    private var generationTask: Task<Void, Never>?

    /// Identifies the run allowed to write `state`. A cancelled or superseded run
    /// that finishes late sees a different ID and discards its result.
    private var currentRunID: UUID?

    init(generator: any RecipeGenerating) {
        self.generator = generator
    }

    var unavailabilityMessage: String? {
        generator.unavailabilityMessage
    }

    var canGenerate: Bool {
        unavailabilityMessage == nil
            && !trimmedIngredients.isEmpty
            && !state.isGenerating
    }

    private var trimmedIngredients: String {
        ingredientsText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Starts generation in a task the view model owns, so it can be cancelled.
    func start() {
        guard canGenerate else { return }
        generationTask?.cancel()
        let runID = beginRun()
        generationTask = Task { await perform(runID) }
    }

    /// Runs generation to completion. Prefer `start()` from views.
    func generate() async {
        guard canGenerate else { return }
        await perform(beginRun())
    }

    /// Stops any running generation and returns to the input screen.
    func cancel() {
        generationTask?.cancel()
        generationTask = nil
        currentRunID = nil
        if state.isGenerating {
            state = .idle
        }
    }

    /// Goes back to the input screen, keeping the ingredient text.
    func reset() {
        cancel()
        state = .idle
    }

    private func beginRun() -> UUID {
        let runID = UUID()
        currentRunID = runID
        state = .generating
        return runID
    }

    private func perform(_ runID: UUID) async {
        do {
            let generated = try await generator.generate(from: trimmedIngredients)
            guard currentRunID == runID else { return }
            state = .generated(Recipe(generated: generated))
        } catch {
            guard currentRunID == runID else { return }
            state = error is CancellationError ? .idle : .error(error.localizedDescription)
        }
    }
}
