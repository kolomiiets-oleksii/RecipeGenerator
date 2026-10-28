import SwiftUI

/// Chips for choosing dietary options. Selected chips show a checkmark.
struct DietaryOptionsPicker: View {
    let selected: Set<DietaryOption>
    let onToggle: (DietaryOption) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Design.Spacing.small) {
            Text("Dietary needs")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 150), spacing: Design.Spacing.small)],
                alignment: .leading,
                spacing: Design.Spacing.small
            ) {
                ForEach(DietaryOption.allCases) { option in
                    let isSelected = selected.contains(option)

                    Button {
                        onToggle(option)
                    } label: {
                        Label {
                            Text(option.title)
                        } icon: {
                            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(isSelected ? .accentColor : .secondary)
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                }
            }
        }
    }
}

#Preview {
    DietaryOptionsPicker(selected: [.vegan], onToggle: { _ in })
        .padding()
}
