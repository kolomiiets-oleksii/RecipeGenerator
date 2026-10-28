import Foundation
import ImageIO
import ImagePlayground
import UniformTypeIdentifiers

/// Creates recipe illustrations on device with Image Playground.
struct ImagePlaygroundRecipeImageGenerator: RecipeImageGenerating {

    var isAvailable: Bool {
        ImagePlaygroundViewController.isAvailable
    }

    func imageData(for description: String) async throws -> Data {
        guard isAvailable else { throw RecipeImageError.unavailable }

        let creator = try await ImageCreator()
        guard let style = creator.availableStyles.first(where: { $0 == .illustration }) ?? creator.availableStyles.first
        else {
            throw RecipeImageError.unavailable
        }

        for try await created in creator.images(for: [.text(description)], style: style, limit: 1) {
            return try Self.jpegData(from: created.cgImage)
        }
        throw RecipeImageError.noImageProduced
    }

    private static func jpegData(from image: CGImage) throws -> Data {
        guard
            let data = CFDataCreateMutable(nil, 0),
            let destination = CGImageDestinationCreateWithData(data, UTType.jpeg.identifier as CFString, 1, nil)
        else {
            throw RecipeImageError.encodingFailed
        }

        let options = [kCGImageDestinationLossyCompressionQuality: 0.85] as CFDictionary
        CGImageDestinationAddImage(destination, image, options)

        guard CGImageDestinationFinalize(destination) else {
            throw RecipeImageError.encodingFailed
        }
        return data as Data
    }
}
