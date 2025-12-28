import SwiftUI

// MARK: - Generating State View

/// A loading view displayed while the AI generates a recipe.
///
/// Features an animated brain icon with orbiting particles and pulsing effects
/// to provide visual feedback during the generation process.
struct GeneratingStateView: View {

    // MARK: - State

    @State private var animationAmount = 0.0
    @State private var particleOffset = 0.0
    @State private var glowIntensity = 0.0

    // MARK: - Body

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.blue.opacity(0.3), .purple.opacity(0.1), .clear],
                            center: .center,
                            startRadius: 20,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .scaleEffect(1 + sin(animationAmount) * 0.15)
                    .opacity(0.6 + sin(animationAmount * 2) * 0.2)

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.2), .purple.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .scaleEffect(1 + sin(animationAmount) * 0.1)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                            .scaleEffect(1 + sin(animationAmount * 1.5) * 0.05)
                    )

                Image(systemName: "brain.head.profile")
                    .font(.system(size: 48, weight: .light))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .scaleEffect(1 + sin(animationAmount * 2) * 0.1)
                    .rotationEffect(.degrees(sin(animationAmount * 3) * 3))

                ForEach(0..<6, id: \.self) { index in
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue.opacity(0.6), .purple.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 8, height: 8)
                        .offset(
                            x: cos(animationAmount + Double(index) * .pi / 3) * 60,
                            y: sin(animationAmount + Double(index) * .pi / 3) * 60
                        )
                        .opacity(0.7 + sin(animationAmount * 2 + Double(index)) * 0.3)
                        .scaleEffect(0.5 + sin(animationAmount * 3 + Double(index)) * 0.3)
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: false)) {
                    animationAmount = .pi * 2
                }
            }

            VStack(spacing: 16) {
                Text("Cooking up something special...")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .opacity(glowIntensity)
                    .scaleEffect(0.9 + glowIntensity * 0.1)

                Text("AI is crafting your perfect recipe with detailed nutrition information")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .opacity(glowIntensity)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0).delay(0.3)) {
                    glowIntensity = 1.0
                }
            }

            VStack(spacing: 12) {
                ProgressView()
                    .scaleEffect(1.2)
                    .tint(.blue)

                Text("Analyzing ingredients...")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .opacity(0.7 + sin(animationAmount * 4) * 0.3)
            }

            Spacer()
        }
        .padding()
    }
}
