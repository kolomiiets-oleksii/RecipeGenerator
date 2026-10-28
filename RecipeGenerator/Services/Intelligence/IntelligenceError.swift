import Foundation
import FoundationModels

/// Errors from the on-device language model, with messages fit to show a person.
enum IntelligenceError: Error, LocalizedError {
    case modelUnavailable(SystemLanguageModel.Availability.UnavailableReason)
    case contentRejected
    case inputTooLong
    case generationFailed

    init(generationError: LanguageModelSession.GenerationError) {
        switch generationError {
        case .guardrailViolation:
            self = .contentRejected
        case .exceededContextWindowSize:
            self = .inputTooLong
        default:
            self = .generationFailed
        }
    }

    var errorDescription: String? {
        switch self {
        case .modelUnavailable(let reason):
            switch reason {
            case .appleIntelligenceNotEnabled:
                String(localized: "Turn on Apple Intelligence in Settings to generate recipes.")
            case .deviceNotEligible:
                String(localized: "This device doesn't support Apple Intelligence.")
            case .modelNotReady:
                String(localized: "The on-device model is still getting ready. Try again in a few minutes.")
            @unknown default:
                String(localized: "Apple Intelligence isn't available right now.")
            }
        case .contentRejected:
            String(localized: "That request couldn't be completed. Try different ingredients.")
        case .inputTooLong:
            String(localized: "That ingredient list is too long. Try fewer ingredients.")
        case .generationFailed:
            String(localized: "The recipe couldn't be generated. Please try again.")
        }
    }
}
