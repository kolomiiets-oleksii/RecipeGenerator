import SwiftUI

/// The scrollable body of a recipe, shared by the saved-recipe detail and the
/// review step in the generator.
struct RecipeContentView: View {
    @Bindable var recipe: Recipe

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Design.Spacing.large) {
                RecipeImageHeader(recipe: recipe)

                VStack(alignment: .leading, spacing: Design.Spacing.small) {
                    Text(recipe.title)
                        .font(.largeTitle.bold())
                        .accessibilityAddTraits(.isHeader)

                    if !recipe.summary.isEmpty {
                        Text(recipe.summary)
                            .foregroundStyle(.secondary)
                    }

                    ServingsStepper(servings: $recipe.servings, servingMass: recipe.servingMass)
                }

                IngredientsSection(ingredients: recipe.sortedIngredients)
                StepsSection(steps: recipe.steps)
                NutritionSection(nutrition: recipe.nutritionPerServing)
            }
            .padding()
            .frame(maxWidth: Design.readableWidth)
            .frame(maxWidth: .infinity)
        }
        .applyingDebugScroll()
    }
}

#Preview {
    RecipeContentView(recipe: .sample)
}
