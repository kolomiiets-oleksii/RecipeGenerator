import SwiftUI

/// The recipe's illustration, or a placeholder with a button to create one.
struct RecipeImageHeader: View {
    let recipe: Recipe

    @State private var viewModel = RecipeImageViewModel()
    @Environment(\.recipeImageGenerator) private var imageGenerator

    var body: some View {
        ZStack {
            if let data = recipe.imageData {
                StoredImageView(data: data)
                    .accessibilityLabel("Illustration of \(recipe.title)")
            } else {
                Rectangle()
                    .fill(.fill.quaternary)

                VStack(spacing: Design.Spacing.small) {
                    if viewModel.isGenerating {
                        ProgressView("Creating image…")
                    } else if imageGenerator.isAvailable {
                        Button("Create Image", systemImage: "photo.badge.plus", action: createImage)
                            .buttonStyle(.bordered)
                    } else {
                        Image(systemName: "fork.knife")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                            .accessibilityHidden(true)
                    }

                    if let message = viewModel.errorMessage {
                        Text(message)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: Design.heroImageHeight)
        .clipShape(.rect(cornerRadius: Design.cornerRadius))
    }

    private func createImage() {
        Task { await viewModel.createImage(for: recipe, using: imageGenerator) }
    }
}

#Preview {
    RecipeImageHeader(recipe: .sample)
        .padding()
}
