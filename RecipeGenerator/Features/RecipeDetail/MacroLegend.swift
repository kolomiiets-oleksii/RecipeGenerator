import SwiftUI

/// Colour key and percentages that go with `MacroChart`.
struct MacroLegend: View {
    let shares: [MacroShare]

    var body: some View {
        VStack(alignment: .leading, spacing: Design.Spacing.small) {
            ForEach(shares) { share in
                LabeledContent {
                    Text(share.fraction, format: .percent.precision(.fractionLength(0)))
                        .monospacedDigit()
                } label: {
                    Label {
                        Text(share.macro.title)
                    } icon: {
                        Image(systemName: "circle.fill")
                            .foregroundStyle(share.macro.tint)
                    }
                }
            }
        }
        .accessibilityHidden(true)  // The chart already reads the same values aloud.
    }
}

#Preview {
    MacroLegend(shares: Recipe.sample.nutritionPerServing.macroShares)
        .padding()
}
