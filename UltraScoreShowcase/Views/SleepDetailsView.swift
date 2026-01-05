import SwiftUI

struct SleepStage: Identifiable {
    let id = UUID()
    let name: String
    let duration: String
    let percentage: Double
    let color: Color
    let icon: String
}

struct SleepDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var animatedScore: Double = 0
    @State private var showContent = false
    @State private var selectedTimeFilter = "week"

    let sleepScore: Int = 82

    private let sleepStages = [
        SleepStage(name: "Deep Sleep", duration: "1h 23m", percentage: 0.18, color: Color(hex: "#6366F1"), icon: "moon.zzz.fill"),
        SleepStage(name: "REM Sleep", duration: "1h 48m", percentage: 0.24, color: Color(hex: "#8B5CF6"), icon: "brain.head.profile"),
        SleepStage(name: "Light Sleep", duration: "3h 42m", percentage: 0.48, color: Color(hex: "#A78BFA"), icon: "cloud.moon.fill"),
        SleepStage(name: "Awake", duration: "49m", percentage: 0.10, color: Color(hex: "#F59E0B"), icon: "eye.fill")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Score Section
                scoreSection

                // Sleep Duration Card
                sleepDurationCard

                // Sleep Stages Breakdown
                sleepStagesSection

                // Sleep Timeline
                sleepTimelineSection

                // Sleep Quality Factors
                sleepQualityFactors

                // Weekly Trends
                weeklyTrendsSection

                // Bio Intelligence
                bioIntelligenceSection

                // Personalized Tips
                personalizedTipsSection
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
                VStack(spacing: 2) {
                    Text("Sleep Analysis")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.foreground)
                    Text("Last night")
                        .font(.system(size: 11))
                        .foregroundColor(AppColors.mutedForeground)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.5)) {
                animatedScore = Double(sleepScore)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.6)) {
                    showContent = true
                }
            }
        }
    }

    // MARK: - Score Section
    private var scoreSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(AppColors.border, lineWidth: 10)

                Circle()
                    .trim(from: 0, to: animatedScore / 100)
                    .stroke(
                        Color(hex: "#6366F1"),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .shadow(color: Color(hex: "#6366F1").opacity(0.4), radius: 8)

                VStack(spacing: 4) {
                    Text("\(Int(animatedScore))")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(AppColors.foreground)
                        .contentTransition(.numericText())

                    Text("Sleep Score")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)
                }
            }
            .frame(width: 150, height: 150)

            Text("Excellent sleep quality")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(hex: "#6366F1"))
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(Color(hex: "#6366F1").opacity(0.15))
                .clipShape(Capsule())
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 12, x: 0, y: 4)
    }

    // MARK: - Sleep Duration Card
    private var sleepDurationCard: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Sleep")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)
                    Text("7h 42m")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(AppColors.foreground)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("vs Goal")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.recovery)
                        Text("+42m")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppColors.recovery)
                    }
                }
            }

            Divider().background(AppColors.border.opacity(0.5))

            HStack(spacing: 20) {
                VStack(spacing: 4) {
                    Text("11:23 PM")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.foreground)
                    Text("Bedtime")
                        .font(.system(size: 11))
                        .foregroundColor(AppColors.mutedForeground)
                }
                Spacer()
                Image(systemName: "arrow.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.mutedForeground)
                Spacer()
                VStack(spacing: 4) {
                    Text("7:05 AM")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.foreground)
                    Text("Wake up")
                        .font(.system(size: 11))
                        .foregroundColor(AppColors.mutedForeground)
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Sleep Stages Section
    private var sleepStagesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sleep Stages")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.foreground)
                .padding(.leading, 4)

            // Stacked bar chart
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    ForEach(sleepStages) { stage in
                        Rectangle()
                            .fill(stage.color)
                            .frame(width: geometry.size.width * stage.percentage)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .frame(height: 24)

            // Stage details
            ForEach(sleepStages) { stage in
                HStack(spacing: 12) {
                    Image(systemName: stage.icon)
                        .font(.system(size: 14))
                        .foregroundColor(stage.color)
                        .frame(width: 36, height: 36)
                        .background(stage.color.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(stage.name)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppColors.foreground)
                        Text(stage.duration)
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.mutedForeground)
                    }

                    Spacer()

                    Text("\(Int(stage.percentage * 100))%")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(stage.color)
                }
                .padding(12)
                .background(AppColors.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.25 : 0.02), radius: 4, x: 0, y: 2)
            }
        }
    }

    // MARK: - Sleep Timeline
    private var sleepTimelineSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sleep Timeline")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.foreground)
                .padding(.leading, 4)

            VStack(spacing: 8) {
                // Timeline visualization
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.border.opacity(0.2))
                        .frame(height: 60)

                    // Sleep stages bars
                    HStack(spacing: 0) {
                        // Light sleep
                        Rectangle().fill(Color(hex: "#A78BFA")).frame(width: 40, height: 20)
                        // Deep sleep
                        Rectangle().fill(Color(hex: "#6366F1")).frame(width: 60, height: 40)
                        // REM
                        Rectangle().fill(Color(hex: "#8B5CF6")).frame(width: 50, height: 30)
                        // Light
                        Rectangle().fill(Color(hex: "#A78BFA")).frame(width: 45, height: 20)
                        // Deep
                        Rectangle().fill(Color(hex: "#6366F1")).frame(width: 55, height: 40)
                        // REM
                        Rectangle().fill(Color(hex: "#8B5CF6")).frame(width: 40, height: 30)
                        // Awake
                        Rectangle().fill(Color(hex: "#F59E0B")).frame(width: 15, height: 10)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .padding(4)
                }

                // Time labels
                HStack {
                    Text("11 PM")
                    Spacer()
                    Text("1 AM")
                    Spacer()
                    Text("3 AM")
                    Spacer()
                    Text("5 AM")
                    Spacer()
                    Text("7 AM")
                }
                .font(.system(size: 10))
                .foregroundColor(AppColors.mutedForeground)
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
        }
    }

    // MARK: - Sleep Quality Factors
    private var sleepQualityFactors: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sleep Quality Factors")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.foreground)
                .padding(.leading, 4)

            VStack(spacing: 8) {
                SleepFactorRow(title: "Sleep Efficiency", value: "94%", icon: "chart.pie.fill", color: AppColors.recovery, isGood: true)
                SleepFactorRow(title: "Time to Fall Asleep", value: "8 min", icon: "timer", color: AppColors.recovery, isGood: true)
                SleepFactorRow(title: "Restlessness", value: "Low", icon: "waveform.path", color: AppColors.recovery, isGood: true)
                SleepFactorRow(title: "Sleep Breathing", value: "Normal", icon: "lungs.fill", color: AppColors.recovery, isGood: true)
                SleepFactorRow(title: "Heart Rate Dip", value: "12%", icon: "heart.fill", color: AppColors.recovery, isGood: true)
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
        }
    }

    // MARK: - Weekly Trends
    private var weeklyTrendsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Weekly Sleep Trends")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.foreground)
                Spacer()
                Text("Avg: 7h 28m")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mutedForeground)
            }
            .padding(.leading, 4)

            HStack(alignment: .bottom, spacing: 8) {
                ForEach(["M", "T", "W", "T", "F", "S", "S"], id: \.self) { day in
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#6366F1"), Color(hex: "#6366F1").opacity(0.3)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 32, height: CGFloat.random(in: 40...80))
                        Text(day)
                            .font(.system(size: 10))
                            .foregroundColor(AppColors.mutedForeground)
                    }
                }
            }
            .frame(height: 100)
            .padding(16)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
        }
    }

    // MARK: - Bio Intelligence
    private var bioIntelligenceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#6366F1"))
                Text("SLEEP INTELLIGENCE")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(0.5)
                    .foregroundColor(AppColors.foreground)
            }

            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#6366F1"))
                        .frame(width: 24, height: 24)
                        .background(Color(hex: "#6366F1").opacity(0.15))
                        .clipShape(Circle())
                    Text("Your deep sleep was **18% above** your baseline, supporting physical recovery.")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.foreground.opacity(0.8))
                }

                HStack(spacing: 10) {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#8B5CF6"))
                        .frame(width: 24, height: 24)
                        .background(Color(hex: "#8B5CF6").opacity(0.15))
                        .clipShape(Circle())
                    Text("REM sleep duration optimal for **memory consolidation**.")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.foreground.opacity(0.8))
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Personalized Tips
    private var personalizedTipsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tips for Tonight")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.foreground)
                .padding(.leading, 4)

            VStack(spacing: 8) {
                TipRow(icon: "moon.fill", text: "Maintain your 11:23 PM bedtime for consistency", color: Color(hex: "#6366F1"))
                TipRow(icon: "iphone.slash", text: "Avoid screens 1 hour before sleep", color: Color(hex: "#8B5CF6"))
                TipRow(icon: "thermometer.medium", text: "Keep room temperature around 65-68°F", color: Color(hex: "#A78BFA"))
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
        }
    }
}

// MARK: - Supporting Views
struct SleepFactorRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let isGood: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(color)
                .frame(width: 32, height: 32)
                .background(color.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(title)
                .font(.system(size: 14))
                .foregroundColor(AppColors.foreground)

            Spacer()

            HStack(spacing: 4) {
                Text(value)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(color)
                if isGood {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(color)
                }
            }
        }
    }
}

struct TipRow: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(color)
                .frame(width: 32, height: 32)
                .background(color.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(text)
                .font(.system(size: 13))
                .foregroundColor(AppColors.foreground)
                .lineLimit(2)

            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        SleepDetailsView()
    }
}
