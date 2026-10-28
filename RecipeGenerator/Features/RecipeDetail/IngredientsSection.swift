import SwiftUI

struct IngredientsSection: View {
    let ingredients: [Ingredient]

    var body: some View {
        GroupBox("Ingredients") {
            VStack(spacing: Design.Spacing.small) {
                ForEach(ingredients) { ingredient in
                    IngredientRow(ingredient: ingredient)

                    if ingredient != ingredients.last {
                        Divider()
                    }
                }
            }
        }
    }
}

#Preview {
    IngredientsSection(ingredients: Recipe.sample.sortedIngredients)
        .padding()
}
