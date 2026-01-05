import SwiftUI

// Helper functions for score colors
func getScoreColor(_ value: Int) -> Color {
    let hue = Double(value) * 1.2 / 360.0
    return Color(hue: hue, saturation: 0.55, brightness: 0.7)
}

func getGlowColor(_ value: Int, opacity: Double = 0.4) -> Color {
    let hue = Double(value) * 1.2 / 360.0
    return Color(hue: hue, saturation: 0.6, brightness: 0.65).opacity(opacity)
}

struct ScoreContributorItem: Identifiable {
    let id = UUID()
    let name: String
    let value: Int
    let icon: String
    let route: String
}

struct OutcomeItem: Identifiable {
    let id = UUID()
    let label: String
    let value: String
    let description: String
    let icon: String
    let available: Bool
}

struct EffortScoreDetailsView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    @Environment(\.dismiss) private var dismiss
    let score: Int = 79

    private let contributors = [
        ScoreContributorItem(name: "Movement", value: 88, icon: "figure.walk", route: "movement"),
        ScoreContributorItem(name: "Sleep", value: 65, icon: "moon.fill", route: "sleep"),
        ScoreContributorItem(name: "Recovery", value: 45, icon: "heart.fill", route: "recovery")
    ]

    private let availableOutcomes = [
        OutcomeItem(label: "HRV", value: "+12%", description: "Higher than your baseline", icon: "waveform.path.ecg", available: true),
        OutcomeItem(label: "Resting HR", value: "-4 bpm", description: "Lower than 30-day avg", icon: "heart.fill", available: true),
        OutcomeItem(label: "6 Min Walk", value: "+8%", description: "Distance improvement", icon: "timer", available: true)
    ]

    private let missingOutcomes = [
        ("Blood Markers", "drop.fill"),
        ("DEXA Scan", "viewfinder"),
        ("Weight", "scalemass.fill")
    ]

    @State private var animatedScore: Double = 0
    @State private var showContributors = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Hero Score Section
                heroScoreSection

                // Contributors Section
                contributorsSection

                // Outcomes Section
                outcomesSection
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 40)
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.foreground)
                        .frame(width: 40, height: 40)
                        .background(AppColors.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.5)) {
                animatedScore = Double(score)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.6)) {
                    showContributors = true
                }
            }
        }
    }

    // MARK: - Hero Score Section
    private var heroScoreSection: some View {
        VStack(spacing: 16) {
            // Header
            VStack(spacing: 4) {
                Text("Effort Score")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(AppColors.foreground)
                Text("Science-backed longevity metric")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mutedForeground)
            }

            // Circular Score Display
            ZStack {
                // Background ring
                Circle()
                    .stroke(AppColors.border, lineWidth: 12)

                // Animated progress ring
                Circle()
                    .trim(from: 0, to: animatedScore / 100)
                    .stroke(
                        getScoreColor(score),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .shadow(color: getGlowColor(score, opacity: 0.5), radius: 10)

                // Score text
                VStack(spacing: 4) {
                    Text("\(Int(animatedScore))")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundColor(AppColors.foreground)
                        .contentTransition(.numericText())

                    Text("Today's Effort")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.mutedForeground)
                }
            }
            .frame(width: 180, height: 180)
            .padding(.vertical, 8)

            // Insight text
            Text("Your effort score reflects combined signals from sleep, movement, and recovery — **key pillars of longevity science**.")
                .font(.system(size: 13))
                .foregroundColor(AppColors.mutedForeground)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .padding(24)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 12, x: 0, y: 4)
    }

    // MARK: - Contributors Section
    private var contributorsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Score Contributors")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColors.foreground)
                .padding(.leading, 4)

            ForEach(Array(contributors.enumerated()), id: \.element.id) { index, contributor in
                NavigationLink(destination: destinationView(for: contributor)) {
                    ContributorRow(contributor: contributor, showAnimation: showContributors, delay: Double(index) * 0.1)
                }
                .buttonStyle(PlainButtonStyle())
            }

            // See Weightages Button
            Button(action: {}) {
                HStack {
                    Text("See Weightages")
                        .font(.system(size: 13, weight: .semibold))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundColor(AppColors.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.primary.opacity(0.3), lineWidth: 1)
                )
            }
            .padding(.top, 4)
        }
    }

    // MARK: - Outcomes Section
    private var outcomesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(AppColors.recovery)
                Text("Outcomes")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
            }
            .padding(.leading, 4)

            Text("Higher effort scores correlate with improved health markers")
                .font(.system(size: 11))
                .foregroundColor(AppColors.mutedForeground)
                .padding(.leading, 4)

            // Available outcomes
            ForEach(availableOutcomes) { outcome in
                OutcomeRow(outcome: outcome)
            }

            // Missing data card
            VStack(alignment: .leading, spacing: 12) {
                Text("Add more data sources to unlock additional outcome insights")
                    .font(.system(size: 11))
                    .foregroundColor(AppColors.mutedForeground)

                // Missing outcome chips
                HStack(spacing: 8) {
                    ForEach(missingOutcomes, id: \.0) { item in
                        HStack(spacing: 6) {
                            Image(systemName: item.1)
                                .font(.system(size: 10))
                            Text(item.0)
                                .font(.system(size: 11, weight: .medium))
                        }
                        .foregroundColor(AppColors.mutedForeground)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(AppColors.border.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }

                // Add Health Data button
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .semibold))
                        Text("Add Health Data")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundColor(AppColors.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(AppColors.primary.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                    .foregroundColor(AppColors.primary.opacity(0.2))
            )
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }

    @ViewBuilder
    private func destinationView(for contributor: ScoreContributorItem) -> some View {
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

// MARK: - Contributor Row
struct ContributorRow: View {
    let contributor: ScoreContributorItem
    let showAnimation: Bool
    let delay: Double

    @State private var animatedProgress: Double = 0

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: contributor.icon)
                .font(.system(size: 16))
                .foregroundColor(getScoreColor(contributor.value))
                .frame(width: 44, height: 44)
                .background(getGlowColor(contributor.value, opacity: 0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            // Content
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(contributor.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.foreground)
                    Spacer()
                    Text("\(contributor.value)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(getScoreColor(contributor.value))
                }

                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(AppColors.border.opacity(0.5))
                            .frame(height: 6)

                        RoundedRectangle(cornerRadius: 3)
                            .fill(getScoreColor(contributor.value))
                            .frame(width: geometry.size.width * animatedProgress, height: 6)
                    }
                }
                .frame(height: 6)
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(AppColors.mutedForeground)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(ThemeManager.shared.isDarkMode ? 0.25 : 0.02), radius: 4, x: 0, y: 2)
        .onAppear {
            if showAnimation {
                withAnimation(.easeOut(duration: 0.8).delay(delay)) {
                    animatedProgress = Double(contributor.value) / 100.0
                }
            }
        }
        .onChange(of: showAnimation) { newValue in
            if newValue {
                withAnimation(.easeOut(duration: 0.8).delay(delay)) {
                    animatedProgress = Double(contributor.value) / 100.0
                }
            }
        }
    }
}

// MARK: - Outcome Row
struct OutcomeRow: View {
    let outcome: OutcomeItem

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: outcome.icon)
                .font(.system(size: 16))
                .foregroundColor(AppColors.recovery)
                .frame(width: 40, height: 40)
                .background(AppColors.recovery.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(outcome.label)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.foreground)
                    Spacer()
                    Text(outcome.value)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(AppColors.recovery)
                }
                Text(outcome.description)
                    .font(.system(size: 11))
                    .foregroundColor(AppColors.mutedForeground)
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(ThemeManager.shared.isDarkMode ? 0.25 : 0.02), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    NavigationStack {
        EffortScoreDetailsView()
    }
}
