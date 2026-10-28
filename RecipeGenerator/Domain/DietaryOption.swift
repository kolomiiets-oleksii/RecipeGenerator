import Foundation

/// A dietary restriction the generated recipe must respect.
enum DietaryOption: String, CaseIterable, Identifiable {
    case vegetarian
    case vegan
    case glutenFree
    case nutFree

    var id: String { rawValue }

    var title: LocalizedStringResource {
        switch self {
        case .vegetarian: "Vegetarian"
        case .vegan: "Vegan"
        case .glutenFree: "Gluten-free"
        case .nutFree: "Nut-free"
        }
    }

    /// How the option is described to the language model. Stays in English on purpose.
    var promptDescription: String {
        switch self {
        case .vegetarian: "vegetarian (no meat or fish)"
        case .vegan: "vegan (no meat, fish, eggs, dairy or honey)"
        case .glutenFree: "gluten-free (no wheat, barley, rye or regular pasta, bread or flour)"
        case .nutFree: "nut-free (no nuts or nut oils)"
        }
    }
}
