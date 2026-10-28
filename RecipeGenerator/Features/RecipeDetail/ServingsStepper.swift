import SwiftUI

/// Servings control with the resulting serving size. Changing servings rescales per-serving nutrition.
struct ServingsStepper: View {
    @Binding var servings: Int
    let servingMass: Double

    var body: some View {
        VStack(alignment: .leading, spacing: Design.Spacing.small) {
            Stepper(value: $servings, in: Recipe.servingsRange) {
                Label {
                    Text("^[\(servings) serving](inflect: true)")
                } icon: {
                    Image(systemName: "person.2")
                }
            }

            Label {
                Text("\(Text.mass(grams: servingMass)) per serving")
            } icon: {
                Image(systemName: "scalemass")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    @Previewable @State var servings = 2
    ServingsStepper(servings: $servings, servingMass: 317.5)
        .padding()
}
