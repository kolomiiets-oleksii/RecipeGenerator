import Foundation

extension NutritionFacts {
    /// Energy the macros add up to, in kcal: protein 4, digestible carbs 4, fiber 2, fat 9 per gram.
    var energyFromMacros: Double {
        4 * protein + 4 * max(carbs - fiber, 0) + 2 * fiber + 9 * fat
    }

    /// Returns these values, read as "per 100 g of an ingredient", with the obvious model mistakes fixed.
    ///
    /// The model sometimes returns values that cannot be true. Rules, applied in order:
    /// 1. No negative values.
    /// 2. Protein, carbs and fat together cannot exceed 100 g; if they do they are scaled down together.
    /// 3. Fiber and sugar cannot exceed carbs; saturated fat cannot exceed fat.
    /// 4. Energy cannot exceed 900 kcal (pure fat is about 900).
    /// 5. Energy must roughly match the macros. If it is off by more than 30% (and by more than 15 kcal),
    ///    the macro-derived energy is used instead.
    var sanitizedPer100g: NutritionFacts {
        var facts = NutritionFacts(
            energy: max(energy, 0),
            protein: max(protein, 0),
            carbs: max(carbs, 0),
            fiber: max(fiber, 0),
            sugar: max(sugar, 0),
            fat: max(fat, 0),
            saturatedFat: max(saturatedFat, 0)
        )

        let macroMass = facts.protein + facts.carbs + facts.fat
        if macroMass > 100 {
            let factor = 100 / macroMass
            facts.protein *= factor
            facts.carbs *= factor
            facts.fat *= factor
        }

        facts.fiber = min(facts.fiber, facts.carbs)
        facts.sugar = min(facts.sugar, facts.carbs)
        facts.saturatedFat = min(facts.saturatedFat, facts.fat)
        facts.energy = min(facts.energy, 900)

        let expected = facts.energyFromMacros
        let difference = abs(facts.energy - expected)
        if difference > 15 && difference > 0.3 * max(expected, 1) {
            facts.energy = expected
        }

        return facts
    }
}
