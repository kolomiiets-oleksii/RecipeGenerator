import SwiftUI

/// Per-serving nutrition, calculated from the ingredients.
struct NutritionSection: View {
    let nutrition: NutritionFacts

    var body: some View {
        GroupBox("Nutrition per Serving") {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 130), spacing: Design.Spacing.medium)],
                alignment: .leading,
                spacing: Design.Spacing.medium
            ) {
                NutritionTile(
                    title: "Energy",
                    systemImage: "flame.fill",
                    tint: .red,
                    value: .energy(kilocalories: nutrition.energy)
                )
                NutritionTile(
                    title: "Protein",
                    systemImage: "dumbbell.fill",
                    tint: .blue,
                    value: .mass(grams: nutrition.protein)
                )
                NutritionTile(
                    title: "Carbs",
                    systemImage: "carrot.fill",
                    tint: .orange,
                    value: .mass(grams: nutrition.carbs)
                )
                NutritionTile(
                    title: "Fiber",
                    systemImage: "leaf.fill",
                    tint: .green,
                    value: .mass(grams: nutrition.fiber)
                )
                NutritionTile(
                    title: "Sugar",
                    systemImage: "cube.fill",
                    tint: .pink,
                    value: .mass(grams: nutrition.sugar)
                )
                NutritionTile(
                    title: "Fat",
                    systemImage: "drop.fill",
                    tint: .yellow,
                    value: .mass(grams: nutrition.fat)
                )
                NutritionTile(
                    title: "Saturated Fat",
                    systemImage: "drop.halffull",
                    tint: .purple,
                    value: .mass(grams: nutrition.saturatedFat)
                )
            }
        }
    }
}

#Preview {
    NutritionSection(nutrition: Recipe.sample.nutritionPerServing)
        .padding()
}
