import SwiftUI

// MARK: - Idle State View

/// The initial view where users enter their ingredients.
///
/// Displays an animated fork and knife icon with a text input field
/// for entering comma-separated ingredients.
struct IdleStateView: View {

    // MARK: - Bindings

    @Binding var text: String

    // MARK: - State

    @State private var isAnimating = false
    @State private var iconScale = 1.0
    @State private var textFieldGlow = 0.0

    // MARK: - Body

    var body: some View {
        List {
            ZStack {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.orange.opacity(0.1), .red.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60 + CGFloat(index * 20), height: 60 + CGFloat(index * 20))
                        .offset(
                            x: cos(isAnimating ? Double(index) * .pi / 2 : 0) * 10,
                            y: sin(isAnimating ? Double(index) * .pi / 2 : 0) * 10
                        )
                        .opacity(0.3 + sin(isAnimating ? Double(index) * .pi : 0) * 0.2)
                }

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.orange.opacity(0.2), .red.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .scaleEffect(iconScale)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [.orange, .red],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                            .scaleEffect(iconScale)
                    )

                Image(systemName: "fork.knife")
                    .font(.system(size: 48, weight: .light))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .scaleEffect(iconScale)
            }
            .listRowSeparator(.hidden)
            .frame(maxWidth: .infinity, alignment: .center)
            .onAppear {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    iconScale = 1.05
                }
                withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
            .listRowBackground(Color.clear)

            HighlightedTextFieldView(text: $text, glowIntensity: $textFieldGlow)
                .listRowSeparator(.hidden)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0).delay(0.5)) {
                        textFieldGlow = 1.0
                    }
                }
                .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .scrollBounceBehavior(.basedOnSize)
        .background(.regularMaterial)
    }
}

// MARK: - Feature Card

/// A reusable card component for displaying feature highlights.
struct FeatureCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(title)
                .font(.headline)
                .fontWeight(.medium)

            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.regularMaterial)
        .cornerRadius(12)
    }
}
