import SwiftUI

/// The "New Recipe" sheet: enter ingredients, generate, review, save.
struct GeneratorView: View {
    let onSave: (Recipe) -> Void

    @State private var viewModel: GeneratorViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(generator: any RecipeGenerating, onSave: @escaping (Recipe) -> Void) {
        _viewModel = State(initialValue: GeneratorViewModel(generator: generator))
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle:
                    IngredientInputView(
                        text: $viewModel.ingredientsText,
                        dietaryOptions: viewModel.dietaryOptions,
                        onToggleDietaryOption: viewModel.toggle,
                        unavailabilityMessage: viewModel.unavailabilityMessage,
                        languageNotice: viewModel.languageNotice,
                        canGenerate: viewModel.canGenerate,
                        onGenerate: viewModel.start
                    )

                case .generating:
                    GeneratingProgressView(progress: viewModel.progress, onCancel: viewModel.cancel)

                case .generated(let recipe):
                    GeneratedRecipeReview(
                        recipe: recipe,
                        onSave: { save(recipe) },
                        onDiscard: viewModel.reset
                    )

                case .error(let message):
                    ContentUnavailableView {
                        Label("Something Went Wrong", systemImage: "exclamationmark.triangle.fill")
                    } description: {
                        Text(message)
                    } actions: {
                        Button("Try Again", action: viewModel.start)
                            .buttonStyle(.borderedProminent)
                        Button("Edit Ingredients", action: viewModel.reset)
                    }
                }
            }
            .navigationTitle("New Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel, action: cancel)
                }
            }
        }
        .animation(reduceMotion ? nil : .smooth, value: viewModel.state)
        .interactiveDismissDisabled(viewModel.state.isGenerating)
        .presentationSizing(.page)
        .onDisappear(perform: viewModel.cancel)
        #if DEBUG
            .task {
                viewModel.setDietaryOptions(DebugLaunchArguments.dietary)
                guard let ingredients = DebugLaunchArguments.autoGenerate else { return }
                viewModel.ingredientsText = ingredients
                viewModel.start()
            }
        #endif
    }

    private func cancel() {
        viewModel.cancel()
        dismiss()
    }

    private func save(_ recipe: Recipe) {
        onSave(recipe)
        dismiss()
    }
}

#Preview {
    GeneratorView(generator: StubRecipeGenerator(result: .success(.sample)), onSave: { _ in })
}
