import SwiftUI

/// Shown while the model is writing the recipe.
struct GeneratingProgressView: View {
    let progress: RecipeProgress
    let onCancel: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: Design.Spacing.large) {
            Image(systemName: "sparkles")
                .font(.largeTitle)
                .imageScale(.large)
                .foregroundStyle(.tint)
                .symbolEffect(.pulse, isActive: !reduceMotion)
                .accessibilityHidden(true)

            VStack(spacing: Design.Spacing.small) {
                Text("Cooking up something special…")
                    .font(.title2.bold())

                Text("Writing your recipe and working out the nutrition.")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .accessibilityElement(children: .combine)

            if progress != .empty {
                VStack(spacing: Design.Spacing.small) {
                    if let title = progress.title {
                        Text(title)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                    }

                    if !progress.ingredientNames.isEmpty {
                        Text(progress.ingredientNames.formatted(.list(type: .and, width: .short)))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    if progress.stepCount > 0 {
                        Text("Writing step \(progress.stepCount)…")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .accessibilityElement(children: .combine)
            }

            ProgressView()
                .controlSize(.large)

            Button("Cancel", role: .cancel, action: onCancel)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    GeneratingProgressView(
        progress: RecipeProgress(
            title: "Garlic Chicken and Rice",
            ingredientNames: ["Chicken breast", "Rice"],
            stepCount: 2
        ),
        onCancel: {}
    )
}
