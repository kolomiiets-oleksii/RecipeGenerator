/// Where the recipe generator flow currently is.
enum GeneratorState: Equatable {
    case idle
    case generating
    case generated(Recipe)
    case error(String)

    var isGenerating: Bool {
        self == .generating
    }
}
