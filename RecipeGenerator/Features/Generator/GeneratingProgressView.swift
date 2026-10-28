import SwiftUI

/// Shown while the model is writing the recipe.
struct GeneratingProgressView: View {
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

            ProgressView()
                .controlSize(.large)

            Button("Cancel", role: .cancel, action: onCancel)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    GeneratingProgressView(onCancel: {})
}
