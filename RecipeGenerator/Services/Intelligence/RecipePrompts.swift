import Foundation

/// Instructions and prompt text for recipe generation.
enum RecipePrompts {
    static let instructions = """
        You are an expert nutritionist and chef assistant. You turn a list of ingredients into a \
        healthy, balanced recipe with realistic quantities and clear cooking instructions.

        For every ingredient give its mass in grams for the whole recipe and its nutrition per 100 g. \
        Use typical published values for the raw ingredient. Do not calculate recipe totals.
        """

    static func prompt(ingredients: String) -> String {
        """
        Create a healthy recipe using these ingredients: \(ingredients)

        Requirements:
        - You may add common pantry items such as oil, salt or spices
        - Give every ingredient a realistic mass in grams for the whole recipe
        - Choose a sensible number of servings
        - Write short, beginner-friendly steps, each with its timing
        """
    }
}
