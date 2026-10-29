import Foundation

/// A small table of typical nutrition per 100 g for common raw or dry foods.
///
/// Values are rounded figures in the range published by USDA FoodData Central. They exist so the language model can look
/// numbers up instead of recalling them, which it does inconsistently (cooked values for dry rice, 14 kcal for garlic).
/// This is a demo-sized table, not a food database.
enum FoodReference {
    struct Entry: Equatable {
        let name: String
        let facts: NutritionFacts
        let aliases: [String]
    }

    /// Finds the entry for an ingredient name such as "Chicken Breasts" or "white rice (dry)".
    /// When several entries match, the longest matching name wins ("olive oil" over "oil").
    static func find(_ query: String) -> Entry? {
        let words = normalizedWords(query)
        guard !words.isEmpty else { return nil }
        var best: (entry: Entry, length: Int)?
        for entry in entries {
            for name in [entry.name] + entry.aliases {
                let target = normalizedWords(name)
                if contains(words, target), target.count * 100 + name.count > (best?.length ?? 0) {
                    best = (entry, target.count * 100 + name.count)
                }
            }
        }
        return best?.entry
    }

    /// Words that mean the food is not the raw or dry one in the table (cooked rice, chicken broth, dried herbs).
    private static let processedWords: Set<String> = [
        "cooked", "boiled", "roasted", "grilled", "fried", "steamed", "baked", "smoked", "dried", "canned",
        "broth", "stock", "bouillon", "soup", "sauce", "paste", "powder", "seasoning", "mix", "juice", "flake",
    ]

    /// Reference values for an ingredient the model named, or `nil` when the table doesn't cover it or the
    /// name says it is cooked or processed, in which case the table's raw values would be wrong.
    static func facts(forIngredient name: String) -> NutritionFacts? {
        guard processedWords.isDisjoint(with: normalizedWords(name)) else { return nil }
        return find(name)?.facts
    }

    /// Lowercased words with a trailing plural "s" or "es" removed ("tomatoes" matches "tomato").
    private static func normalizedWords(_ text: String) -> [String] {
        text.lowercased()
            .split { !$0.isLetter }
            .map { word in
                var word = String(word)
                if word.count > 4, word.hasSuffix("oes") {
                    word.removeLast(2)
                } else if word.count > 3, word.hasSuffix("s") {
                    word.removeLast()
                }
                return word
            }
    }

    /// True when `target` appears as consecutive words inside `words`.
    private static func contains(_ words: [String], _ target: [String]) -> Bool {
        guard !target.isEmpty, words.count >= target.count else { return false }
        return (0...(words.count - target.count)).contains { start in
            Array(words[start..<start + target.count]) == target
        }
    }

    private static func entry(
        _ name: String,
        _ energy: Double,
        protein: Double,
        carbs: Double,
        fat: Double,
        fiber: Double = 0,
        sugar: Double = 0,
        saturated: Double = 0,
        aliases: [String] = []
    ) -> Entry {
        Entry(
            name: name,
            facts: NutritionFacts(
                energy: energy,
                protein: protein,
                carbs: carbs,
                fiber: fiber,
                sugar: sugar,
                fat: fat,
                saturatedFat: saturated
            ),
            aliases: aliases
        )
    }

