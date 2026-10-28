import SwiftData

/// Builds the app's `ModelContainer`.
///
/// The store is local only. The models follow CloudKit's rules (defaults on every
/// property, optional relationships, nothing unique) so iCloud sync can be added later.
enum ModelContainerFactory {
    static func make(inMemory: Bool = false) throws -> ModelContainer {
        let schema = Schema([Recipe.self, Ingredient.self])
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: inMemory,
            cloudKitDatabase: .none
        )
        return try ModelContainer(for: schema, configurations: [configuration])
    }
}
