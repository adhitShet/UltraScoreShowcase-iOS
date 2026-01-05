import SwiftUI

struct HRVDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var animatedHRV: Double = 0
    @State private var showContent = false
    @State private var selectedTimeFilter = "week"

    let currentHRV = 68
    let baselineHRV = 59

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Main HRV Display
                hrvDisplaySection

                // Status Card
                statusCard

                // Overnight Trend
                overnightTrendSection

                // Weekly Trends
                weeklyTrendsSection

                // HRV Factors
                hrvFactorsSection

                // Bio Intelligence
                bioIntelligenceSection
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
                Text("Heart Rate Variability")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.5)) {
                animatedHRV = Double(currentHRV)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.6)) {
                    showContent = true
                }
            }
        }
    }

    // MARK: - HRV Display Section
    private var hrvDisplaySection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(AppColors.border, lineWidth: 12)

                Circle()
                    .trim(from: 0, to: min(animatedHRV / 100, 1.0))
                    .stroke(
                        AppColors.recovery,
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .shadow(color: AppColors.recovery.opacity(0.4), radius: 10)

                VStack(spacing: 4) {
                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.recovery)

                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(Int(animatedHRV))")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(AppColors.foreground)
                            .contentTransition(.numericText())
                        Text("ms")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(AppColors.mutedForeground)
                    }

                    Text("Last night average")
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
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 12, x: 0, y: 4)
    }

    // MARK: - Status Card
    private var statusCard: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("vs Baseline")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 12))
                        Text("+\(currentHRV - baselineHRV) ms")
                            .font(.system(size: 18, weight: .bold))
                    }
                    .foregroundColor(AppColors.recovery)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Recovery Status")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)
                    Text("Optimal")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.recovery)
                }
            }

            Divider().background(AppColors.border.opacity(0.5))

            HStack(spacing: 20) {
                VStack(spacing: 2) {
                    Text("Baseline")
                        .font(.system(size: 11))
                        .foregroundColor(AppColors.mutedForeground)
                    Text("\(baselineHRV) ms")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.foreground)
                }
                Spacer()
                VStack(spacing: 2) {
                    Text("Range (30d)")
                        .font(.system(size: 11))
                        .foregroundColor(AppColors.mutedForeground)
                    Text("42-78 ms")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.foreground)
                }
                Spacer()
                VStack(spacing: 2) {
                    Text("Trend")
                        .font(.system(size: 11))
                        .foregroundColor(AppColors.mutedForeground)
                    HStack(spacing: 2) {
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 10))
                        Text("Improving")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(AppColors.recovery)
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Overnight Trend
    private var overnightTrendSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Overnight HRV")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.foreground)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 10))
                    Text("+34ms slope")
                        .font(.system(size: 10, weight: .medium))
                }
                .foregroundColor(AppColors.recovery)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(AppColors.recovery.opacity(0.15))
                .clipShape(Capsule())
            }

            // Graph
            ZStack {
                // Grid
                VStack(spacing: 20) {
                    ForEach(0..<4, id: \.self) { _ in
                        Divider().background(AppColors.border.opacity(0.1))
                    }
                }

                // HRV line with trend
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 70))
                    path.addQuadCurve(to: CGPoint(x: 70, y: 55), control: CGPoint(x: 35, y: 65))
                    path.addQuadCurve(to: CGPoint(x: 140, y: 45), control: CGPoint(x: 105, y: 50))
                    path.addQuadCurve(to: CGPoint(x: 210, y: 35), control: CGPoint(x: 175, y: 40))
                    path.addQuadCurve(to: CGPoint(x: 280, y: 20), control: CGPoint(x: 245, y: 25))
                }
                .stroke(AppColors.recovery, lineWidth: 2.5)

                // Trend line
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 65))
                    path.addLine(to: CGPoint(x: 280, y: 25))
                }
                .stroke(
                    LinearGradient(colors: [Color(hex: "#8B5CF6"), AppColors.recovery], startPoint: .leading, endPoint: .trailing),
                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                )
            }
            .frame(height: 80)

            // Time labels
            HStack {
                Text("10 PM")
                Spacer()
                Text("12 AM")
                Spacer()
                Text("2 AM")
                Spacer()
                Text("4 AM")
                Spacer()
                Text("6 AM")
            }
            .font(.system(size: 9))
            .foregroundColor(AppColors.mutedForeground)

            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 1).fill(AppColors.recovery).frame(width: 16, height: 2)
                    Text("HRV").font(.system(size: 9)).foregroundColor(AppColors.mutedForeground)
                }
                HStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 1)
                        .fill(LinearGradient(colors: [Color(hex: "#8B5CF6"), AppColors.recovery], startPoint: .leading, endPoint: .trailing))
                        .frame(width: 16, height: 4)
                    Text("Trend").font(.system(size: 9)).foregroundColor(AppColors.mutedForeground)
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Weekly Trends
    private var weeklyTrendsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("7-Day Trend")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.foreground)
                Spacer()
                Text("Avg: 62 ms")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mutedForeground)
            }

            HStack(alignment: .bottom, spacing: 12) {
                ForEach(["M", "T", "W", "T", "F", "S", "S"], id: \.self) { day in
                    let height = CGFloat.random(in: 35...80)
                    let isToday = day == "S"
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(isToday ?
                                LinearGradient(colors: [AppColors.recovery, AppColors.recovery.opacity(0.6)], startPoint: .top, endPoint: .bottom) :
                                LinearGradient(colors: [AppColors.recovery.opacity(0.5)], startPoint: .top, endPoint: .bottom)
                            )
                            .frame(width: 32, height: height)
                        Text(day)
                            .font(.system(size: 10))
                            .foregroundColor(isToday ? AppColors.foreground : AppColors.mutedForeground)
                    }
                }
            }
            .frame(height: 100)

            HStack {
                Text("↑ +8% vs last week")
                    .font(.system(size: 11))
                    .foregroundColor(AppColors.recovery)
                Spacer()
                Text("Best: 78 ms (Wed)")
                    .font(.system(size: 11))
                    .foregroundColor(AppColors.mutedForeground)
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - HRV Factors
    private var hrvFactorsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Factors Affecting Your HRV")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.foreground)

            VStack(spacing: 8) {
                HRVFactorRow(title: "Sleep Quality", impact: "High", isPositive: true, icon: "moon.fill")
                HRVFactorRow(title: "Recovery", impact: "High", isPositive: true, icon: "heart.fill")
                HRVFactorRow(title: "Stress Level", impact: "Low", isPositive: true, icon: "brain.head.profile")
                HRVFactorRow(title: "Alcohol", impact: "None", isPositive: true, icon: "wineglass")
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Bio Intelligence
    private var bioIntelligenceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.recovery)
                Text("HRV INTELLIGENCE")
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
                    Text("Your HRV is **15% above** your 30-day baseline, indicating excellent recovery.")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.foreground.opacity(0.8))
                }

                HStack(spacing: 10) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#F59E0B"))
                        .frame(width: 24, height: 24)
                        .background(Color(hex: "#F59E0B").opacity(0.15))
                        .clipShape(Circle())
                    Text("Optimal day for **high-intensity training**.")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.foreground.opacity(0.8))
                }

                HStack(spacing: 10) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#8B5CF6"))
                        .frame(width: 24, height: 24)
                        .background(Color(hex: "#8B5CF6").opacity(0.15))
                        .clipShape(Circle())
                    Text("Positive overnight HRV slope shows strong parasympathetic recovery.")
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
}

// MARK: - HRV Factor Row
struct HRVFactorRow: View {
    let title: String
    let impact: String
    let isPositive: Bool
    let icon: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(isPositive ? AppColors.recovery : AppColors.heartRate)
                .frame(width: 32, height: 32)
                .background((isPositive ? AppColors.recovery : AppColors.heartRate).opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(title)
                .font(.system(size: 14))
                .foregroundColor(AppColors.foreground)

            Spacer()

            HStack(spacing: 4) {
                if isPositive {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.recovery)
                }
                Text(impact)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isPositive ? AppColors.recovery : AppColors.heartRate)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HRVDetailsView()
    }
}
