import SwiftUI

/// The sidebar: every saved recipe, selectable, with swipe-to-delete.
struct RecipeListView: View {
    let recipes: [Recipe]
    let isSearching: Bool
    @Binding var selection: Recipe.ID?
    let onDelete: (Recipe) -> Void
    let onNewRecipe: () -> Void

    var body: some View {
        List(selection: $selection) {
            ForEach(recipes) { recipe in
                RecipeRow(recipe: recipe)
                    .swipeActions(edge: .trailing) {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            onDelete(recipe)
                        }
                    }
            }
        }
        .overlay {
            if recipes.isEmpty {
                if isSearching {
                    ContentUnavailableView.search
                } else {
                    ContentUnavailableView {
                        Label("No Recipes Yet", systemImage: "book.closed")
                    } description: {
                        Text("Generate your first recipe from the ingredients you have.")
                    } actions: {
                        Button("New Recipe", systemImage: "sparkles", action: onNewRecipe)
                            .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selection: Recipe.ID?
    NavigationStack {
        RecipeListView(
            recipes: [.sample],
            isSearching: false,
            selection: $selection,
            onDelete: { _ in },
            onNewRecipe: {}
        )
    }
}
