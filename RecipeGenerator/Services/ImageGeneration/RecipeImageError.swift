import Foundation

enum RecipeImageError: Error, LocalizedError {
    case unavailable
    case noImageProduced
    case encodingFailed

    var errorDescription: String? {
        switch self {
        case .unavailable:
            String(localized: "Image creation isn't available on this device.")
        case .noImageProduced:
            String(localized: "No image could be created for this recipe.")
        case .encodingFailed:
            String(localized: "The image couldn't be saved.")
        }
    }
}
