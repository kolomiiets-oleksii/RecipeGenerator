import Foundation

/// How much energy one macronutrient provides.
struct MacroShare: Identifiable, Equatable {
    let macro: Macro
    let kilocalories: Double

    /// Share of the total energy from macros, from 0 to 1.
    let fraction: Double

    var id: Macro { macro }
}
