import SwiftUI

/// One ingredient with an editable mass. Editing recalculates the recipe's nutrition.
struct IngredientRow: View {
    @Bindable var ingredient: Ingredient

    var body: some View {
        LabeledContent(ingredient.name) {
            HStack(spacing: Design.Spacing.small) {
                TextField(
                    "Grams",
                    value: $ingredient.grams,
                    format: .number.precision(.fractionLength(0...1))
                )
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(minWidth: 60, maxWidth: 100)
                .padding(.vertical, Design.Spacing.small / 2)
                .padding(.horizontal, Design.Spacing.small)
                .background(.fill.quaternary, in: .rect(cornerRadius: Design.cornerRadius / 2))
                .accessibilityLabel("Grams of \(ingredient.name)")

                Text("g")
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
            }
        }
        .onChange(of: ingredient.grams) {
            if ingredient.grams < 0 {
                ingredient.grams = 0
            }
        }
    }
}

#Preview {
    IngredientRow(ingredient: Recipe.sample.sortedIngredients[0])
        .padding()
}
