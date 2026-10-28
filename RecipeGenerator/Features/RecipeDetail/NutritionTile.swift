import SwiftUI

struct NutritionTile: View {
    let title: LocalizedStringKey
    let systemImage: String
    let tint: Color
    let value: Text

    var body: some View {
        VStack(alignment: .leading, spacing: Design.Spacing.small) {
            Label {
                Text(title)
            } icon: {
                Image(systemName: systemImage)
                    .foregroundStyle(tint)
            }
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
