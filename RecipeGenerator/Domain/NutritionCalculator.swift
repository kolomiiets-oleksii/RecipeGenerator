import Foundation

/// Pure nutrition math: ingredient masses and per-100 g values in, totals out.
///
/// Keeping this free of SwiftData and the language model makes the numbers
/// deterministic and unit-testable. The model only supplies per-100 g values;
/// it never supplies totals.
enum NutritionCalculator {

    /// One ingredient reduced to what the calculation needs.
    struct Item: Equatable {
        let grams: Double
        let per100g: NutritionFacts
    }

    /// Nutrition for the whole recipe.
    static func total(of items: [Item]) -> NutritionFacts {
        items.reduce(.zero) { sum, item in
            sum + item.per100g.scaled(by: max(item.grams, 0) / 100)
        }
    }

    /// Nutrition for a single serving. A serving count below 1 is treated as 1.
    static func perServing(of items: [Item], servings: Int) -> NutritionFacts {
        total(of: items).scaled(by: 1 / Double(max(servings, 1)))
    }

    /// Combined mass of all ingredients, in grams.
    static func totalMass(of items: [Item]) -> Double {
        items.reduce(0) { $0 + max($1.grams, 0) }
    }

    /// Grams of food in one normal main meal. Used to turn a recipe's total weight into a serving count.
    static let servingMassTarget = 400.0

    /// How many servings a recipe of this total mass makes, from 1 to 12.
    ///
    /// The model's own serving count was unreliable (it spread about 800 g over 4 servings), so the app
    /// derives it from the weight of the ingredients instead.
    static func suggestedServings(totalMass: Double) -> Int {
        let servings = Int((max(totalMass, 0) / servingMassTarget).rounded())
        return min(max(servings, Recipe.servingsRange.lowerBound), Recipe.servingsRange.upperBound)
    }

    /// Mass of a single serving, in grams.
    static func servingMass(of items: [Item], servings: Int) -> Double {
        totalMass(of: items) / Double(max(servings, 1))
    }
}
