import SwiftUI

/// The first step of the generator: enter what's in the kitchen.
struct IngredientInputView: View {
    @Binding var text: String
    let dietaryOptions: Set<DietaryOption>
    let onToggleDietaryOption: (DietaryOption) -> Void
    let unavailabilityMessage: String?
    let canGenerate: Bool
    let onGenerate: () -> Void

    @FocusState private var isFocused: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: Design.Spacing.medium) {
                VStack(spacing: Design.Spacing.small) {
                    Text("What's in your kitchen?")
                        .font(.title2.bold())
                        .accessibilityAddTraits(.isHeader)

                    Text(
                        "List the ingredients you have and Apple Intelligence will write a recipe with nutrition worked out for you."
                    )
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                }

                TextField(
                    "Ingredients",
                    text: $text,
                    prompt: Text("e.g. chicken, rice, broccoli, garlic"),
                    axis: .vertical
                )
                .lineLimit(2...6)
                .focused($isFocused)
                .padding()
                .background(.fill.quaternary, in: .rect(cornerRadius: Design.cornerRadius))

                DietaryOptionsPicker(selected: dietaryOptions, onToggle: onToggleDietaryOption)

                Label("Separate ingredients with commas", systemImage: "lightbulb")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                if let unavailabilityMessage {
                    Label(unavailabilityMessage, systemImage: "exclamationmark.triangle.fill")
                        .font(.footnote)
                        .foregroundStyle(.orange)
                }
            }
            .padding()
            .frame(maxWidth: 560)
            .frame(maxWidth: .infinity)
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            // Pinned so the keyboard never hides it.
            Button("Generate Recipe", systemImage: "sparkles", action: onGenerate)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(!canGenerate)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.bar)
        }
        .onAppear { isFocused = true }
        .onDisappear { isFocused = false }
    }
}

#Preview {
    @Previewable @State var text = ""
    IngredientInputView(
        text: $text,
        dietaryOptions: [.vegetarian],
        onToggleDietaryOption: { _ in },
        unavailabilityMessage: nil,
        canGenerate: false,
        onGenerate: {}
    )
}
