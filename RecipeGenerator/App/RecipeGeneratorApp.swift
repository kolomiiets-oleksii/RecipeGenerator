import SwiftData
import SwiftUI

@main
struct RecipeGeneratorApp: App {
    private let container: ModelContainer

    init() {
        // Hosted unit tests launch the app too; keep them off the real store.
        let isRunningTests = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        #if DEBUG
            if DebugLaunchArguments.seedSampleData {
                container = .preview
                if let servings = DebugLaunchArguments.seedServings {
                    let recipes = try? container.mainContext.fetch(FetchDescriptor<Recipe>())
                    recipes?.first?.servings = servings
                }
                return
            }
        #endif
        do {
            container = try ModelContainerFactory.make(inMemory: isRunningTests)
        } catch {
            fatalError("Could not create the recipe store: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RecipeBookView()
                .applyingDebugLaunchArguments()
        }
        .modelContainer(container)
    }
}
