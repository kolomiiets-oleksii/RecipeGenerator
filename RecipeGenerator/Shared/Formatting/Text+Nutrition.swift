import SwiftUI

extension Text {
    /// A localized mass such as "12.5 g".
    static func mass(grams: Double) -> Text {
        Text(
            Measurement(value: grams, unit: UnitMass.grams),
            format: .measurement(
                width: .abbreviated,
                usage: .asProvided,
                numberFormatStyle: .number.precision(.fractionLength(0...1))
            )
        )
    }

    /// A localized energy value such as "320 kcal".
    static func energy(kilocalories: Double) -> Text {
        Text(
            Measurement(value: kilocalories, unit: UnitEnergy.kilocalories),
            format: .measurement(
                width: .abbreviated,
                usage: .asProvided,
                numberFormatStyle: .number.precision(.fractionLength(0))
            )
        )
    }
}
