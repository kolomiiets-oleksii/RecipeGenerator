import SwiftUI

/// Shows a freshly generated recipe with actions to save or discard it.
struct GeneratedRecipeReview: View {
    let recipe: Recipe
    let onSave: () -> Void
    let onDiscard: () -> Void

    var body: some View {
        RecipeContentView(recipe: recipe)
            .safeAreaInset(edge: .bottom) {
                HStack(spacing: Design.Spacing.medium) {
                    Button("Start Over", role: .destructive, action: onDiscard)
                        .buttonStyle(.bordered)

                    Button("Save to Recipe Book", systemImage: "book.closed", action: onSave)
                        .buttonStyle(.borderedProminent)
                }
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
