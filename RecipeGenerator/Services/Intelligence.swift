import Foundation
import FoundationModels

// MARK: - Intelligence Service

/// A service that interfaces with Apple's on-device language model to generate structured content.
///
/// This service provides a type-safe interface to the FoundationModels framework,
/// allowing generation of any `Generable` type using predefined endpoints.
///
/// - Note: Requires iPhone 15 Pro or later with Apple Intelligence enabled.
struct Intelligence {

    // MARK: - Public Methods

    /// Generates a structured response using the on-device language model.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint configuration containing instructions and prompt template.
    ///   - argument: The argument to populate the prompt template.
    /// - Returns: A generated instance of the specified `Generable` type.
    /// - Throws: `IntelligenceError.modelUnavailable` if Apple Intelligence is not available.
    public func generate<T: Generable>(
        _ endpoint: IntelligenceEndpoint,
        using argument: IntelligenceEndpoint.PromptArgument
    ) async throws -> T {
        if case .unavailable(let reason) = SystemLanguageModel.default.availability {
            throw IntelligenceError.modelUnavailable(reason)
        }

        let session = LanguageModelSession(instructions: endpoint.instructions)

        let generatedObject = try await session.respond(
            to: endpoint.prompt(argument: argument),
            generating: T.self
        )

        return generatedObject.content
    }
}
