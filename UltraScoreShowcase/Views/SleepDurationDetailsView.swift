import SwiftUI

struct SleepDurationDetailsView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var animatedHours: Double = 0
    @State private var showContent = false
    @State private var selectedTimeRange = "week"

    let totalSleepHours = 7.5
    let goalHours = 8.0

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Main Sleep Display
                sleepDisplaySection

                // Sleep Breakdown
                sleepBreakdownSection

                // Trends Section
                trendsSection

                // Sleep Quality Score
                qualityScoreSection

                // Insights
                insightsSection
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
                Text("Sleep Duration")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.5)) {
                animatedHours = totalSleepHours
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.6)) {
                    showContent = true
                }
            }
        }
    }

    // MARK: - Sleep Display Section
    private var sleepDisplaySection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(AppColors.border, lineWidth: 12)

                Circle()
                    .trim(from: 0, to: min(animatedHours / goalHours, 1.0))
                    .stroke(
                        Color(hex: "#8B5CF6"),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .shadow(color: Color(hex: "#8B5CF6").opacity(0.4), radius: 10)

                VStack(spacing: 4) {
                    Image(systemName: "moon.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color(hex: "#8B5CF6"))

                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(String(format: "%.1f", animatedHours))
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(AppColors.foreground)
                            .contentTransition(.numericText())
                        Text("hrs")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.mutedForeground)
                    }

                    Text("of \(String(format: "%.0f", goalHours))h goal")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)
                }
            }
            .frame(width: 180, height: 180)

            // Time info
            HStack(spacing: 24) {
                VStack(spacing: 2) {
                    Text("Bedtime")
                        .font(.system(size: 11))
                        .foregroundColor(AppColors.mutedForeground)
                    Text("11:30 PM")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.foreground)
                }

                Rectangle()
                    .fill(AppColors.border)
                    .frame(width: 1, height: 30)

                VStack(spacing: 2) {
                    Text("Wake up")
                        .font(.system(size: 11))
                        .foregroundColor(AppColors.mutedForeground)
                    Text("7:00 AM")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.foreground)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 12, x: 0, y: 4)
    }

    // MARK: - Sleep Breakdown Section
    private var sleepBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sleep Stages")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppColors.foreground)

            // Stage bars
            VStack(spacing: 10) {
                SleepStageBar(stage: "Deep", duration: "1h 42m", percentage: 22, color: Color(hex: "#8B5CF6"))
                SleepStageBar(stage: "REM", duration: "1h 30m", percentage: 20, color: Color(hex: "#EC4899"))
                SleepStageBar(stage: "Light", duration: "3h 48m", percentage: 51, color: Color(hex: "#3B82F6"))
                SleepStageBar(stage: "Awake", duration: "30m", percentage: 7, color: Color.gray)
            }

            // Sleep timeline
            SleepTimelineView()
                .frame(height: 60)
                .padding(.top, 8)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Trends Section
    private var trendsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("7-Day Average")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
                Spacer()
                Text("7h 15m")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "#8B5CF6"))
            }

            // Weekly bars
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(["M", "T", "W", "T", "F", "S", "S"], id: \.self) { day in
                    let hours = Double.random(in: 5.5...8.5)
                    let isToday = day == "S"
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(isToday ?
                                LinearGradient(colors: [Color(hex: "#8B5CF6"), Color(hex: "#8B5CF6").opacity(0.6)], startPoint: .top, endPoint: .bottom) :
                                LinearGradient(colors: [Color(hex: "#8B5CF6").opacity(0.5)], startPoint: .top, endPoint: .bottom)
                            )
                            .frame(width: 32, height: CGFloat(hours / 10 * 80))
                        Text(day)
                            .font(.system(size: 10))
                            .foregroundColor(isToday ? AppColors.foreground : AppColors.mutedForeground)
                    }
                }
            }
            .frame(height: 100)

            HStack {
                Text("↑ +12min vs last week")
                    .font(.system(size: 11))
                    .foregroundColor(AppColors.recovery)
                Spacer()
                Text("Best: 8h 15m (Sat)")
                    .font(.system(size: 11))
                    .foregroundColor(AppColors.mutedForeground)
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Quality Score Section
    private var qualityScoreSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sleep Quality Score")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppColors.foreground)

            HStack(spacing: 16) {
                // Score circle
                ZStack {
                    Circle()
                        .stroke(AppColors.border, lineWidth: 6)
                        .frame(width: 80, height: 80)

                    Circle()
                        .trim(from: 0, to: 0.85)
                        .stroke(AppColors.recovery, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-90))

                    Text("85")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(AppColors.foreground)
                }

                VStack(alignment: .leading, spacing: 8) {
                    QualityFactorRow(icon: "checkmark.circle.fill", text: "Good sleep efficiency (92%)", isPositive: true)
                    QualityFactorRow(icon: "checkmark.circle.fill", text: "Deep sleep within range", isPositive: true)
                    QualityFactorRow(icon: "exclamationmark.circle.fill", text: "Slightly short duration", isPositive: false)
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Insights Section
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#8B5CF6"))
                Text("SLEEP INSIGHTS")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(0.5)
                    .foregroundColor(AppColors.foreground)
            }

            VStack(spacing: 10) {
                InsightRow(
                    icon: "arrow.up.right",
                    iconColor: AppColors.recovery,
                    text: "Your sleep duration has **improved 8%** this week"
                )
                InsightRow(
                    icon: "moon.fill",
                    iconColor: Color(hex: "#8B5CF6"),
                    text: "Bedtime consistency: **Good** (within 30 min)"
                )
                InsightRow(
                    icon: "clock.fill",
                    iconColor: Color.orange,
                    text: "Try going to bed **30 min earlier** to meet your goal"
                )
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Supporting Views

struct SleepStageBar: View {
    let stage: String
    let duration: String
    let percentage: Int
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Text(stage)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(AppColors.foreground)
                .frame(width: 50, alignment: .leading)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.border.opacity(0.3))

                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(percentage) / 100)
                }
            }
            .frame(height: 8)

            Text(duration)
                .font(.system(size: 12))
                .foregroundColor(AppColors.mutedForeground)
                .frame(width: 50, alignment: .trailing)
        }
    }
}

