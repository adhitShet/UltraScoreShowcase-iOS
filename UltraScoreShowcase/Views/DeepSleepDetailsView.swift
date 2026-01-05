import SwiftUI

struct DeepSleepDetailsView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var animatedDeepSleep: Double = 0
    @State private var showContent = false
    @State private var selectedTimeRange = "week"
    @State private var showStudies = false

    let currentDeepSleep = 22
    let optimalMin = 20
    let optimalMax = 25

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Main Deep Sleep Display
                deepSleepDisplaySection

                // Trends Section
                trendsSection

                // Interpretation Section
                interpretationSection

                // FAQs Section
                faqsSection

                // Population Distribution
                populationSection

                // Factors Section
                factorsSection

                // Scientific Studies
                studiesSection
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
                Text("Deep Sleep")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.5)) {
                animatedDeepSleep = Double(currentDeepSleep)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.6)) {
                    showContent = true
                }
            }
        }
    }

    // MARK: - Deep Sleep Display Section
    private var deepSleepDisplaySection: some View {
        VStack(spacing: 16) {
            // Label
            HStack(spacing: 4) {
                Image(systemName: "bed.double.fill")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#8B5CF6"))
                Text("DEEP SLEEP")
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(1)
                    .foregroundColor(AppColors.mutedForeground)
            }

            // Circular progress display
            ZStack {
                // Background circle
                Circle()
                    .stroke(AppColors.border.opacity(0.3), lineWidth: 8)
                    .frame(width: 140, height: 140)

                // Progress arc
                Circle()
                    .trim(from: 0, to: animatedDeepSleep / 40)
                    .stroke(
                        Color(hex: "#8B5CF6"),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))

                // Center content
                VStack(spacing: 2) {
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text("\(Int(animatedDeepSleep))")
                            .font(.system(size: 44, weight: .light))
                            .foregroundColor(AppColors.foreground)
                            .contentTransition(.numericText())
                        Text("%")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(AppColors.mutedForeground)
                    }
                    Text("of total sleep")
                        .font(.system(size: 11))
                        .foregroundColor(AppColors.mutedForeground)
                }
            }

            // Status badge
            let isOptimal = currentDeepSleep >= optimalMin && currentDeepSleep <= optimalMax
            Text(isOptimal ? "Within optimal range (\(optimalMin)-\(optimalMax)%)" : currentDeepSleep < optimalMin ? "Below optimal" : "Above optimal")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(isOptimal ? AppColors.recovery : Color.orange)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background((isOptimal ? AppColors.recovery : Color.orange).opacity(0.2))
                .clipShape(Capsule())
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 12, x: 0, y: 4)
    }

    // MARK: - Trends Section
    private var trendsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Deep Sleep Trends")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
                Spacer()
                DeepSleepTimeRangePicker(selected: $selectedTimeRange)
            }

            // Bar chart
            DeepSleepTrendChart(timeRange: selectedTimeRange)
                .frame(height: 160)

            // Legend
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color(hex: "#8B5CF6").opacity(0.7))
                        .frame(width: 12, height: 12)
                    Text("Deep Sleep %")
                        .font(.system(size: 11))
                        .foregroundColor(AppColors.mutedForeground)
                }
                HStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 1)
                        .fill(AppColors.movement)
                        .frame(width: 16, height: 2)
                    Text("Trend")
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

    // MARK: - Interpretation Section
    private var interpretationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "info.circle")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#8B5CF6"))
                Text("Understanding Deep Sleep %")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
            }

            // Range visualization
            GeometryReader { geometry in
                let width = geometry.size.width

                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.border.opacity(0.3))

                    // Too low zone
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [AppColors.heartRate.opacity(0.3), AppColors.movement.opacity(0.3)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: width * 0.5)

                    // Optimal zone
                    Rectangle()
                        .fill(AppColors.recovery.opacity(0.4))
                        .frame(width: width * 0.125)
                        .offset(x: width * 0.5)

                    // Too high zone
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [AppColors.movement.opacity(0.3), AppColors.heartRate.opacity(0.3)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: width * 0.375)
                        .offset(x: width * 0.625)

                    // Current position marker
                    let currentPos = CGFloat(currentDeepSleep) / 40 * width
                    Circle()
                        .fill(Color(hex: "#8B5CF6"))
                        .frame(width: 16, height: 16)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .shadow(radius: 2)
                        .offset(x: currentPos - 8, y: 12)
                }
                .frame(height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .frame(height: 40)

            // Labels
            HStack {
                Text("Too Low")
                    .font(.system(size: 9))
                    .foregroundColor(AppColors.mutedForeground)
                Spacer()
                Text("\(optimalMin)-\(optimalMax)%")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(AppColors.recovery)
                Spacer()
                Text("Very High")
                    .font(.system(size: 9))
                    .foregroundColor(AppColors.mutedForeground)
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - FAQs Section
    private var faqsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "questionmark.circle")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#8B5CF6"))
                Text("Frequently Asked Questions")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
            }

            VStack(spacing: 8) {
                FAQItem(
                    question: "What is Deep Sleep?",
                    answer: "Deep sleep (slow-wave sleep) is the most restorative sleep stage. Your brain produces delta waves, heart rate and breathing slow significantly, and your body focuses on physical recovery and immune function."
                )
                FAQItem(
                    question: "How much deep sleep do I need?",
                    answer: "Adults typically need 1-2 hours of deep sleep per night, representing 15-25% of total sleep. This decreases naturally with age."
                )
                FAQItem(
                    question: "How can I improve deep sleep?",
                    answer: "Exercise regularly (but not close to bedtime), maintain a cool bedroom (65-68°F), avoid alcohol and screens before bed, and keep a consistent sleep schedule."
                )
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Population Section
    private var populationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "person.3.fill")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#8B5CF6"))
                Text("Where You Stand")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
            }

            // Bell curve
            DeepSleepBellCurve(currentValue: currentDeepSleep)
                .frame(height: 120)

            // Percentile card
            HStack {
                Text("Your percentile")
                    .font(.system(size: 13))
                    .foregroundColor(AppColors.mutedForeground)
                Spacer()
                Text("Top 30%")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppColors.recovery)
            }
            .padding(12)
            .background(AppColors.background)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Text("Your deep sleep of \(currentDeepSleep)% is better than 70% of people in your age group.")
                .font(.system(size: 11))
                .foregroundColor(AppColors.mutedForeground)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Factors Section
    private var factorsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Factors Affecting Deep Sleep")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppColors.foreground)

            HStack(alignment: .top, spacing: 12) {
                // Positive factors
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 12))
                        Text("Improving")
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundColor(AppColors.recovery)

                    FactorCard(factor: "No alcohol last night", impact: "+3% deep sleep", isPositive: true)
                    FactorCard(factor: "Cool bedroom temp", impact: "Optimal conditions", isPositive: true)
                    FactorCard(factor: "Regular exercise", impact: "Increased slow waves", isPositive: true)
                }

                // Negative factors
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.down.right")
                            .font(.system(size: 12))
                        Text("Limiting")
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundColor(AppColors.heartRate)

                    FactorCard(factor: "Late caffeine", impact: "-2% deep sleep", isPositive: false)
                    FactorCard(factor: "Screen time before bed", impact: "Delayed onset", isPositive: false)
                    FactorCard(factor: "Irregular schedule", impact: "Disrupted rhythm", isPositive: false)
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Studies Section
    private var studiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: { withAnimation { showStudies.toggle() } }) {
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "book.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                        Text("Scientific Studies")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppColors.foreground)
                    }
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)
                        .rotationEffect(.degrees(showStudies ? 180 : 0))
                }
            }

            if showStudies {
                VStack(spacing: 10) {
                    StudyCard(
                        title: "Deep Sleep and Memory Consolidation",
                        source: "Nature Neuroscience, 2019",
                        finding: "Deep sleep is critical for memory consolidation and clearing metabolic waste from the brain."
                    )
                    StudyCard(
                        title: "Slow-Wave Sleep and Growth Hormone",
                        source: "Journal of Clinical Endocrinology, 2020",
                        finding: "70% of daily growth hormone is released during deep sleep, essential for tissue repair."
                    )
                    StudyCard(
                        title: "Deep Sleep and Immune Function",
                        source: "Sleep Medicine Reviews, 2021",
                        finding: "Adequate deep sleep enhances immune response and reduces inflammation markers."
                    )
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Supporting Views

struct DeepSleepTimeRangePicker: View {
    @Binding var selected: String
    private let options = ["day", "week", "month"]

    var body: some View {
        HStack(spacing: 4) {
            ForEach(options, id: \.self) { option in
                Button(action: { selected = option }) {
                    Text(option.capitalized)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(selected == option ? .white : AppColors.mutedForeground)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(selected == option ? Color(hex: "#8B5CF6") : Color.clear)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(4)
        .background(AppColors.border.opacity(0.3))
        .clipShape(Capsule())
    }
}

struct DeepSleepTrendChart: View {
    let timeRange: String

    private var data: [(String, Int)] {
        switch timeRange {
        case "day":
            return [("Sat", 21), ("Sun", 24), ("Mon", 18), ("Tue", 22), ("Wed", 20), ("Thu", 23), ("Fri", 22)]
        case "week":
            return [("W1", 20), ("W2", 22), ("W3", 19), ("W4", 21), ("W5", 23), ("W6", 20), ("W7", 22), ("W8", 22)]
        default:
            return [("Jul", 19), ("Aug", 20), ("Sep", 21), ("Oct", 20), ("Nov", 22), ("Dec", 22)]
        }
    }

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let barWidth = width / CGFloat(data.count) - 8

            HStack(alignment: .bottom, spacing: 8) {
                ForEach(data, id: \.0) { label, value in
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: "#8B5CF6").opacity(0.7))
                            .frame(width: barWidth, height: CGFloat(value) / 40 * (height - 20))

                        Text(label)
                            .font(.system(size: 9))
                            .foregroundColor(AppColors.mutedForeground)
                    }
                }
            }
        }
    }
}

struct DeepSleepBellCurve: View {
    let currentValue: Int

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height

            ZStack {
                // Bell curve shape
                Path { path in
                    let points = 50
                    for i in 0...points {
                        let x = CGFloat(i) / CGFloat(points) * width
                        let normalizedX = (CGFloat(i) / CGFloat(points) - 0.5) * 4
                        let y = height - exp(-normalizedX * normalizedX / 2) * height * 0.8
                        if i == 0 {
                            path.move(to: CGPoint(x: x, y: height))
                            path.addLine(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                    path.addLine(to: CGPoint(x: width, y: height))
                    path.closeSubpath()
                }
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#8B5CF6").opacity(0.5), Color(hex: "#8B5CF6").opacity(0.1)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

                // Current position marker
                let currentPos = CGFloat(currentValue) / 40 * width
                VStack(spacing: 2) {
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.system(size: 10))
                        .foregroundColor(Color(hex: "#8B5CF6"))
                    Text("You")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(Color(hex: "#8B5CF6"))
                }
                .position(x: currentPos, y: 20)
            }
        }
    }
}

#Preview {
    NavigationStack {
        DeepSleepDetailsView()
    }
}
