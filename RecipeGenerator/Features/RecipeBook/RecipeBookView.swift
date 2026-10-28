import SwiftData
import SwiftUI

/// The app's root: a recipe list on the left and the selected recipe on the right.
///
/// `NavigationSplitView` shows both columns side by side on iPad and collapses
/// to a push stack on iPhone.
struct RecipeBookView: View {
    @Query(sort: \Recipe.createdAt, order: .reverse) private var recipes: [Recipe]

    @State private var selection: Recipe.ID?
    @State private var searchText = ""
    @State private var isGeneratorPresented = false

    @Environment(\.modelContext) private var modelContext
    @Environment(\.recipeGenerator) private var recipeGenerator

    var body: some View {
        let visibleRecipes =
            searchText.isEmpty ? recipes : recipes.filter { $0.title.localizedStandardContains(searchText) }

        NavigationSplitView {
            RecipeListView(
                recipes: visibleRecipes,
                isSearching: !searchText.isEmpty,
                selection: $selection,
                onDelete: delete,
                onNewRecipe: { isGeneratorPresented = true }
            )
            .navigationTitle("Recipe Book")
            .searchable(text: $searchText, prompt: "Search recipes")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("New Recipe", systemImage: "sparkles") {
                        isGeneratorPresented = true
                    }
                }
            }
        } detail: {
            if let recipe = recipes.first(where: { $0.id == selection }) {
                RecipeDetailView(recipe: recipe, onDelete: { delete(recipe) })
                    .id(recipe.id)
            } else {
                ContentUnavailableView(
                    "Select a Recipe",
                    systemImage: "fork.knife",
                    description: Text("Choose a recipe from the list, or create a new one.")
                )
            }
        }
        .sheet(isPresented: $isGeneratorPresented) {
            GeneratorView(generator: recipeGenerator, onSave: save)
        }
        #if DEBUG
            .task {
                if DebugLaunchArguments.selectFirstRecipe { selection = recipes.first?.id }
                if DebugLaunchArguments.presentGenerator { isGeneratorPresented = true }
            }
        #endif
    }

    private func save(_ recipe: Recipe) {
        modelContext.insert(recipe)
        selection = recipe.id
    }

    private func delete(_ recipe: Recipe) {
        if selection == recipe.id {
            selection = nil
        }
        modelContext.delete(recipe)
    }
}

#Preview {
    RecipeBookView()
        .modelContainer(.preview)
}
