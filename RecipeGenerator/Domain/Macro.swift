import Foundation

/// The three macronutrients that provide energy.
enum Macro: CaseIterable {
    case protein
    case carbs
    case fat

    /// Kilocalories per gram.
    var kcalPerGram: Double {
        switch self {
        case .protein, .carbs: 4
        case .fat: 9
        }
    }

    var title: LocalizedStringResource {
        switch self {
        case .protein: "Protein"
        case .carbs: "Carbs"
        case .fat: "Fat"
        }
    }
}
