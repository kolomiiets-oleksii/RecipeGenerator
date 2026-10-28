import SwiftData

extension ModelContainer {
    /// An in-memory container seeded with one recipe, for previews.
    @MainActor
    static var preview: ModelContainer {
        do {
            let container = try ModelContainerFactory.make(inMemory: true)
            container.mainContext.insert(Recipe.sample)
            return container
        } catch {
            fatalError("Could not create the preview container: \(error)")
        }
    }
}
