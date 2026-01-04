import SwiftUI

struct WorkoutItem: Identifiable {
    let id = UUID()
    let label: String
    let icon: String
    let time: String
    let duration: String
    let calories: Int
    let effortPoints: Int
}

struct MovementContributor: Identifiable {
    let id = UUID()
    let title: String
    let score: Int
    let icon: String
    let summary: String
    let details: String
    let trend: TrendDirection

    enum TrendDirection {
        case up, down, neutral
    }
}

struct MovementDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var animatedScore: Double = 0
    @State private var showContent = false
    @State private var expandedWorkouts = false

    let score: Int = 88

    private let workouts = [
        WorkoutItem(label: "Morning Run", icon: "figure.run", time: "6:30 AM", duration: "32 min", calories: 320, effortPoints: 15),
        WorkoutItem(label: "Paddle", icon: "figure.tennis", time: "7:30 AM", duration: "45 min", calories: 380, effortPoints: 12),
        WorkoutItem(label: "Walk", icon: "figure.walk", time: "12:15 PM", duration: "18 min", calories: 65, effortPoints: 4),
        WorkoutItem(label: "Evening Walk", icon: "figure.walk", time: "5:45 PM", duration: "25 min", calories: 95, effortPoints: 5)
    ]

    private let contributors = [
        MovementContributor(title: "Daily Steps", score: 84, icon: "figure.walk", summary: "8,432 steps — 84% of goal", details: "You're on track to hit your 10,000 step goal. Walking more in the afternoon helped boost your total.", trend: .up),
        MovementContributor(title: "Active Time", score: 92, icon: "timer", summary: "2h 15m of activity today", details: "You've exceeded your active time goal. Your morning workout and walks contributed significantly.", trend: .up),
        MovementContributor(title: "Workout Intensity", score: 78, icon: "flame.fill", summary: "760 calories burned", details: "Your workout intensity was moderate. Consider adding a high-intensity session for more cardiovascular benefits.", trend: .neutral),
        MovementContributor(title: "Movement Consistency", score: 88, icon: "target", summary: "Active in 9 of 12 hours", details: "Great job staying active throughout the day! You avoided long sedentary periods.", trend: .up)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Score Section
                scoreSection

                // Quick Stats
                quickStatsSection

                // Steps Chart
                stepsChartSection

                // Workout Timeline
                workoutTimelineSection

                // Contributors
                contributorsSection

                // Global Ranking
                globalRankingSection

                // Personalized Factors
                personalizedFactorsSection
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
                Text("Movement")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.5)) {
                animatedScore = Double(score)
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
                        AppColors.movement,
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .shadow(color: AppColors.movement.opacity(0.4), radius: 8)

                VStack(spacing: 4) {
                    Text("\(Int(animatedScore))")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(AppColors.foreground)
                        .contentTransition(.numericText())

                    HStack(spacing: 4) {
                        Image(systemName: "figure.walk")
                            .font(.system(size: 10))
                        Text("8,432 steps")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(AppColors.mutedForeground)
                }
            }
            .frame(width: 150, height: 150)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
    }

    // MARK: - Quick Stats
    private var quickStatsSection: some View {
        HStack(spacing: 12) {
            StatCard(label: "Steps", value: "8,432", icon: "figure.walk", color: AppColors.movement)
            StatCard(label: "Calories", value: "760", icon: "flame.fill", color: Color(hex: "#EF4444"))
            StatCard(label: "Active Time", value: "2h 15m", icon: "timer", color: Color(hex: "#F59E0B"))
        }
    }

    // MARK: - Steps Chart
    private var stepsChartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Steps Today")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.foreground)
                Spacer()
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Circle().fill(AppColors.movement).frame(width: 6, height: 6)
                        Text("Today").font(.system(size: 9)).foregroundColor(AppColors.mutedForeground)
                    }
                    HStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 1).fill(Color(hex: "#3B82F6")).frame(width: 12, height: 2)
                        Text("Yesterday").font(.system(size: 9)).foregroundColor(AppColors.mutedForeground)
                    }
                }
            }

            // Simple bar chart representation
            StepsBarChart()

            // Summary stats
            HStack {
                VStack {
                    Text("8,432")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.foreground)
                    Text("Total Steps")
                        .font(.system(size: 9))
                        .foregroundColor(AppColors.mutedForeground)
                }
                Spacer()
                VStack {
                    Text("+1,240")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.recovery)
                    Text("vs Yesterday")
                        .font(.system(size: 9))
                        .foregroundColor(AppColors.mutedForeground)
                }
                Spacer()
                VStack {
                    Text("84%")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.foreground)
                    Text("Goal Progress")
                        .font(.system(size: 9))
                        .foregroundColor(AppColors.mutedForeground)
                }
            }
            .padding(.top, 8)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Workout Timeline
    private var workoutTimelineSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today's Workouts")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.foreground)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 10))
                    Text("+36 pts")
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundColor(AppColors.primary)
            }

            VStack(spacing: 8) {
                ForEach(expandedWorkouts ? workouts : Array(workouts.prefix(2))) { workout in
                    WorkoutRow(workout: workout)
                }

                if workouts.count > 2 {
                    Button(action: { withAnimation { expandedWorkouts.toggle() } }) {
                        HStack {
                            Text(expandedWorkouts ? "Show less" : "\(workouts.count - 2) more")
                                .font(.system(size: 11, weight: .medium))
                            Image(systemName: expandedWorkouts ? "chevron.up" : "chevron.down")
                                .font(.system(size: 10))
                        }
                        .foregroundColor(AppColors.mutedForeground)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }
                }
            }
            .padding(12)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }

    // MARK: - Contributors Section
    private var contributorsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Score Contributors")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.foreground)
                .padding(.leading, 4)

            ForEach(contributors) { contributor in
                MovementContributorCard(contributor: contributor)
            }
        }
    }

    // MARK: - Global Ranking
    private var globalRankingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.primary)
                    Text("Global Ranking")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.foreground)
                }
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 10))
                    Text("Top 5%")
                        .font(.system(size: 10, weight: .semibold))
                }
                .foregroundColor(Color(hex: "#F59E0B"))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(hex: "#F59E0B").opacity(0.15))
                .clipShape(Capsule())
            }

            // Bell curve visualization placeholder
            ZStack {
                // Simplified bell curve
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 60))
                    path.addQuadCurve(to: CGPoint(x: 280, y: 60), control: CGPoint(x: 140, y: 0))
                }
                .stroke(
                    LinearGradient(colors: [AppColors.recovery, Color(hex: "#F59E0B"), AppColors.heartRate], startPoint: .leading, endPoint: .trailing),
                    lineWidth: 2
                )

                // User position marker
                Circle()
                    .fill(AppColors.primary)
                    .frame(width: 12, height: 12)
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .offset(x: 100, y: -20)
            }
            .frame(height: 80)

            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "figure.walk")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.primary)
                        .frame(width: 32, height: 32)
                        .background(AppColors.primary.opacity(0.2))
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 2) {
                        Text("8,432 steps")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(AppColors.foreground)
                        Text("Your daily total")
                            .font(.system(size: 10))
                            .foregroundColor(AppColors.mutedForeground)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Top 5%")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(AppColors.recovery)
                    Text("of all users globally")
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.mutedForeground)
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Personalized Factors
    private var personalizedFactorsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Your Factors Affecting Movement")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
                Text("Based on your patterns over the last few weeks")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mutedForeground)
            }

            HStack(alignment: .top, spacing: 12) {
                // Positive Effects
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 10))
                        Text("Positive Effect")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(AppColors.recovery)

                    ForEach(["Morning workouts", "Walking meetings", "Post-lunch walks", "Weekend activities"], id: \.self) { factor in
                        FactorChip(text: factor, isPositive: true)
                    }
                }

                // Negative Effects
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.down.right")
                            .font(.system(size: 10))
                        Text("Negative Effect")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(AppColors.heartRate)

                    ForEach(["Extended sitting", "Skipped workouts", "Late nights"], id: \.self) { factor in
                        FactorChip(text: factor, isPositive: false)
                    }
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Supporting Views
struct StatCard: View {
    let label: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppColors.foreground)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(AppColors.mutedForeground)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 2)
    }
}

