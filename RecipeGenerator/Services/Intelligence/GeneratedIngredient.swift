import FoundationModels

/// An ingredient as returned by the language model.
///
/// The model supplies the mass and per-100 g values. The app does the math.
@Generable
struct GeneratedIngredient: Equatable {
    @Guide(description: "Ingredient name only, without quantity, for example 'chicken breast'.")
    let name: String

    @Guide(description: "Total mass of this ingredient used in the whole recipe, in grams (g).")
    let grams: Double

    @Guide(description: "Energy per 100 g of this ingredient, in kilocalories (kcal).")
    let energyPer100g: Double

    @Guide(description: "Protein per 100 g of this ingredient, in grams (g).")
    let proteinPer100g: Double

    @Guide(description: "Carbohydrates per 100 g of this ingredient, in grams (g).")
    let carbsPer100g: Double

    @Guide(description: "Dietary fiber per 100 g of this ingredient, in grams (g).")
    let fiberPer100g: Double

    @Guide(description: "Sugar per 100 g of this ingredient, in grams (g).")
    let sugarPer100g: Double

    @Guide(description: "Total fat per 100 g of this ingredient, in grams (g).")
    let fatPer100g: Double

    @Guide(description: "Saturated fat per 100 g of this ingredient, in grams (g).")
    let saturatedFatPer100g: Double
}
