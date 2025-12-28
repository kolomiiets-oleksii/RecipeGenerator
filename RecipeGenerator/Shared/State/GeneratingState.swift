import SwiftUI

// MARK: - Generating State

/// Represents the current state of the recipe generation process.
///
/// This enum serves as a state machine for the app's main workflow,
/// enabling type-safe state transitions and UI updates.
enum GeneratingState: Equatable {

    // MARK: - Equatable

    static func == (lhs: GeneratingState, rhs: GeneratingState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.error(let lhsError), .error(let rhsError)): return lhsError == rhsError
        case (.generated(let lhsRecipe), .generated(let rhsRecipe)): return lhsRecipe == rhsRecipe
        case (.generating, .generating): return true
        default: return false
        }
    }

    // MARK: - Cases

    /// Initial state, waiting for user input.
    case idle

    /// An error occurred during generation.
    case error(String)

    /// Successfully generated a recipe.
    case generated(Recipe)

    /// Currently generating a recipe.
    case generating

    // MARK: - Computed Properties

    /// Returns `true` if currently in the generating state.
    var isGenerating: Bool {
        if case .generating = self {
            return true
        } else {
            return false
        }
    }

    /// Returns `true` if in the idle state.
    var isIdle: Bool {
        if case .idle = self {
            return true
        } else {
            return false
        }
    }

    // MARK: - UI Properties

    /// The text to display on the action button.
    var actionText: String {
        switch self {
        case .idle:
            return "Generate Recipe"
        case .error:
            return "Try Again"
        case .generated:
            return "New Recipe"
        case .generating:
            return "Generating..."
        }
    }

    var iconSymbol: String {
        switch self {
        case .idle:
            return "sparkles"
        case .error:
            return "exclamationmark.octagon"
        case .generated:
            return "arrow.2.circlepath.circle"
        case .generating:
            return "sparkles"
        }
    }
}
