import Foundation

enum RecipeImageError: Error, LocalizedError {
    case unavailable
    case noImageProduced
    case encodingFailed

    var errorDescription: String? {
        switch self {
        case .unavailable:
            "Image creation isn't available on this device."
        case .noImageProduced:
            "No image could be created for this recipe."
        case .encodingFailed:
            "The image couldn't be saved."
        }
    }
}
