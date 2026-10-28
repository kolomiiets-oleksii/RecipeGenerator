import SwiftUI

struct NutritionTile: View {
    let title: LocalizedStringKey
    let systemImage: String
    let tint: Color
    let value: Text

    var body: some View {
        VStack(alignment: .leading, spacing: Design.Spacing.small) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundStyle(tint)
                .accessibilityHidden(true)

            Text(title)
                .font(.footnote)
                .foregroundStyle(.secondary)

            value
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NutritionTile(title: "Energy", systemImage: "flame.fill", tint: .red, value: .energy(kilocalories: 320))
        .padding()
}
