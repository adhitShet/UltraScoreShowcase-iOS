import SwiftUI

struct VO2MaxDetailsView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var animatedVO2: Double = 0
    @State private var showContent = false
    @State private var selectedTimeRange = "month"
    @State private var showStudies = false

    let currentVO2Max = 42
    let previousVO2Max = 40

    private var change: Int { currentVO2Max - previousVO2Max }

    private var fitnessZones: [(label: String, min: Int, max: Int, color: Color)] {
        [
            ("Very Poor", 0, 28, Color.red),
            ("Poor", 28, 35, Color.orange),
            ("Fair", 35, 42, Color.yellow),
            ("Good", 42, 50, AppColors.recovery),
            ("Excellent", 50, 58, Color.teal),
            ("Superior", 58, 70, Color.blue)
        ]
    }

    private var currentZone: (label: String, min: Int, max: Int, color: Color) {
        fitnessZones.first { currentVO2Max >= $0.min && currentVO2Max < $0.max } ?? fitnessZones[3]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Main VO2 Display
                vo2DisplaySection

                // Trends Section
                trendsSection

                // Fitness Level Scale
                fitnessScaleSection

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
                Text("VO2 Max")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.5)) {
                animatedVO2 = Double(currentVO2Max)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.6)) {
                    showContent = true
                }
            }
        }
    }

    // MARK: - VO2 Display Section
    private var vo2DisplaySection: some View {
        VStack(spacing: 16) {
            // Label
            HStack(spacing: 4) {
                Image(systemName: "wind")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.movement)
                Text("VO2 MAX")
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
                    .trim(from: 0, to: animatedVO2 / 70)
                    .stroke(
                        LinearGradient(
                            colors: [AppColors.movement, AppColors.recovery],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))

                // Center content
                VStack(spacing: 2) {
                    Text("\(Int(animatedVO2))")
                        .font(.system(size: 44, weight: .light))
                        .foregroundColor(AppColors.foreground)
                        .contentTransition(.numericText())
                    Text("ml/kg/min")
                        .font(.system(size: 11))
                        .foregroundColor(AppColors.mutedForeground)
                }
            }

            // Change indicator
            HStack(spacing: 8) {
                Text(change > 0 ? "+\(change)" : "\(change)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(change > 0 ? AppColors.recovery : change < 0 ? AppColors.heartRate : AppColors.mutedForeground)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background((change > 0 ? AppColors.recovery : change < 0 ? AppColors.heartRate : AppColors.border).opacity(0.2))
                    .clipShape(Capsule())

                Text("from last month")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mutedForeground)
            }

            // Fitness level badge
            Text("\(currentZone.label) Fitness Level")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    LinearGradient(
                        colors: [currentZone.color, currentZone.color.opacity(0.7)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
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
                Text("VO2 Max Trends")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
                Spacer()
                VO2TimeRangePicker(selected: $selectedTimeRange)
            }

            // Bar chart
            VO2TrendChart(timeRange: selectedTimeRange)
                .frame(height: 160)

            // Legend
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(AppColors.movement.opacity(0.7))
                        .frame(width: 12, height: 12)
                    Text("VO2 Max")
                        .font(.system(size: 11))
                        .foregroundColor(AppColors.mutedForeground)
                }
                HStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 1)
                        .fill(AppColors.recovery)
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

    // MARK: - Fitness Scale Section
    private var fitnessScaleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "info.circle")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.movement)
                Text("Fitness Level Scale")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
            }

            Text("VO2 Max values are categorized by age and gender. Here's where you stand for your demographic.")
                .font(.system(size: 13))
                .foregroundColor(AppColors.mutedForeground)
                .lineSpacing(4)

            // Scale visualization
            GeometryReader { geometry in
                let width = geometry.size.width
                ZStack(alignment: .leading) {
                    HStack(spacing: 0) {
                        ForEach(fitnessZones, id: \.label) { zone in
                            Rectangle()
                                .fill(zone.color)
                                .frame(width: CGFloat(zone.max - zone.min) / 70 * width)
                        }
                    }
                    .frame(height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                    // Current position marker
                    let currentPos = CGFloat(currentVO2Max) / 70 * width
                    Circle()
                        .fill(Color.white)
                        .frame(width: 20, height: 20)
                        .overlay(
                            Circle()
                                .fill(currentZone.color)
                                .frame(width: 12, height: 12)
                        )
                        .shadow(radius: 2)
                        .offset(x: currentPos - 10, y: 10)
                }
            }
            .frame(height: 40)

            // Zone labels
            HStack {
                ForEach(fitnessZones, id: \.label) { zone in
                    Text(zone.label)
                        .font(.system(size: 8))
                        .foregroundColor(AppColors.mutedForeground)
                        .frame(maxWidth: .infinity)
                }
            }

            // Current status
            HStack(alignment: .top, spacing: 8) {
                Circle()
                    .fill(AppColors.movement)
                    .frame(width: 8, height: 8)
                    .offset(y: 4)

                VStack(alignment: .leading, spacing: 4) {
                    Text("\(currentZone.label) cardiovascular fitness")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(AppColors.movement)

                    Text("Your VO2 Max of \(currentVO2Max) ml/kg/min places you in the \(currentZone.label.lowercased()) category. \(currentVO2Max < 50 ? "Aim for \(currentZone.max)+ to reach the next level." : "You're performing above average!")")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)
                        .lineSpacing(3)
                }
            }
            .padding(12)
            .background(AppColors.movement.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
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
                    .foregroundColor(AppColors.movement)
                Text("Frequently Asked Questions")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
            }

            VStack(spacing: 8) {
                FAQItem(
                    question: "What is VO2 Max?",
                    answer: "VO2 Max measures the maximum amount of oxygen your body can use during intense exercise. It's considered the gold standard for measuring cardiovascular fitness and aerobic endurance."
                )
                FAQItem(
                    question: "How is VO2 Max measured?",
                    answer: "Your device estimates VO2 Max using heart rate data during activities. Lab tests measure it directly during maximal exercise on a treadmill or bike with a breathing mask."
                )
                FAQItem(
                    question: "How can I improve my VO2 Max?",
                    answer: "High-intensity interval training (HIIT), consistent aerobic exercise, and progressive overload are most effective. Even 2-3 sessions per week can improve VO2 Max by 10-20% over months."
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
                    .foregroundColor(AppColors.movement)
                Text("Where You Stand")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
            }

            Text("See how your VO2 Max compares to the general population.")
                .font(.system(size: 13))
                .foregroundColor(AppColors.mutedForeground)

            // Bell curve
            VO2BellCurveChart(currentValue: currentVO2Max)
                .frame(height: 120)

            // Percentile card
            HStack {
                Text("Your percentile")
                    .font(.system(size: 13))
                    .foregroundColor(AppColors.mutedForeground)
                Spacer()
                Text("Top 40%")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppColors.recovery)
            }
            .padding(12)
            .background(AppColors.background)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Text("Your VO2 Max of \(currentVO2Max) ml/kg/min is better than 60% of people in your age group.")
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
            Text("Your Factors Affecting VO2 Max")
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

                    FactorCard(factor: "Consistent cardio training", impact: "+2 ml/kg/min", isPositive: true)
                    FactorCard(factor: "HIIT sessions this week", impact: "Building capacity", isPositive: true)
                    FactorCard(factor: "Good sleep quality", impact: "Optimal recovery", isPositive: true)
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

                    FactorCard(factor: "Sedentary days", impact: "-0.5 ml/kg/min", isPositive: false)
                    FactorCard(factor: "Altitude change", impact: "Temporary drop", isPositive: false)
                    FactorCard(factor: "Recent illness", impact: "Recovery needed", isPositive: false)
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
                        title: "VO2 Max and Longevity",
                        source: "JAMA Network Open, 2022",
                        finding: "Each 1 ml/kg/min increase in VO2 max is associated with a 2-3% reduction in all-cause mortality."
                    )
                    StudyCard(
                        title: "Cardiorespiratory Fitness",
                        source: "Circulation, 2016",
                        finding: "Low cardiorespiratory fitness is a stronger predictor of mortality than smoking, diabetes, or hypertension."
                    )
                    StudyCard(
                        title: "VO2 Max and Cognitive Health",
                        source: "Neurology, 2021",
                        finding: "Higher VO2 max is associated with better cognitive function and reduced dementia risk in older adults."
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

struct VO2TimeRangePicker: View {
    @Binding var selected: String
    private let options = ["week", "month", "year"]

    var body: some View {
        HStack(spacing: 4) {
            ForEach(options, id: \.self) { option in
                Button(action: { selected = option }) {
                    Text(option.capitalized)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(selected == option ? .white : AppColors.mutedForeground)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(selected == option ? AppColors.movement : Color.clear)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(4)
        .background(AppColors.border.opacity(0.3))
        .clipShape(Capsule())
    }
}

struct VO2TrendChart: View {
    let timeRange: String

    private var data: [(String, Int)] {
        switch timeRange {
        case "week":
            return [("W1", 40), ("W2", 40), ("W3", 41), ("W4", 40), ("W5", 41), ("W6", 42), ("W7", 41), ("W8", 42)]
        case "year":
            return [("Jan", 36), ("Mar", 37), ("May", 38), ("Jul", 38), ("Sep", 40), ("Nov", 41), ("Dec", 42)]
        default:
            return [("Jul", 38), ("Aug", 39), ("Sep", 40), ("Oct", 40), ("Nov", 41), ("Dec", 42)]
        }
    }

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let barWidth = width / CGFloat(data.count) - 8
            let minVal = (data.map { $0.1 }.min() ?? 35) - 5
            let maxVal = (data.map { $0.1 }.max() ?? 45) + 5

            HStack(alignment: .bottom, spacing: 8) {
                ForEach(data, id: \.0) { label, value in
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppColors.movement.opacity(0.7))
                            .frame(width: barWidth, height: CGFloat(value - minVal) / CGFloat(maxVal - minVal) * (height - 20))

                        Text(label)
                            .font(.system(size: 9))
                            .foregroundColor(AppColors.mutedForeground)
                    }
                }
            }
        }
    }
}

struct VO2BellCurveChart: View {
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
                        colors: [AppColors.movement.opacity(0.5), AppColors.movement.opacity(0.1)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

                // Current position marker
                let currentPos = CGFloat(currentValue - 20) / 50 * width
                VStack(spacing: 2) {
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.movement)
                    Text("You")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(AppColors.movement)
                }
                .position(x: currentPos, y: 20)
            }
        }
    }
}

#Preview {
    NavigationStack {
        VO2MaxDetailsView()
    }
}
