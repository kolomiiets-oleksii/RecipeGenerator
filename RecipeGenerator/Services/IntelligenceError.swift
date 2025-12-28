import Foundation
import FoundationModels

// MARK: - Intelligence Error

/// Errors that can occur when interacting with the on-device language model.
enum IntelligenceError: Error, LocalizedError {

    /// The language model is not available on this device.
    /// - Parameter reason: The specific reason why the model is unavailable.
    case modelUnavailable(SystemLanguageModel.Availability.UnavailableReason)

    // MARK: - LocalizedError

    var errorDescription: String {
        switch self {
        case .modelUnavailable(let reason):
            switch reason {
            case .appleIntelligenceNotEnabled:
                return "You need to enable Apple Intelligence in Settings."
            case .deviceNotEligible:
                return "This feature is not available on this device."
            case .modelNotReady:
                return "The model is currently loading. Please try again later."
            @unknown default:
                return "Something went wrong"
            }
        }
    }
}
