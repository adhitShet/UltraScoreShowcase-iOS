import SwiftUI

struct ActiveTimeDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var animatedMinutes: Double = 0
    @State private var showContent = false

    let totalActiveMinutes = 102
    let goalMinutes = 150

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Main Active Time Display
                activeTimeDisplaySection

                // Activity Breakdown
                activityBreakdownSection

                // Hourly Activity
                hourlyActivitySection

                // Weekly Trends
                weeklyTrendsSection

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
                Text("Active Time")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.5)) {
                animatedMinutes = Double(totalActiveMinutes)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.6)) {
                    showContent = true
                }
            }
        }
    }

    // MARK: - Active Time Display Section
    private var activeTimeDisplaySection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(AppColors.border, lineWidth: 12)

                Circle()
                    .trim(from: 0, to: min(animatedMinutes / Double(goalMinutes), 1.0))
                    .stroke(
                        Color(hex: "#F59E0B"),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .shadow(color: Color(hex: "#F59E0B").opacity(0.4), radius: 10)

                VStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color(hex: "#F59E0B"))

                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(Int(animatedMinutes))")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(AppColors.foreground)
                            .contentTransition(.numericText())
                        Text("min")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.mutedForeground)
                    }

                    Text("of \(goalMinutes) min goal")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)
                }
            }
            .frame(width: 180, height: 180)

            // Progress text
            let percentage = Int((Double(totalActiveMinutes) / Double(goalMinutes)) * 100)
            HStack(spacing: 8) {
                Text("\(percentage)% complete")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "#F59E0B"))

                Text("•")
                    .foregroundColor(AppColors.border)

                Text("\(goalMinutes - totalActiveMinutes) min remaining")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.mutedForeground)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 12, x: 0, y: 4)
    }

    // MARK: - Activity Breakdown Section
    private var activityBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Activity Breakdown")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppColors.foreground)

            HStack(spacing: 12) {
                ActivityTypeCard(icon: "figure.walk", title: "Walking", duration: "45 min", color: AppColors.movement)
                ActivityTypeCard(icon: "figure.run", title: "Running", duration: "32 min", color: Color(hex: "#EF4444"))
                ActivityTypeCard(icon: "figure.strengthtraining.traditional", title: "Strength", duration: "25 min", color: Color(hex: "#8B5CF6"))
            }

            // Intensity breakdown
            VStack(alignment: .leading, spacing: 8) {
                Text("Intensity Zones")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(AppColors.mutedForeground)

                HStack(spacing: 4) {
                    IntensityBar(label: "Light", minutes: 35, maxMinutes: 102, color: AppColors.recovery)
                    IntensityBar(label: "Moderate", minutes: 42, maxMinutes: 102, color: Color(hex: "#F59E0B"))
                    IntensityBar(label: "Vigorous", minutes: 25, maxMinutes: 102, color: Color(hex: "#EF4444"))
                }
                .frame(height: 24)
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Hourly Activity Section
    private var hourlyActivitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today's Activity")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
                Spacer()
                Text("Most active: 2-3 PM")
                    .font(.system(size: 11))
                    .foregroundColor(AppColors.mutedForeground)
            }

            // Hourly bars
            HStack(alignment: .bottom, spacing: 4) {
                ForEach(0..<24, id: \.self) { hour in
                    let minutes = [0, 0, 0, 0, 0, 0, 5, 10, 8, 5, 3, 2, 12, 15, 18, 8, 5, 3, 2, 4, 2, 0, 0, 0][hour]
                    RoundedRectangle(cornerRadius: 2)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "#F59E0B"), Color(hex: "#F59E0B").opacity(0.3)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 10, height: CGFloat(minutes * 4))
                }
            }
            .frame(height: 80)

            // Time labels
            HStack {
                Text("12 AM")
                Spacer()
                Text("6 AM")
                Spacer()
                Text("12 PM")
                Spacer()
                Text("6 PM")
                Spacer()
                Text("Now")
            }
            .font(.system(size: 9))
            .foregroundColor(AppColors.mutedForeground)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Weekly Trends Section
    private var weeklyTrendsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("7-Day Average")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
                Spacer()
                Text("95 min")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "#F59E0B"))
            }

            // Weekly bars
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(["M", "T", "W", "T", "F", "S", "S"], id: \.self) { day in
                    let minutes = Int.random(in: 60...150)
                    let isToday = day == "S"
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(isToday ?
                                LinearGradient(colors: [Color(hex: "#F59E0B"), Color(hex: "#F59E0B").opacity(0.6)], startPoint: .top, endPoint: .bottom) :
                                LinearGradient(colors: [Color(hex: "#F59E0B").opacity(0.5)], startPoint: .top, endPoint: .bottom)
                            )
                            .frame(width: 32, height: CGFloat(minutes) / 2)
                        Text(day)
                            .font(.system(size: 10))
                            .foregroundColor(isToday ? AppColors.foreground : AppColors.mutedForeground)
                    }
                }
            }
            .frame(height: 100)

            HStack {
                Text("↑ +15% vs last week")
                    .font(.system(size: 11))
                    .foregroundColor(AppColors.recovery)
                Spacer()
                Text("Goal met: 5/7 days")
                    .font(.system(size: 11))
                    .foregroundColor(AppColors.mutedForeground)
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
                    .foregroundColor(Color(hex: "#F59E0B"))
                Text("ACTIVITY INSIGHTS")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(0.5)
                    .foregroundColor(AppColors.foreground)
            }

            VStack(spacing: 10) {
                InsightRow(
                    icon: "arrow.up.right",
                    iconColor: AppColors.recovery,
                    text: "Your active time is **18% higher** than your weekly average"
                )
                InsightRow(
                    icon: "flame.fill",
                    iconColor: Color(hex: "#F59E0B"),
                    text: "You've burned an estimated **425 calories** today"
                )
                InsightRow(
                    icon: "target",
                    iconColor: Color(hex: "#EF4444"),
                    text: "48 more minutes to reach your daily goal"
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

struct ActivityTypeCard: View {
    let icon: String
    let title: String
    let duration: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)

            Text(title)
                .font(.system(size: 11))
                .foregroundColor(AppColors.mutedForeground)

            Text(duration)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColors.foreground)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct IntensityBar: View {
    let label: String
    let minutes: Int
    let maxMinutes: Int
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(width: CGFloat(minutes) / CGFloat(maxMinutes) * 100 + 20)

            Text("\(label) \(minutes)m")
                .font(.system(size: 9))
                .foregroundColor(AppColors.mutedForeground)
        }
    }
}

#Preview {
    NavigationStack {
        ActiveTimeDetailsView()
    }
}
