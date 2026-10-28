import Foundation

/// Instructions and prompt text for recipe generation.
///
/// Tuned against the real on-device model: it often used oil or salt in the steps without listing it, so the
/// prompt now requires every used ingredient to be listed. It ignored serving-size instructions, so the app
/// derives servings from weight (`NutritionCalculator.suggestedServings`) instead of asking for them.
enum RecipePrompts {
    static let instructions = """
        You are an expert nutritionist and chef assistant. You turn a list of ingredients into a \
        healthy, balanced recipe with realistic quantities and clear cooking instructions.

        For every ingredient give its mass in grams for the whole recipe and its nutrition per 100 g. \
        Use typical published values for the raw ingredient. Do not calculate recipe totals.

        Every ingredient used in the steps, including oil, salt and spices, must appear in the ingredient list.
        """

    static func prompt(ingredients: String, dietary: Set<DietaryOption> = []) -> String {
        var requirements: [String] = []

        let chosen = DietaryOption.allCases.filter(dietary.contains)
        if !chosen.isEmpty {
            let list = chosen.map(\.promptDescription).formatted(.list(type: .and, width: .standard))
            requirements.append("The recipe must be \(list). Leave out any given ingredient that does not fit")
        }

        requirements += [
            "You may add common pantry items such as oil, salt or spices, but list every one you use as an ingredient",
            "Give every ingredient a realistic mass in grams for the whole recipe",
            "Write short, beginner-friendly steps, each with its timing",
        ]

        return """
            Create a healthy recipe using these ingredients: \(ingredients)

            Requirements:
            \(requirements.map { "- \($0)" }.joined(separator: "\n"))
            """
    }
}
