import SwiftUI

/// Shows a freshly generated recipe with actions to save or discard it.
struct GeneratedRecipeReview: View {
    let recipe: Recipe
    let onSave: () -> Void
    let onDiscard: () -> Void

    var body: some View {
        RecipeContentView(recipe: recipe)
            .safeAreaInset(edge: .bottom) {
                // Icon-only: long translations ("Зберегти в книгу рецептів") wrapped to two lines in a text bar.
                // The labels stay as the accessibility names.
                HStack(spacing: Design.Spacing.large) {
                    Button("Start Over", systemImage: "arrow.counterclockwise", role: .destructive, action: onDiscard)
                        .buttonStyle(.bordered)

                    Button("Save to Recipe Book", systemImage: "checkmark", action: onSave)
                        .buttonStyle(.borderedProminent)
                }
                .labelStyle(.iconOnly)
                .buttonBorderShape(.circle)
                .controlSize(.large)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.bar)
            }
    }
}

#Preview {
    GeneratedRecipeReview(recipe: .sample, onSave: {}, onDiscard: {})
}
