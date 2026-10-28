import SwiftUI

/// A saved recipe in the detail column.
struct RecipeDetailView: View {
    let recipe: Recipe
    let onDelete: () -> Void

    @State private var isConfirmingDelete = false

    var body: some View {
        RecipeContentView(recipe: recipe)
            .navigationTitle(recipe.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button("Delete Recipe", systemImage: "trash", role: .destructive) {
                        isConfirmingDelete = true
                    }
                    .confirmationDialog(
                        "Delete this recipe?",
                        isPresented: $isConfirmingDelete,
                        titleVisibility: .visible
                    ) {
                        Button("Delete Recipe", role: .destructive, action: onDelete)
                    } message: {
                        Text("This can't be undone.")
                    }
                }
            }
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(recipe: .sample, onDelete: {})
    }
}
