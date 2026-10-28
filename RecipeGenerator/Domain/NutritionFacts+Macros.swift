import Foundation

extension NutritionFacts {
    /// Energy from protein, carbs and fat, with each one's share of the total. Empty if there are no macros.
    var macroShares: [MacroShare] {
        let kilocalories: [(Macro, Double)] = [
            (.protein, protein * Macro.protein.kcalPerGram),
            (.carbs, carbs * Macro.carbs.kcalPerGram),
            (.fat, fat * Macro.fat.kcalPerGram),
        ]
        let total = kilocalories.reduce(0) { $0 + $1.1 }
        guard total > 0 else { return [] }

        return kilocalories.map { MacroShare(macro: $0.0, kilocalories: $0.1, fraction: $0.1 / total) }
    }
}