struct SleepTimelineView: View {
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let stages: [(start: CGFloat, end: CGFloat, color: Color)] = [
                (0, 0.1, Color.gray), // Awake
                (0.1, 0.25, Color(hex: "#3B82F6")), // Light
                (0.25, 0.4, Color(hex: "#8B5CF6")), // Deep
                (0.4, 0.5, Color(hex: "#3B82F6")), // Light
                (0.5, 0.6, Color(hex: "#EC4899")), // REM
                (0.6, 0.7, Color(hex: "#3B82F6")), // Light
                (0.7, 0.8, Color(hex: "#8B5CF6")), // Deep
                (0.8, 0.9, Color(hex: "#3B82F6")), // Light
                (0.9, 1.0, Color.gray) // Awake
            ]

            VStack(spacing: 4) {
                HStack(spacing: 0) {
                    ForEach(stages.indices, id: \.self) { index in
                        let stage = stages[index]
                        Rectangle()
                            .fill(stage.color)
                            .frame(width: (stage.end - stage.start) * width)
                    }
                }
                .frame(height: 24)
                .clipShape(RoundedRectangle(cornerRadius: 4))

                HStack {
                    Text("11:30 PM")
                    Spacer()
                    Text("2 AM")
                    Spacer()
                    Text("4 AM")
                    Spacer()
                    Text("7 AM")
                }
                .font(.system(size: 9))
                .foregroundColor(AppColors.mutedForeground)
            }
        }
    }
}

struct QualityFactorRow: View {
    let icon: String
    let text: String
    let isPositive: Bool

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(isPositive ? AppColors.recovery : Color.orange)
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(AppColors.mutedForeground)
        }
    }
}

struct InsightRow: View {
    let icon: String
    let iconColor: Color
    let text: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)
                .background(iconColor.opacity(0.15))
                .clipShape(Circle())

            Text(LocalizedStringKey(text))
                .font(.system(size: 14))
                .foregroundColor(AppColors.foreground.opacity(0.8))
        }
    }
}

#Preview {
    NavigationStack {
        SleepDurationDetailsView()
    }
}