    // Per 100 g, raw or dry unless noted.
    static let entries: [Entry] = [
        entry("chicken breast", 120, protein: 22.5, carbs: 0, fat: 2.6, saturated: 0.6, aliases: ["chicken"]),
        entry("ground beef", 254, protein: 17.2, carbs: 0, fat: 20, saturated: 7.7, aliases: ["beef", "minced beef"]),
        entry("salmon", 208, protein: 20, carbs: 0, fat: 13, saturated: 3.1),
        entry("shrimp", 85, protein: 20, carbs: 0, fat: 0.5, saturated: 0.1, aliases: ["prawn"]),
        entry("egg", 143, protein: 12.6, carbs: 0.7, fat: 9.5, sugar: 0.4, saturated: 3.1),
        entry("tofu", 144, protein: 17.3, carbs: 2.8, fat: 8.7, fiber: 2.3, sugar: 0.6, saturated: 1.3),
        entry("rice", 365, protein: 7.1, carbs: 80, fat: 0.7, fiber: 1.3, sugar: 0.1, saturated: 0.2),
        entry(
            "pasta",
            371,
            protein: 13,
            carbs: 75,
            fat: 1.5,
            fiber: 3.2,
            sugar: 2.7,
            saturated: 0.3,
            aliases: ["spaghetti"]
        ),
        entry(
            "oats",
            389,
            protein: 16.9,
            carbs: 66,
            fat: 6.9,
            fiber: 10.6,
            sugar: 1,
            saturated: 1.2,
            aliases: ["oatmeal"]
        ),
        entry("flour", 364, protein: 10.3, carbs: 76, fat: 1, fiber: 2.7, sugar: 0.3, saturated: 0.2),
        entry("lentil", 352, protein: 24.6, carbs: 63, fat: 1.1, fiber: 10.7, sugar: 2, saturated: 0.2),
        entry("chickpea", 378, protein: 20.5, carbs: 63, fat: 6, fiber: 12.2, sugar: 10.7, saturated: 0.6),
        entry("potato", 77, protein: 2, carbs: 17, fat: 0.1, fiber: 2.2, sugar: 0.8),
        entry("carrot", 41, protein: 0.9, carbs: 9.6, fat: 0.2, fiber: 2.8, sugar: 4.7),
        entry("onion", 40, protein: 1.1, carbs: 9.3, fat: 0.1, fiber: 1.7, sugar: 4.2),
        entry("garlic", 149, protein: 6.4, carbs: 33, fat: 0.5, fiber: 2.1, sugar: 1, saturated: 0.1),
        entry("tomato", 18, protein: 0.9, carbs: 3.9, fat: 0.2, fiber: 1.2, sugar: 2.6),
        entry("broccoli", 34, protein: 2.8, carbs: 6.6, fat: 0.4, fiber: 2.6, sugar: 1.7),
        entry("spinach", 23, protein: 2.9, carbs: 3.6, fat: 0.4, fiber: 2.2, sugar: 0.4, saturated: 0.1),
        entry("bell pepper", 31, protein: 1, carbs: 6, fat: 0.3, fiber: 2.1, sugar: 4.2, aliases: []),
        entry("zucchini", 17, protein: 1.2, carbs: 3.1, fat: 0.3, fiber: 1, sugar: 2.5, aliases: ["courgette"]),
        entry("cucumber", 15, protein: 0.7, carbs: 3.6, fat: 0.1, fiber: 0.5, sugar: 1.7),
        entry("cabbage", 25, protein: 1.3, carbs: 5.8, fat: 0.1, fiber: 2.5, sugar: 3.2),
        entry("mushroom", 22, protein: 3.1, carbs: 3.3, fat: 0.3, fiber: 1, sugar: 2),
        entry("apple", 52, protein: 0.3, carbs: 14, fat: 0.2, fiber: 2.4, sugar: 10.4),
        entry("banana", 89, protein: 1.1, carbs: 23, fat: 0.3, fiber: 2.6, sugar: 12, saturated: 0.1),
        entry("lemon", 29, protein: 1.1, carbs: 9.3, fat: 0.3, fiber: 2.8, sugar: 2.5),
        entry("olive oil", 884, protein: 0, carbs: 0, fat: 100, saturated: 13.8, aliases: ["oil", "vegetable oil"]),
        entry("butter", 717, protein: 0.9, carbs: 0.1, fat: 81, sugar: 0.1, saturated: 51.4),
        entry("milk", 61, protein: 3.2, carbs: 5, fat: 3.3, sugar: 5, saturated: 1.9),
        entry("yogurt", 61, protein: 3.5, carbs: 4.7, fat: 3.3, sugar: 4.7, saturated: 2.1, aliases: ["yoghurt"]),
        entry("cheese", 403, protein: 25, carbs: 1.3, fat: 33, sugar: 0.5, saturated: 21, aliases: ["cheddar"]),
        entry("sugar", 387, protein: 0, carbs: 100, fat: 0, sugar: 100),
        entry("honey", 304, protein: 0.3, carbs: 82.4, fat: 0, sugar: 82.1),
        entry("salt", 0, protein: 0, carbs: 0, fat: 0),
    ]
}
