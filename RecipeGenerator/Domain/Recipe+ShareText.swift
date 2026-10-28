import Foundation

extension Recipe {
    /// Plain-text version of the recipe for sharing: title, ingredients with grams, numbered steps and
    /// per-serving nutrition.
    var shareText: String {
        let nutrition = nutritionPerServing
        var lines: [String] = [title]

        if !summary.isEmpty {
            lines.append(summary)
        }

        lines.append("")
        lines.append(
            String(localized: "\(servings) servings, \(Self.shareMass(servingMass)) per serving")
        )

        lines.append("")
        lines.append(String(localized: "Ingredients"))
        lines += sortedIngredients.map { "- \($0.name): \(Self.shareMass($0.grams))" }

        if !steps.isEmpty {
            lines.append("")
            lines.append(String(localized: "Instructions"))
            lines += steps.enumerated().map { "\($0.offset + 1). \($0.element)" }
        }

        lines.append("")
        lines.append(String(localized: "Nutrition per Serving"))
        lines.append("\(String(localized: "Energy")): \(Self.shareEnergy(nutrition.energy))")
        lines.append("\(String(localized: "Protein")): \(Self.shareMass(nutrition.protein))")
        lines.append("\(String(localized: "Carbs")): \(Self.shareMass(nutrition.carbs))")
        lines.append("\(String(localized: "Fiber")): \(Self.shareMass(nutrition.fiber))")
        lines.append("\(String(localized: "Sugar")): \(Self.shareMass(nutrition.sugar))")
        lines.append("\(String(localized: "Fat")): \(Self.shareMass(nutrition.fat))")
        lines.append("\(String(localized: "Saturated Fat")): \(Self.shareMass(nutrition.saturatedFat))")

        return lines.joined(separator: "\n")
    }

    private static func shareMass(_ grams: Double) -> String {
        Measurement(value: grams, unit: UnitMass.grams).formatted(
            .measurement(
                width: .abbreviated,
                usage: .asProvided,
                numberFormatStyle: .number.precision(.fractionLength(0...1))
            )
        )
    }

    private static func shareEnergy(_ kilocalories: Double) -> String {
        Measurement(value: kilocalories, unit: UnitEnergy.kilocalories).formatted(
            .measurement(
                width: .abbreviated,
                usage: .asProvided,
                numberFormatStyle: .number.precision(.fractionLength(0))
            )
        )
    }
}
