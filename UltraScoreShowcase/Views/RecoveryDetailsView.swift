import SwiftUI

struct RecoveryContributor: Identifiable {
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

struct RecoveryDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var animatedScore: Double = 0
    @State private var showContent = false
    @State private var selectedTimeFilter = "week"
    @State private var isScaleExpanded = false

    let recoveryScore: Int = 86

    private let contributors = [
        RecoveryContributor(title: "Resting Heart Rate", score: 88, icon: "heart.fill", summary: "52 bpm - 3 below average", details: "Your resting heart rate dropped to 52 bpm, indicating good cardiovascular recovery. Lower RHR typically correlates with better readiness.", trend: .up),
        RecoveryContributor(title: "Skin Temperature", score: 85, icon: "thermometer.medium", summary: "0.2°C below baseline", details: "Temperature deviation is within normal range, suggesting stable metabolic state and no signs of inflammation or illness.", trend: .up),
        RecoveryContributor(title: "HRV", score: 92, icon: "waveform.path.ecg", summary: "68ms - 15% above baseline", details: "Your HRV shows strong parasympathetic activity. The positive overnight trend indicates excellent nervous system recovery.", trend: .up),
        RecoveryContributor(title: "Sleep Score", score: 82, icon: "moon.fill", summary: "Quality sleep supported recovery", details: "Good sleep architecture with adequate deep sleep contributed positively to your recovery score.", trend: .neutral),
        RecoveryContributor(title: "Stress", score: 75, icon: "exclamationmark.triangle.fill", summary: "Moderate stress detected", details: "Some stress indicators present but well-managed. Consider relaxation techniques to optimize recovery further.", trend: .down)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Score Section with Readiness Scale
                scoreSection

                // Improvement Insight
                improvementInsightSection

                // Bio Intelligence
                bioIntelligenceSection

                // Contributors
                contributorsSection

                // HRV Trend Graph
                hrvTrendSection

                // Heart Rate Graph
                heartRateGraphSection

                // Recovery Trends
                recoveryTrendsSection

                // Recovery Debt
                recoveryDebtSection

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
                VStack(spacing: 2) {
                    Text("Recovery Analysis")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.foreground)
                    Text("This morning")
                        .font(.system(size: 11))
                        .foregroundColor(AppColors.mutedForeground)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.5)) {
                animatedScore = Double(recoveryScore)
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
            // Main Score Ring
            ZStack {
                Circle()
                    .stroke(AppColors.border, lineWidth: 10)

                Circle()
                    .trim(from: 0, to: animatedScore / 100)
                    .stroke(
                        Color(hex: "#8B5CF6"),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .shadow(color: Color(hex: "#8B5CF6").opacity(0.4), radius: 8)

                VStack(spacing: 4) {
                    Text("\(Int(animatedScore))")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(AppColors.foreground)
                        .contentTransition(.numericText())

                    HStack(spacing: 4) {
                        Circle()
                            .fill(AppColors.workout)
                            .frame(width: 6, height: 6)
                        Text("Primed")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(AppColors.mutedForeground)
                }
            }
            .frame(width: 150, height: 150)

            // Tag
            Text("Balanced recovery")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(hex: "#8B5CF6"))
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(Color(hex: "#8B5CF6").opacity(0.15))
                .clipShape(Capsule())

            // Training Readiness Scale
            trainingReadinessScale
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 12, x: 0, y: 4)
    }

    // MARK: - Training Readiness Scale
    private var trainingReadinessScale: some View {
        VStack(spacing: 12) {
            Button(action: { withAnimation { isScaleExpanded.toggle() } }) {
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "#8B5CF6"))
                        Text("Training Readiness")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppColors.foreground)
                    }
                    Spacer()
                    HStack(spacing: 6) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 10))
                        Text("Primed")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(Color(hex: "#10B981"))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(hex: "#10B981").opacity(0.14))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(hex: "#10B981").opacity(0.22), lineWidth: 1))
                    .clipShape(Capsule())

                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)
                        .rotationEffect(.degrees(isScaleExpanded ? 180 : 0))
                }
            }

            if isScaleExpanded {
                VStack(spacing: 8) {
                    // Scale track
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background track
                            RoundedRectangle(cornerRadius: 6)
                                .fill(AppColors.border.opacity(0.2))
                                .frame(height: 12)

                            // Filled portion
                            RoundedRectangle(cornerRadius: 6)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "#EF4444"), Color(hex: "#F59E0B"), Color(hex: "#10B981")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * 0.78, height: 12)
                        }
                    }
                    .frame(height: 12)

                    // Labels
                    HStack {
                        Text("Rest")
                        Spacer()
                        Text("Light")
                        Spacer()
                        Text("Moderate")
                        Spacer()
                        Text("Ready")
                        Spacer()
                        Text("Primed")
                    }
                    .font(.system(size: 9))
                    .foregroundColor(AppColors.mutedForeground)
                }
                .padding(.top, 8)
            }
        }
        .padding(12)
        .background(AppColors.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Improvement Insight
    private var improvementInsightSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.recovery)
                    .frame(width: 24, height: 24)
                    .background(AppColors.recovery.opacity(0.15))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text("Good improvement! What helped?")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(AppColors.foreground)
                    Text("Tags reveal what's working for you")
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.mutedForeground)
                }
            }

            // Tags
            HStack(spacing: 8) {
                ForEach(["Meditation", "Magnesium", "Cupping therapy"], id: \.self) { tag in
                    HStack(spacing: 4) {
                        Image(systemName: tag == "Meditation" ? "brain.head.profile" : tag == "Magnesium" ? "pills.fill" : "circle")
                            .font(.system(size: 10))
                        Text(tag)
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundColor(AppColors.mutedForeground)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppColors.border.opacity(0.3))
                    .clipShape(Capsule())
                }
                Text("+more")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(AppColors.mutedForeground)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppColors.border.opacity(0.2))
                    .clipShape(Capsule())
            }

            // CTA
            Button(action: {}) {
                HStack {
                    Text("See current outcomes")
                        .font(.system(size: 11, weight: .medium))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10))
                }
                .foregroundColor(AppColors.recovery)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(AppColors.recovery.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(colors: [AppColors.recovery.opacity(0.4), AppColors.recovery.opacity(0.12), AppColors.recovery.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing),
                            lineWidth: 1
                        )
                )
        )
    }

    // MARK: - Bio Intelligence
    private var bioIntelligenceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#8B5CF6"))
                Text("BIO INTELLIGENCE")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(0.5)
                    .foregroundColor(AppColors.foreground)
            }

            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#8B5CF6"))
                        .frame(width: 24, height: 24)
                        .background(Color(hex: "#8B5CF6").opacity(0.15))
                        .clipShape(Circle())
                    Text("Strong HRV slope indicates **optimal recovery**")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.foreground.opacity(0.8))
                }

                HStack(spacing: 10) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.recovery)
                        .frame(width: 24, height: 24)
                        .background(AppColors.recovery.opacity(0.15))
                        .clipShape(Circle())
                    Text("Ready for high-intensity training")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.foreground.opacity(0.8))
                }
            }

            // Ask Jade button
            Button(action: {}) {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 16, height: 16)
                        Circle()
                            .fill(Color.white)
                            .frame(width: 8, height: 8)
                    }
                    Text("Ask Jade anything")
                        .font(.system(size: 11, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color(hex: "#8B5CF6"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Contributors Section
    private var contributorsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recovery Contributors")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.foreground)
                .padding(.leading, 4)

            ForEach(contributors) { contributor in
                RecoveryContributorCard(contributor: contributor)
            }
        }
    }

    // MARK: - HRV Trend Section
    private var hrvTrendSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("HRV Trend")
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

            // Simple line graph representation
            ZStack {
                // Grid lines
                VStack(spacing: 20) {
                    ForEach(0..<3, id: \.self) { _ in
                        Divider().background(AppColors.border.opacity(0.1))
                    }
                }

                // Trend line
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 60))
                    path.addLine(to: CGPoint(x: 280, y: 20))
                }
                .stroke(
                    LinearGradient(colors: [Color(hex: "#8B5CF6"), AppColors.recovery], startPoint: .leading, endPoint: .trailing),
                    lineWidth: 3
                )

                // HRV line (wavy)
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 50))
                    path.addQuadCurve(to: CGPoint(x: 70, y: 40), control: CGPoint(x: 35, y: 60))
                    path.addQuadCurve(to: CGPoint(x: 140, y: 35), control: CGPoint(x: 105, y: 25))
                    path.addQuadCurve(to: CGPoint(x: 210, y: 30), control: CGPoint(x: 175, y: 45))
                    path.addQuadCurve(to: CGPoint(x: 280, y: 25), control: CGPoint(x: 245, y: 20))
                }
                .stroke(AppColors.recovery.opacity(0.6), lineWidth: 2)
            }
            .frame(height: 80)

            HStack {
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 1).fill(AppColors.recovery.opacity(0.6)).frame(width: 16, height: 2)
                        Text("HRV").font(.system(size: 9)).foregroundColor(AppColors.mutedForeground)
                    }
                    HStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 1)
                            .fill(LinearGradient(colors: [Color(hex: "#8B5CF6"), AppColors.recovery], startPoint: .leading, endPoint: .trailing))
                            .frame(width: 16, height: 4)
                        Text("Slope").font(.system(size: 9)).foregroundColor(AppColors.mutedForeground)
                    }
                }
                Spacer()
                Text("Avg: 58 ms")
                    .font(.system(size: 10))
                    .foregroundColor(AppColors.mutedForeground)
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Heart Rate Graph
    private var heartRateGraphSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Heart Rate")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.foreground)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 10))
                    Text("RHR: 48 bpm")
                        .font(.system(size: 10, weight: .medium))
                }
                .foregroundColor(AppColors.heartRate)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(AppColors.heartRate.opacity(0.15))
                .clipShape(Capsule())
            }

            // Heart rate graph with RHR marker
            ZStack {
                // RHR line
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 50))
                    path.addLine(to: CGPoint(x: 280, y: 50))
                }
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
                .foregroundColor(AppColors.heartRate.opacity(0.3))

                // HR line
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 30))
                    path.addQuadCurve(to: CGPoint(x: 70, y: 45), control: CGPoint(x: 35, y: 35))
                    path.addQuadCurve(to: CGPoint(x: 140, y: 50), control: CGPoint(x: 105, y: 55))
                    path.addQuadCurve(to: CGPoint(x: 210, y: 40), control: CGPoint(x: 175, y: 48))
                    path.addQuadCurve(to: CGPoint(x: 280, y: 35), control: CGPoint(x: 245, y: 30))
                }
                .stroke(AppColors.heartRate.opacity(0.7), lineWidth: 2)

                // RHR marker
                Circle()
                    .fill(AppColors.heartRate)
                    .frame(width: 8, height: 8)
                    .overlay(Circle().fill(AppColors.heartRate.opacity(0.2)).frame(width: 16, height: 16))
                    .offset(x: 0, y: 20)
            }
            .frame(height: 80)

            HStack {
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 1).fill(AppColors.heartRate.opacity(0.7)).frame(width: 16, height: 2)
                        Text("HR").font(.system(size: 9)).foregroundColor(AppColors.mutedForeground)
                    }
                    HStack(spacing: 4) {
                        Circle().fill(AppColors.heartRate).frame(width: 6, height: 6)
                        Text("Lowest (RHR)").font(.system(size: 9)).foregroundColor(AppColors.mutedForeground)
                    }
                }
                Spacer()
                Text("Avg: 54 bpm")
                    .font(.system(size: 10))
                    .foregroundColor(AppColors.mutedForeground)
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Recovery Trends
    private var recoveryTrendsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recovery Trends")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.foreground)
                Spacer()

                HStack(spacing: 4) {
                    ForEach(["day", "week", "month"], id: \.self) { filter in
                        Button(action: { selectedTimeFilter = filter }) {
                            Text(filter.capitalized)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(selectedTimeFilter == filter ? .white : AppColors.mutedForeground)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(selectedTimeFilter == filter ? Color(hex: "#8B5CF6") : Color.clear)
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(4)
                .background(AppColors.border.opacity(0.5))
                .clipShape(Capsule())
            }

            // Bar chart
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(["M", "T", "W", "T", "F", "S", "S"], id: \.self) { day in
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                day == "S" && day == "S" ?
                                LinearGradient(colors: [Color(hex: "#8B5CF6"), Color(hex: "#0EA5E9")], startPoint: .top, endPoint: .bottom) :
                                LinearGradient(colors: [Color(hex: "#8B5CF6").opacity(0.85)], startPoint: .top, endPoint: .bottom)
                            )
                            .frame(width: 28, height: CGFloat.random(in: 40...80))
                        Text(day)
                            .font(.system(size: 8))
                            .foregroundColor(AppColors.mutedForeground)
                    }
                }
            }
            .frame(height: 100)

            HStack {
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Text("Avg:").font(.system(size: 12)).foregroundColor(AppColors.mutedForeground)
                        Text("78").font(.system(size: 14, weight: .semibold)).foregroundColor(AppColors.foreground)
                    }
                    HStack(spacing: 4) {
                        Text("Best:").font(.system(size: 12)).foregroundColor(AppColors.mutedForeground)
                        Text("92").font(.system(size: 14, weight: .semibold)).foregroundColor(Color(hex: "#8B5CF6"))
                    }
                }
                Spacer()
                Text("↑ +5 vs last week")
                    .font(.system(size: 10))
                    .foregroundColor(Color(hex: "#8B5CF6"))
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Recovery Debt
    private var recoveryDebtSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recovery Debt")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.foreground)

            HStack {
                HStack(spacing: 12) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#8B5CF6"))
                        .frame(width: 40, height: 40)
                        .background(Color(hex: "#8B5CF6").opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 2) {
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("3.4")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(AppColors.foreground)
                            Text("days")
                                .font(.system(size: 14))
                                .foregroundColor(AppColors.mutedForeground)
                        }
                        Text("accumulated this week")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.mutedForeground)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Elevated")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.heartRate)
                    Text("debt level")
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.mutedForeground)
                }
            }

            // Debt bars
            HStack(alignment: .bottom, spacing: 12) {
                ForEach([("M", 0.4, false), ("T", 0.2, false), ("W", 2.1, true), ("T", 0.6, false), ("F", 1.7, true), ("S", 0.4, false), ("S", 0.15, false)], id: \.0) { day, debt, isHigh in
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(isHigh ? LinearGradient(colors: [AppColors.heartRate, AppColors.heartRate.opacity(0.45)], startPoint: .top, endPoint: .bottom) : LinearGradient(colors: [AppColors.primary.opacity(0.25)], startPoint: .top, endPoint: .bottom))
                            .frame(width: 12, height: max(CGFloat(debt) * 40, 4))
                        Text(day)
                            .font(.system(size: 9))
                            .foregroundColor(AppColors.mutedForeground)
                    }
                }
            }
            .frame(height: 100)

            Text("Great recovery consistency! Keep your training load balanced to maintain low debt.")
                .font(.system(size: 12))
                .foregroundColor(AppColors.mutedForeground)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Personalized Factors
    private var personalizedFactorsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Your Factors Affecting Recovery")
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

                    ForEach(["Quality sleep > 7hrs", "Active recovery days", "Low stress periods", "Proper hydration"], id: \.self) { factor in
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

                    ForEach(["High training load", "Poor sleep quality", "Elevated stress"], id: \.self) { factor in
                        FactorChip(text: factor, isPositive: false)
                    }
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Recovery Contributor Card
struct RecoveryContributorCard: View {
    let contributor: RecoveryContributor
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: 0) {
            Button(action: { withAnimation(.spring(response: 0.3)) { isExpanded.toggle() } }) {
                HStack(spacing: 12) {
                    Image(systemName: contributor.icon)
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#8B5CF6"))
                        .frame(width: 40, height: 40)
                        .background(Color(hex: "#8B5CF6").opacity(0.15))
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
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.25 : 0.02), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    NavigationStack {
        RecoveryDetailsView()
    }
}
