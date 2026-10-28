/// Shared layout constants so spacing and sizing stay consistent across screens.
enum Design {
    enum Spacing {
        static let small = 8.0
        static let medium = 16.0
        static let large = 24.0
    }

    static let cornerRadius = 16.0

    /// Widest the reading column grows on iPad, so text lines stay comfortable.
    static let readableWidth = 720.0

    static let heroImageHeight = 260.0
    static let thumbnailSize = 56.0
}
