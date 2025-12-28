import SwiftUI

// MARK: - Recipe Detail View

/// Displays the generated recipe with animated reveal effects.
///
/// Shows the recipe title, ingredients, cooking instructions, and a nutrition facts grid.
/// Each section animates in with staggered timing for a polished presentation.
struct RecipeDetailView: View {

    // MARK: - Properties

    let recipe: Recipe

    // MARK: - State

    @State private var appearAnimation = false
    @State private var sectionDelay = 0.0

    // MARK: - Body

    var body: some View {
        Form {
            Section("Title") {
                Text(recipe.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                    .background(.clear)
            }
            Section("Ingredients") {
                if let ingredients = recipe.ingredients, !ingredients.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        let ingredientList = ingredients.components(separatedBy: ",")
                        ForEach(Array(ingredientList.enumerated()), id: \.offset) { index, ingredient in
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                    .foregroundColor(.blue)
                                    .fontWeight(.bold)
                                    .opacity(appearAnimation ? 1 : 0)
                                    .offset(x: appearAnimation ? 0 : -20)
                                    .animation(
                                        .spring(response: 0.6, dampingFraction: 0.8).delay(sectionDelay + Double(index) * 0.1),
                                        value: appearAnimation
                                    )

                                Text(ingredient.trimmingCharacters(in: .whitespaces))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .opacity(appearAnimation ? 1 : 0)
                                    .offset(x: appearAnimation ? 0 : -20)
                                    .animation(
                                        .spring(response: 0.6, dampingFraction: 0.8).delay(sectionDelay + Double(index) * 0.1),
                                        value: appearAnimation
                                    )
                            }
                        }
                    }
                }

                HStack {
                    Image(systemName: "scalemass")
                        .foregroundColor(.orange)
                    Text("Serving Size: \(String(format: "%.0f", recipe.servingSize))g")
                }
                .font(.headline)
                .opacity(appearAnimation ? 1 : 0)
                .offset(y: appearAnimation ? 0 : 20)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(sectionDelay + 0.3), value: appearAnimation)
            }

            if let steps = recipe.steps, !steps.isEmpty {
                Section("Instructions") {
                    let stepList = steps.components(separatedBy: ".").filter { Int($0) == nil }.filter {
                        !$0.trimmingCharacters(in: .whitespaces).isEmpty
                    }
                    ForEach(Array(stepList.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top, spacing: 12) {
                            Text("\(index + 1)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                                .background(Color.green)
                                .clipShape(Circle())
                                .opacity(appearAnimation ? 1 : 0)
                                .scaleEffect(appearAnimation ? 1 : 0.5)
                                .animation(
                                    .spring(response: 0.6, dampingFraction: 0.8).delay(sectionDelay + 0.4 + Double(index) * 0.1),
                                    value: appearAnimation
                                )

                            Text(step.trimmingCharacters(in: .whitespaces))
                                .fixedSize(horizontal: false, vertical: true)
                                .opacity(appearAnimation ? 1 : 0)
                                .offset(x: appearAnimation ? 0 : 20)
                                .animation(
                                    .spring(response: 0.6, dampingFraction: 0.8).delay(sectionDelay + 0.4 + Double(index) * 0.1),
                                    value: appearAnimation
                                )
                        }
                        .padding(.vertical, 2)
                    }
                }
            }

            Section("Nutrition Facts") {
                LazyVGrid(
                    columns: [
                        GridItem(.adaptive(minimum: 120, maximum: 240)),
                        GridItem(.adaptive(minimum: 120, maximum: 240)),
                        GridItem(.adaptive(minimum: 120, maximum: 240)),
                    ],
                    spacing: 12
                ) {
                    NutritionItem(
                        icon: "flame.fill",
                        label: "Energy",
                        value: "\(String(format: "%.0f", recipe.energy)) kcal",
                        color: .red,
                        delay: sectionDelay + 0.5
                    )

                    NutritionItem(
                        icon: "fish.fill",
                        label: "Protein",
                        value: "\(String(format: "%.1f", recipe.protein))g",
                        color: .blue,
                        delay: sectionDelay + 0.6
                    )

                    NutritionItem(
                        icon: "leaf.fill",
                        label: "Carbs",
                        value: "\(String(format: "%.1f", recipe.carbs))g",
                        color: .orange,
                        delay: sectionDelay + 0.7
                    )

                    NutritionItem(
                        icon: "fiberchannel",
                        label: "Fiber",
                        value: "\(String(format: "%.1f", recipe.fiber))g",
                        color: .brown,
                        delay: sectionDelay + 0.8
                    )

                    NutritionItem(
                        icon: "cube.fill",
                        label: "Sugar",
                        value: "\(String(format: "%.1f", recipe.sugar))g",
                        color: .pink,
                        delay: sectionDelay + 0.9
                    )

                    NutritionItem(
                        icon: "drop.fill",
                        label: "Total Fat",
                        value: "\(String(format: "%.1f", recipe.fatTotal))g",
                        color: .yellow,
                        delay: sectionDelay + 1.0
                    )

                    NutritionItem(
                        icon: "drop.circle.fill",
                        label: "Saturated Fat",
                        value: "\(String(format: "%.1f", recipe.fatSaturated))g",
                        color: .purple,
                        delay: sectionDelay + 1.1
                    )
                }
            }
        }
        .opacity(appearAnimation ? 1 : 0)
        .scaleEffect(appearAnimation ? 1 : 0.95)
        .background(Color(UIColor.secondarySystemBackground))
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                appearAnimation = true
            }
        }
    }
}

// MARK: - Nutrition Item

/// A single nutrition fact display with icon and animated appearance.
struct NutritionItem: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    let delay: Double
    @State private var appearAnimation = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
                .opacity(appearAnimation ? 1 : 0)
                .scaleEffect(appearAnimation ? 1 : 0.8)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay), value: appearAnimation)

            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .opacity(appearAnimation ? 1 : 0)
                    .offset(y: appearAnimation ? 0 : 10)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay + 0.1), value: appearAnimation)

                Text(value)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .opacity(appearAnimation ? 1 : 0)
                    .offset(y: appearAnimation ? 0 : 10)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay + 0.2), value: appearAnimation)
            }
        }
        .padding(4)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay)) {
                appearAnimation = true
            }
        }
    }
}

// MARK: - Preview

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeDetailView(
                recipe: Recipe(
                    title: "Grilled Chicken Salad With Onions And Cucumber",
                    energy: 320.5,
                    protein: 28.3,
                    carbs: 12.7,
                    fiber: 4.2,
                    sugar: 8.1,
                    fatTotal: 18.6,
                    fatSaturated: 3.4,
                    servingSize: 250.0,
                    ingredients:
                        "Grilled chicken breast, Mixed greens, Cherry tomatoes, Cucumber, Red onion, Olive oil, Balsamic vinegar, Salt, Black pepper",
                    steps:
                        "Season chicken breast with salt and pepper. Grill chicken for 6-8 minutes per side until cooked through. Let chicken rest for 5 minutes, then slice. Wash and chop all vegetables. Combine vegetables in a large bowl. Top with sliced chicken. Drizzle with olive oil and balsamic vinegar. Toss gently and serve immediately"
                )
            )
        }
    }
}
