import Foundation
import SwiftData

/// A saved recipe in the user's recipe book.
///
/// Totals are never stored. They are derived from the ingredients on demand, so
/// editing an ingredient can never leave stale numbers behind.
@Model
final class Recipe {
    var title: String = ""
    var summary: String = ""
    var servings: Int = 1
    var steps: [String] = []
    var createdAt: Date = Date.now

    /// Generated illustration, if any. Stored outside the database file.
    @Attribute(.externalStorage)
    var imageData: Data?

    @Relationship(deleteRule: .cascade, inverse: \Ingredient.recipe)
    var ingredients: [Ingredient]? = []

    init(
        title: String,
        summary: String = "",
        servings: Int = 1,
        steps: [String] = [],
        ingredients: [Ingredient] = []
    ) {
        self.title = title
        self.summary = summary
        self.servings = max(servings, 1)
        self.steps = steps
        self.ingredients = ingredients
    }

    // MARK: - Derived values

    var sortedIngredients: [Ingredient] {
        (ingredients ?? []).sorted { $0.order < $1.order }
    }

    private var calculatorItems: [NutritionCalculator.Item] {
        (ingredients ?? []).map(\.calculatorItem)
    }

    var nutritionPerServing: NutritionFacts {
        NutritionCalculator.perServing(of: calculatorItems, servings: servings)
    }

    /// Mass of one serving, in grams.
    var servingMass: Double {
        NutritionCalculator.servingMass(of: calculatorItems, servings: servings)
    }

    /// Short text prompt for the image model.
    var imageDescription: String {
        let main = sortedIngredients.prefix(4).map(\.name).formatted(.list(type: .and, width: .narrow))
        return "\(title), a plated dish with \(main)"
    }
}