struct StepsBarChart: View {
    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            ForEach(0..<24, id: \.self) { i in
                RoundedRectangle(cornerRadius: 2)
                    .fill(
                        LinearGradient(
                            colors: [AppColors.movement, AppColors.movement.opacity(0.3)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 8, height: CGFloat.random(in: 20...80))
            }
        }
        .frame(height: 80)
    }
}

struct WorkoutRow: View {
    let workout: WorkoutItem

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: workout.icon)
                .font(.system(size: 12))
                .foregroundColor(AppColors.movement)
                .frame(width: 28, height: 28)
                .background(AppColors.movement.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text(workout.label)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(AppColors.foreground)
                    Text(workout.time)
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.mutedForeground)
                }
                HStack(spacing: 8) {
                    Text(workout.duration)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(AppColors.mutedForeground)
                    HStack(spacing: 2) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 8))
                        Text("\(workout.calories)")
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundColor(AppColors.movement.opacity(0.8))
                    HStack(spacing: 2) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 8))
                        Text("+\(workout.effortPoints)")
                            .font(.system(size: 10, weight: .semibold))
                    }
                    .foregroundColor(AppColors.primary.opacity(0.8))
                }
            }

            Spacer()

            Image(systemName: "checkmark")
                .font(.system(size: 10))
                .foregroundColor(AppColors.recovery)
                .frame(width: 24, height: 24)
                .background(AppColors.recovery.opacity(0.2))
                .clipShape(Circle())
        }
        .padding(8)
        .background(Color.white.opacity(0.02))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.05), lineWidth: 1))
    }
}

struct MovementContributorCard: View {
    let contributor: MovementContributor
    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: 0) {
            Button(action: { withAnimation(.spring(response: 0.3)) { isExpanded.toggle() } }) {
                HStack(spacing: 12) {
                    Image(systemName: contributor.icon)
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.movement)
                        .frame(width: 40, height: 40)
                        .background(AppColors.movement.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text(contributor.title)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(AppColors.foreground)
                            Spacer()
                            HStack(spacing: 4) {
                                Image(systemName: contributor.trend == .up ? "arrow.up.right" : contributor.trend == .down ? "arrow.down.right" : "minus")
                                    .font(.system(size: 10))
                                    .foregroundColor(contributor.trend == .up ? AppColors.recovery : contributor.trend == .down ? Color(hex: "#F59E0B") : AppColors.mutedForeground)
                                Text("\(contributor.score)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(AppColors.foreground)
                            }
                        }
                        Text(contributor.summary)
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.mutedForeground)
                            .lineLimit(1)
                    }

                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(16)
            }

            if isExpanded {
                Text(contributor.details)
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mutedForeground)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
            }
        }
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 2)
    }
}

struct FactorChip: View {
    let text: String
    let isPositive: Bool

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(isPositive ? AppColors.recovery : AppColors.heartRate)
                .frame(width: 6, height: 6)
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(AppColors.foreground)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background((isPositive ? AppColors.recovery : AppColors.heartRate).opacity(0.1))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke((isPositive ? AppColors.recovery : AppColors.heartRate).opacity(0.2), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack {
        MovementDetailsView()
    }
}
