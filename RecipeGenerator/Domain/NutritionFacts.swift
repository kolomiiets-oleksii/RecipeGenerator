import Foundation

/// A set of nutrient amounts. Energy is in kilocalories, everything else in grams.
///
/// The same type describes an ingredient's values per 100 g, an ingredient's
/// contribution to a recipe, and a recipe's totals.
struct NutritionFacts: Equatable {
    var energy = 0.0
    var protein = 0.0
    var carbs = 0.0
    var fiber = 0.0
    var sugar = 0.0
    var fat = 0.0
    var saturatedFat = 0.0

    static let zero = NutritionFacts()

    func scaled(by factor: Double) -> NutritionFacts {
        NutritionFacts(
            energy: energy * factor,
            protein: protein * factor,
            carbs: carbs * factor,
            fiber: fiber * factor,
            sugar: sugar * factor,
            fat: fat * factor,
            saturatedFat: saturatedFat * factor
        )
    }

    static func + (lhs: NutritionFacts, rhs: NutritionFacts) -> NutritionFacts {
        NutritionFacts(
            energy: lhs.energy + rhs.energy,
            protein: lhs.protein + rhs.protein,
            carbs: lhs.carbs + rhs.carbs,
            fiber: lhs.fiber + rhs.fiber,
            sugar: lhs.sugar + rhs.sugar,
            fat: lhs.fat + rhs.fat,
            saturatedFat: lhs.saturatedFat + rhs.saturatedFat
        )
    }
}
