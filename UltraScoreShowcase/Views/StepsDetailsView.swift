import SwiftUI

struct StepsDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var animatedSteps: Double = 0
    @State private var showContent = false
    @State private var selectedTimeFilter = "day"

    let totalSteps = 8432
    let goalSteps = 10000

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Main Steps Display
                stepsDisplaySection

                // Progress Card
                progressCard

                // Hourly Breakdown
                hourlyBreakdownSection

                // Weekly Trends
                weeklyTrendsSection

                // Distance & Calories
                statsCardsSection

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
                Text("Steps")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.5)) {
                animatedSteps = Double(totalSteps)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.6)) {
                    showContent = true
                }
            }
        }
    }

    // MARK: - Steps Display Section
    private var stepsDisplaySection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(AppColors.border, lineWidth: 12)

                Circle()
                    .trim(from: 0, to: min(animatedSteps / Double(goalSteps), 1.0))
                    .stroke(
                        AppColors.movement,
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .shadow(color: AppColors.movement.opacity(0.4), radius: 10)

                VStack(spacing: 4) {
                    Image(systemName: "figure.walk")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.movement)

                    Text(formatNumber(Int(animatedSteps)))
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(AppColors.foreground)
                        .contentTransition(.numericText())

                    Text("of \(formatNumber(goalSteps)) goal")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)
                }
            }
            .frame(width: 180, height: 180)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
    }

    // MARK: - Progress Card
    private var progressCard: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Goal Progress")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.foreground)
                Spacer()
                Text("\(Int((Double(totalSteps) / Double(goalSteps)) * 100))%")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppColors.movement)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(AppColors.border.opacity(0.3))
                        .frame(height: 12)

                    RoundedRectangle(cornerRadius: 6)
                        .fill(AppColors.movement)
                        .frame(width: geometry.size.width * CGFloat(Double(totalSteps) / Double(goalSteps)), height: 12)
                }
            }
            .frame(height: 12)

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Remaining")
                        .font(.system(size: 11))
                        .foregroundColor(AppColors.mutedForeground)
                    Text("\(formatNumber(goalSteps - totalSteps)) steps")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.foreground)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("vs Yesterday")
                        .font(.system(size: 11))
                        .foregroundColor(AppColors.mutedForeground)
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 10))
                        Text("+1,240")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(AppColors.recovery)
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Hourly Breakdown
    private var hourlyBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today's Activity")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.foreground)
                Spacer()
                HStack(spacing: 4) {
                    ForEach(["day", "week", "month"], id: \.self) { filter in
                        Button(action: { selectedTimeFilter = filter }) {
                            Text(filter.capitalized)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(selectedTimeFilter == filter ? .white : AppColors.mutedForeground)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(selectedTimeFilter == filter ? AppColors.movement : Color.clear)
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(4)
                .background(AppColors.border.opacity(0.5))
                .clipShape(Capsule())
            }

            // Bar chart
            HStack(alignment: .bottom, spacing: 4) {
                ForEach(0..<24, id: \.self) { hour in
                    let height = CGFloat.random(in: 10...70)
                    VStack(spacing: 2) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(
                                LinearGradient(
                                    colors: [AppColors.movement, AppColors.movement.opacity(0.3)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 10, height: height)
                    }
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
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Weekly Trends
    private var weeklyTrendsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("7-Day Average")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.foreground)
                Spacer()
                Text("7,892 steps")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.movement)
            }

            HStack(alignment: .bottom, spacing: 12) {
                ForEach(["M", "T", "W", "T", "F", "S", "S"], id: \.self) { day in
                    let height = CGFloat.random(in: 30...80)
                    let isToday = day == "S"
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(isToday ?
                                LinearGradient(colors: [AppColors.movement, AppColors.movement.opacity(0.6)], startPoint: .top, endPoint: .bottom) :
                                LinearGradient(colors: [AppColors.movement.opacity(0.5)], startPoint: .top, endPoint: .bottom)
                            )
                            .frame(width: 32, height: height)
                        Text(day)
                            .font(.system(size: 10))
                            .foregroundColor(isToday ? AppColors.foreground : AppColors.mutedForeground)
                    }
                }
            }
            .frame(height: 100)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Stats Cards
    private var statsCardsSection: some View {
        HStack(spacing: 12) {
            VStack(spacing: 8) {
                Image(systemName: "point.topleft.down.to.point.bottomright.curvepath.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "#3B82F6"))
                Text("5.2 km")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppColors.foreground)
                Text("Distance")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mutedForeground)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)

            VStack(spacing: 8) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "#EF4444"))
                Text("312")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppColors.foreground)
                Text("Calories")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mutedForeground)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)

            VStack(spacing: 8) {
                Image(systemName: "timer")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "#F59E0B"))
                Text("1h 42m")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppColors.foreground)
                Text("Active Time")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mutedForeground)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
        }
    }

    // MARK: - Insights
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.movement)
                Text("MOVEMENT INSIGHTS")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(0.5)
                    .foregroundColor(AppColors.foreground)
            }

            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.recovery)
                        .frame(width: 24, height: 24)
                        .background(AppColors.recovery.opacity(0.15))
                        .clipShape(Circle())
                    Text("You're **17% ahead** of your weekly average")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.foreground.opacity(0.8))
                }

                HStack(spacing: 10) {
                    Image(systemName: "figure.walk")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.movement)
                        .frame(width: 24, height: 24)
                        .background(AppColors.movement.opacity(0.15))
                        .clipShape(Circle())
                    Text("Most active hour: **2 PM - 3 PM**")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.foreground.opacity(0.8))
                }

                HStack(spacing: 10) {
                    Image(systemName: "target")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#F59E0B"))
                        .frame(width: 24, height: 24)
                        .background(Color(hex: "#F59E0B").opacity(0.15))
                        .clipShape(Circle())
                    Text("1,568 more steps to reach your goal")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.foreground.opacity(0.8))
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }

    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

#Preview {
    NavigationStack {
        StepsDetailsView()
    }
}
