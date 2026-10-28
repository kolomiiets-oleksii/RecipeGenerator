import SwiftUI

struct StepsSection: View {
    let steps: [String]

    var body: some View {
        GroupBox("Instructions") {
            VStack(alignment: .leading, spacing: Design.Spacing.medium) {
                ForEach(steps.enumerated(), id: \.offset) { index, step in
                    HStack(alignment: .firstTextBaseline, spacing: Design.Spacing.medium) {
                        Text(index + 1, format: .number)
                            .font(.subheadline.bold().monospacedDigit())
                            .foregroundStyle(.white)
                            .padding(Design.Spacing.small)
                            .background(.tint, in: .circle)

                        Text(step)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Step \(index + 1): \(step)")
                }
            }
        }
    }
}

#Preview {
    StepsSection(steps: Recipe.sample.steps)
        .padding()
}
