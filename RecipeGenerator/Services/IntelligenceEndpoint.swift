import Foundation

// MARK: - Intelligence Endpoint

/// Defines the available AI generation endpoints and their configurations.
///
/// Each endpoint encapsulates the system instructions and prompt template
/// needed to generate a specific type of content.
enum IntelligenceEndpoint {

    // MARK: - Prompt Arguments

    /// Arguments that can be passed to endpoint prompts.
    enum PromptArgument {
        /// A comma-separated list of ingredients for recipe generation.
        case ingredients(String)
    }

    // MARK: - Endpoints

    /// Generates a complete recipe with nutritional information.
    case recipe

    // MARK: - Configuration

    /// The system instructions that define the AI's behavior for this endpoint.
    var instructions: String {
        switch self {
        case .recipe:
            """
            You are an expert nutritionist and chef assistant designed to create healthy, balanced recipes. 
            Your role is to transform ingredient lists into complete, nutritionally-informed recipes with precise measurements and clear cooking instructions.

            Focus on:
            - Accurate nutritional calculations
            - Practical cooking techniques
            - Balanced macro and micronutrient profiles
            - Clear, step-by-step instructions
            - Realistic serving sizes and preparation times
            """
        }
    }

    func prompt(argument: PromptArgument) -> String {
        switch self {
        case .recipe:
            let userIngredients = match(arg: argument)
            return """
                Create a healthy recipe using these ingredients: \(userIngredients)

                Generate a complete recipe that includes:
                - A descriptive title (short and appetizing)
                - Exact nutritional information per serving
                - Complete ingredient list with measurements  
                - Step-by-step cooking instructions
                - Preparation & cooking time (in minutes)
                - One serving size in grams

                Requirements:
                - Calculate accurate nutritional values (energy in kcal, protein/carbs/fiber/sugar/fat in grams)
                - Ensure the recipe is balanced and nutritious
                - Include cooking techniques and timing
                - Make instructions clear and beginner-friendly
                - Optimize for health and flavor
                """
        }
    }

    private func match(arg: PromptArgument) -> String {
        switch arg {
        case .ingredients(let string):
            if self == .recipe {
                return string
            }
        }

        return "blank"
    }
}
