import Foundation
import SwiftData

/// One line of a recipe: what it is, how much, and its nutrition per 100 g.
///
/// CloudKit rules apply: every property has a default, the relationship is
/// optional, and nothing is unique. `order` exists because CloudKit relationships
/// are unordered.
@Model
final class Ingredient {
    var name: String = ""
    var grams: Double = 0
    var order: Int = 0

    var energyPer100g: Double = 0
    var proteinPer100g: Double = 0
    var carbsPer100g: Double = 0
    var fiberPer100g: Double = 0
    var sugarPer100g: Double = 0
    var fatPer100g: Double = 0
    var saturatedFatPer100g: Double = 0

    var recipe: Recipe?

    init(name: String, grams: Double, order: Int, per100g: NutritionFacts) {
        self.name = name
        self.grams = grams
        self.order = order
        energyPer100g = per100g.energy
        proteinPer100g = per100g.protein
        carbsPer100g = per100g.carbs
        fiberPer100g = per100g.fiber
        sugarPer100g = per100g.sugar
        fatPer100g = per100g.fat
        saturatedFatPer100g = per100g.saturatedFat
    }

    var per100g: NutritionFacts {
        NutritionFacts(
            energy: energyPer100g,
            protein: proteinPer100g,
            carbs: carbsPer100g,
            fiber: fiberPer100g,
            sugar: sugarPer100g,
            fat: fatPer100g,
            saturatedFat: saturatedFatPer100g
        )
    }

    var calculatorItem: NutritionCalculator.Item {
        NutritionCalculator.Item(grams: grams, per100g: per100g)
    }
}
