import SwiftUI

struct ScoreContributor: Identifiable {
    let id = UUID()
    let name: String
    let value: Int
    var route: String = ""

    var color: Color {
        // Color based on score value (0-100) - pastel colors
        let hue = Double(value) * 1.2 / 360.0
        return Color(hue: hue, saturation: 0.55, brightness: 0.7)
    }
}

struct UltraScoreCard: View {
    @ObservedObject private var themeManager = ThemeManager.shared

    let score: Int
    let contributors: [ScoreContributor]

    @State private var animatedScore: Double = 0
    @State private var animatedContributors: [Double] = []

    private var scoreColor: Color {
        let hue = Double(score) * 1.2 / 360.0
        return Color(hue: hue, saturation: 0.55, brightness: 0.7)
    }

    var body: some View {
        VStack(spacing: 16) {
            // Header
            Text("YOUR EFFORT FOR TODAY")
                .font(.system(size: 10, weight: .medium))
                .tracking(1)
                .foregroundColor(AppColors.mutedForeground)

            // Main Score Ring
            ZStack {
                // Background ring
                Circle()
                    .stroke(
                        AppColors.border,
                        lineWidth: 10
                    )

                // Animated progress ring
                Circle()
                    .trim(from: 0, to: animatedScore / 100)
                    .stroke(
                        scoreColor,
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .shadow(color: scoreColor.opacity(0.4), radius: 8)

                // Score value
                VStack(spacing: 4) {
                    Text("\(Int(animatedScore))")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(AppColors.foreground)
                        .contentTransition(.numericText())

                    HStack(spacing: 2) {
                        Text("Effort Score")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.mutedForeground)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10))
                            .foregroundColor(AppColors.mutedForeground)
                    }
                }
            }
            .frame(width: 150, height: 150)
            .padding(.vertical, 8)

            // Contributors
            HStack(spacing: 12) {
                ForEach(Array(contributors.enumerated()), id: \.element.id) { index, contributor in
                    NavigationLink(destination: destinationView(for: contributor)) {
                        ContributorRing(
                            contributor: contributor,
                            animatedValue: index < animatedContributors.count ? animatedContributors[index] : 0
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: Color.black.opacity(ThemeManager.shared.isDarkMode ? 0.3 : 0.04), radius: 12, x: 0, y: 4)
        .onAppear {
            animatedContributors = Array(repeating: 0, count: contributors.count)
            withAnimation(.easeOut(duration: 1.5).delay(0.3)) {
                animatedScore = Double(score)
            }
            for (index, contributor) in contributors.enumerated() {
                withAnimation(.easeOut(duration: 1.2).delay(0.5 + Double(index) * 0.1)) {
                    if index < animatedContributors.count {
                        animatedContributors[index] = Double(contributor.value)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func destinationView(for contributor: ScoreContributor) -> some View {
        switch contributor.route {
        case "movement":
            MovementDetailsView()
        case "sleep":
            SleepDetailsView()
        case "recovery":
            RecoveryDetailsView()
        default:
            EmptyView()
        }
    }
}

struct ContributorRing: View {
    let contributor: ScoreContributor
    let animatedValue: Double

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Background ring
                Circle()
                    .stroke(
                        contributor.color.opacity(0.2),
                        lineWidth: 5
                    )

                // Progress ring
                Circle()
                    .trim(from: 0, to: animatedValue / 100)
                    .stroke(
                        contributor.color,
                        style: StrokeStyle(lineWidth: 5, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))

                // Value
                Text("\(Int(animatedValue))")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(contributor.color)
            }
            .frame(width: 64, height: 64)

            Text(contributor.name)
                .font(.system(size: 11))
                .foregroundColor(AppColors.mutedForeground)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ZStack {
        AppColors.background.ignoresSafeArea()
        UltraScoreCard(
            score: 79,
            contributors: [
                ScoreContributor(name: "Movement", value: 88, route: "movement"),
                ScoreContributor(name: "Sleep", value: 65, route: "sleep"),
                ScoreContributor(name: "Recovery", value: 45, route: "recovery")
            ]
        )
        .padding()
    }
    .preferredColorScheme(.light)
}
