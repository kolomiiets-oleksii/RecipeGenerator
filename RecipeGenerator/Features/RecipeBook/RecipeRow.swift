import SwiftUI

/// One recipe in the sidebar list.
struct RecipeRow: View {
    let recipe: Recipe

    var body: some View {
        HStack(spacing: Design.Spacing.medium) {
            Group {
                if let data = recipe.imageData {
                    StoredImageView(data: data)
                } else {
                    Image(systemName: "fork.knife")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.fill.quaternary)
                }
            }
            .frame(width: Design.thumbnailSize, height: Design.thumbnailSize)
            .clipShape(.rect(cornerRadius: Design.cornerRadius / 2))
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(recipe.title)
                    .font(.headline)
                    .lineLimit(2)

                Text("\(Text.energy(kilocalories: recipe.nutritionPerServing.energy)) per serving")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    List {
        RecipeRow(recipe: .sample)
    }
}
