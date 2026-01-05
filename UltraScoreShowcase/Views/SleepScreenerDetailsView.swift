import SwiftUI

struct SleepScreenerDetailsView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var showContent = false
    @State private var selectedQuestionIndex = 0

    let questions = [
        SleepQuestion(
            question: "How long does it usually take you to fall asleep?",
            options: ["Less than 15 min", "15-30 min", "30-60 min", "More than 60 min"]
        ),
        SleepQuestion(
            question: "How often do you wake up during the night?",
            options: ["Rarely or never", "1-2 times", "3-4 times", "More than 4 times"]
        ),
        SleepQuestion(
            question: "How rested do you feel when you wake up?",
            options: ["Very rested", "Somewhat rested", "Not very rested", "Exhausted"]
        ),
        SleepQuestion(
            question: "Do you snore or has someone told you that you snore?",
            options: ["Never", "Occasionally", "Frequently", "Every night"]
        ),
        SleepQuestion(
            question: "How often do you feel sleepy during the day?",
            options: ["Rarely", "Sometimes", "Often", "Almost always"]
        )
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Info
                headerSection

                // Sleep Score
                sleepScoreSection

                // Risk Indicators
                riskIndicatorsSection

                // Questionnaire
                questionnaireSection

                // Recommendations
                recommendationsSection
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
                        .clipShape(Circle())
                }
            }

            ToolbarItem(placement: .principal) {
                Text("Sleep Screener")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.6)) {
                    showContent = true
                }
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "moon.stars.fill")
                .font(.system(size: 40))
                .foregroundColor(Color(hex: "#8B5CF6"))

            Text("Sleep Health Assessment")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(AppColors.foreground)

            Text("Answer a few questions to understand your sleep patterns and identify potential issues.")
                .font(.system(size: 14))
                .foregroundColor(AppColors.mutedForeground)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 12, x: 0, y: 4)
    }

    // MARK: - Sleep Score Section
    private var sleepScoreSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Your Sleep Health Score")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
                Spacer()
                Text("Based on screening")
                    .font(.system(size: 11))
                    .foregroundColor(AppColors.mutedForeground)
            }

            HStack(spacing: 20) {
                // Score circle
                ZStack {
                    Circle()
                        .stroke(AppColors.border, lineWidth: 8)
                        .frame(width: 100, height: 100)

                    Circle()
                        .trim(from: 0, to: 0.72)
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.recovery, Color(hex: "#8B5CF6")],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(-90))

                    VStack(spacing: 2) {
                        Text("72")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(AppColors.foreground)
                        Text("Good")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppColors.recovery)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    ScoreComponent(label: "Sleep Quality", score: 78, color: AppColors.recovery)
                    ScoreComponent(label: "Sleep Regularity", score: 65, color: Color(hex: "#F59E0B"))
                    ScoreComponent(label: "Sleep Disorders Risk", score: 85, color: AppColors.recovery)
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Risk Indicators Section
    private var riskIndicatorsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Risk Indicators")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppColors.foreground)

            VStack(spacing: 8) {
                RiskIndicatorRow(
                    icon: "lungs.fill",
                    title: "Sleep Apnea Risk",
                    status: "Low",
                    statusColor: AppColors.recovery
                )
                RiskIndicatorRow(
                    icon: "brain.head.profile",
                    title: "Insomnia Indicators",
                    status: "Moderate",
                    statusColor: Color(hex: "#F59E0B")
                )
                RiskIndicatorRow(
                    icon: "clock.arrow.2.circlepath",
                    title: "Circadian Rhythm",
                    status: "Stable",
                    statusColor: AppColors.recovery
                )
                RiskIndicatorRow(
                    icon: "figure.walk",
                    title: "Restless Leg Syndrome",
                    status: "Low",
                    statusColor: AppColors.recovery
                )
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Questionnaire Section
    private var questionnaireSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Sleep Questionnaire")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
                Spacer()
                Text("\(selectedQuestionIndex + 1)/\(questions.count)")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mutedForeground)
            }

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.border.opacity(0.3))

                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "#8B5CF6"))
                        .frame(width: geometry.size.width * CGFloat(selectedQuestionIndex + 1) / CGFloat(questions.count))
                }
            }
            .frame(height: 6)

            // Current question
            let question = questions[selectedQuestionIndex]
            VStack(alignment: .leading, spacing: 12) {
                Text(question.question)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(AppColors.foreground)
                    .lineSpacing(4)

                VStack(spacing: 8) {
                    ForEach(question.options, id: \.self) { option in
                        Button(action: {
                            if selectedQuestionIndex < questions.count - 1 {
                                withAnimation {
                                    selectedQuestionIndex += 1
                                }
                            }
                        }) {
                            HStack {
                                Text(option)
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.foreground)
                                Spacer()
                                Circle()
                                    .stroke(AppColors.border, lineWidth: 2)
                                    .frame(width: 20, height: 20)
                            }
                            .padding(12)
                            .background(AppColors.background)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            }

            // Navigation buttons
            HStack(spacing: 12) {
                if selectedQuestionIndex > 0 {
                    Button(action: {
                        withAnimation {
                            selectedQuestionIndex -= 1
                        }
                    }) {
                        Text("Previous")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppColors.foreground)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(AppColors.border.opacity(0.3))
                            .clipShape(Capsule())
                    }
                }

                Spacer()

                if selectedQuestionIndex < questions.count - 1 {
                    Button(action: {
                        withAnimation {
                            selectedQuestionIndex += 1
                        }
                    }) {
                        Text("Skip")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppColors.mutedForeground)
                    }
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Recommendations Section
    private var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#8B5CF6"))
                Text("PERSONALIZED RECOMMENDATIONS")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(0.5)
                    .foregroundColor(AppColors.foreground)
            }

            VStack(spacing: 10) {
                RecommendationCard(
                    icon: "bed.double.fill",
                    title: "Optimize Sleep Environment",
                    description: "Keep your bedroom cool (65-68°F) and dark for better deep sleep.",
                    color: Color(hex: "#8B5CF6")
                )
                RecommendationCard(
                    icon: "clock.fill",
                    title: "Consistent Sleep Schedule",
                    description: "Go to bed and wake up at the same time, even on weekends.",
                    color: Color(hex: "#3B82F6")
                )
                RecommendationCard(
                    icon: "cup.and.saucer.fill",
                    title: "Limit Caffeine",
                    description: "Avoid caffeine at least 6 hours before bedtime.",
                    color: Color(hex: "#F59E0B")
                )
            }

            // CTA for sleep study
            Button(action: {}) {
                HStack {
                    Image(systemName: "stethoscope")
                        .font(.system(size: 18))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Consider a Sleep Study")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Get professional evaluation for better insights")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                }
                .foregroundColor(.white)
                .padding(16)
                .background(
                    LinearGradient(
                        colors: [Color(hex: "#8B5CF6"), Color(hex: "#EC4899")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Supporting Types and Views

struct SleepQuestion {
    let question: String
    let options: [String]
}

struct ScoreComponent: View {
    let label: String
    let score: Int
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mutedForeground)
                Spacer()
                Text("\(score)%")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(color)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(AppColors.border.opacity(0.3))
                    RoundedRectangle(cornerRadius: 2)
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(score) / 100)
                }
            }
            .frame(height: 4)
        }
    }
}

struct RiskIndicatorRow: View {
    let icon: String
    let title: String
    let status: String
    let statusColor: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(statusColor)
                .frame(width: 32, height: 32)
                .background(statusColor.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(title)
                .font(.system(size: 14))
                .foregroundColor(AppColors.foreground)

            Spacer()

            Text(status)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(statusColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(statusColor.opacity(0.15))
                .clipShape(Capsule())
        }
        .padding(10)
        .background(AppColors.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct RecommendationCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
                .frame(width: 36, height: 36)
                .background(color.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.foreground)
                Text(description)
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mutedForeground)
                    .lineSpacing(2)
            }
        }
        .padding(12)
        .background(AppColors.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack {
        SleepScreenerDetailsView()
    }
}
