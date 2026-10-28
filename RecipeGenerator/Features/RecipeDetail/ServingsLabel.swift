import SwiftUI

struct ServingsLabel: View {
    let servings: Int
    let servingMass: Double

    var body: some View {
        HStack(spacing: Design.Spacing.medium) {
            Label {
                Text("^[\(servings) serving](inflect: true)")
            } icon: {
                Image(systemName: "person.2")
            }

            Label {
                Text("\(Text.mass(grams: servingMass)) per serving")
            } icon: {
                Image(systemName: "scalemass")
            }
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ServingsLabel(servings: 2, servingMass: 250)
}
