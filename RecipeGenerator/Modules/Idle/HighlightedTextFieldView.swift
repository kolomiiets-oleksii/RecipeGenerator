import SwiftUI

struct HighlightedTextFieldView: View {
    @Binding private var text: String
    @Binding var glowIntensity: Double
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundColor(.blue)
                        .opacity(glowIntensity)
                        .scaleEffect(0.8 + glowIntensity * 0.2)

                    Text("Let's cook something together!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .opacity(glowIntensity)
                        .scaleEffect(0.9 + glowIntensity * 0.1)

                    Image(systemName: "sparkles")
                        .foregroundColor(.blue)
                        .opacity(glowIntensity)
                        .scaleEffect(0.8 + glowIntensity * 0.2)
                }

                Text("AI will create a personalized recipe for you!")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .fontWeight(.medium)
                    .opacity(glowIntensity)
                    .scaleEffect(0.9 + glowIntensity * 0.1)
            }

            VStack(spacing: 24) {
                TextField(
                    text: $text,
                    prompt: Text("e.g., chicken, rice, broccoli, garlic...")
                        .foregroundColor(.secondary)
                ) {
                    Text("Generate a personalized recipe with nutritional information and step-by-step instructions.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .font(.body)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .scaleEffect(isAnimating ? 1.02 : 1.0)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    LinearGradient(
                                        colors: text.isEmpty
                                            ? [
                                                .blue.opacity(0.3),
                                                .purple.opacity(0.3),
                                            ] : [.green, .blue],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    lineWidth: text.isEmpty ? 2 : 3
                                )
                                .scaleEffect(isAnimating ? 1.02 : 1.0)
                                .animation(
                                    .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                                    value: isAnimating
                                )
                        )
                )
                .opacity(glowIntensity)
                .scaleEffect(0.95 + glowIntensity * 0.05)

                HStack(spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.orange)
                        .font(.caption)
                        .symbolEffect(.appear, options: .repeating)
                        .opacity(glowIntensity)

                    Text("Type ingredients separated by commas")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .opacity(glowIntensity)
                }
                .padding(.horizontal, 4)
            }
            .padding()
        }
        .onAppear {
            isAnimating = true
        }
    }

    init(text: Binding<String>, glowIntensity: Binding<Double> = .constant(1.0)) {
        self._text = text
        self._glowIntensity = glowIntensity
    }
}
