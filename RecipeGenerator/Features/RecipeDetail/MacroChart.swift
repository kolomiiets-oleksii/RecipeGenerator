import Charts
import SwiftUI

/// A donut showing how much of a serving's energy comes from protein, carbs and fat.
struct MacroChart: View {
    let shares: [MacroShare]

    var body: some View {
        Chart(shares) { share in
            SectorMark(
                angle: .value("Energy", share.kilocalories),
                innerRadius: .ratio(0.62),
                angularInset: 2
            )
            .cornerRadius(4)
            .foregroundStyle(share.macro.tint)
        }
        .chartLegend(.hidden)
        .frame(width: 140, height: 140)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Energy by macro")
        .accessibilityValue(summary)
    }

    private var summary: String {
        shares
            .map {
                "\(String(localized: $0.macro.title)) \($0.fraction.formatted(.percent.precision(.fractionLength(0))))"
            }
            .formatted(.list(type: .and, width: .narrow))
    }
}

extension Macro {
    var tint: Color {
        switch self {
        case .protein: .blue
        case .carbs: .orange
        case .fat: .yellow
        }
    }
}

#Preview {
    MacroChart(shares: Recipe.sample.nutritionPerServing.macroShares)
        .padding()
}
