import SwiftUI

struct RHRDetailsView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var animatedRHR: Double = 0
    @State private var showContent = false
    @State private var selectedTimeRange = "week"
    @State private var showStudies = false

    let currentRHR = 58
    let baseline = 55

    private var status: String {
        if currentRHR > baseline { return "above" }
        if currentRHR < baseline { return "below" }
        return "at"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Main RHR Display
                rhrDisplaySection

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
                Text("Resting Heart Rate")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.5)) {
                animatedRHR = Double(currentRHR)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.6)) {
                    showContent = true
                }
            }
        }
    }

    // MARK: - RHR Display Section
    private var rhrDisplaySection: some View {
        VStack(spacing: 16) {
            // Label
            HStack(spacing: 4) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.heartRate)
                Text("RESTING HEART RATE")
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(1)
                    .foregroundColor(AppColors.mutedForeground)
            }

            // Heart-themed display
            ZStack {
                // Pulse rings
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .stroke(AppColors.heartRate.opacity(0.3), lineWidth: 1)
                        .frame(width: 120 + CGFloat(i) * 30, height: 120 + CGFloat(i) * 30)
                        .scaleEffect(showContent ? 1.1 : 1.0)
                        .opacity(showContent ? 0.3 : 0.5)
                        .animation(
                            .easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.3),
                            value: showContent
                        )
                }

                // Inner circle with value
                VStack(spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text("\(Int(animatedRHR))")
                            .font(.system(size: 48, weight: .light))
                            .foregroundColor(AppColors.foreground)
                            .contentTransition(.numericText())
                        Text("bpm")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppColors.mutedForeground)
                    }
                    Text("RHR")
                        .font(.system(size: 10, weight: .semibold))
                        .tracking(2)
                        .foregroundColor(AppColors.heartRate)
                }
            }
            .frame(height: 180)

            // Baseline comparison
            HStack(spacing: 8) {
                Text("Baseline: \(baseline) bpm")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mutedForeground)

                Text("•")
                    .foregroundColor(AppColors.border)

                Text(status == "above" ? "\(currentRHR - baseline) bpm above" :
                     status == "below" ? "\(baseline - currentRHR) bpm below" : "At baseline")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(status == "above" ? AppColors.heartRate :
                                    status == "below" ? AppColors.recovery : AppColors.movement)
            }
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
                Text("RHR Trends")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
                Spacer()
                TimeRangePicker(selected: $selectedTimeRange)
            }

            // Bar chart
            RHRTrendChart(timeRange: selectedTimeRange)
                .frame(height: 160)

            // Legend
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(AppColors.heartRate.opacity(0.7))
                        .frame(width: 12, height: 12)
                    Text(selectedTimeRange == "day" ? "Daily Avg" :
                         selectedTimeRange == "week" ? "Weekly Avg" : "Monthly Avg")
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
        let typicalMin = 52
        let typicalMax = 60
        let isInZone = currentRHR >= typicalMin && currentRHR <= typicalMax
        let isBelow = currentRHR < typicalMin

        return VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "info.circle")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.heartRate)
                Text("How to Interpret Your RHR")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
            }

            Text("Your typical RHR range is based on your readings over the last few weeks. Lower is generally better for cardiovascular health.")
                .font(.system(size: 13))
                .foregroundColor(AppColors.mutedForeground)
                .lineSpacing(4)

            // Range visualization
            RHRRangeVisualization(currentRHR: currentRHR, typicalMin: typicalMin, typicalMax: typicalMax)
                .frame(height: 50)

            // Interpretation result
            HStack(alignment: .top, spacing: 8) {
                Circle()
                    .fill(isBelow ? AppColors.recovery : isInZone ? AppColors.movement : AppColors.heartRate)
                    .frame(width: 8, height: 8)
                    .offset(y: 4)

                VStack(alignment: .leading, spacing: 4) {
                    Text(isBelow ? "Below typical - excellent cardiovascular fitness!" :
                         isInZone ? "Within your typical range" : "Above your typical range")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(isBelow ? AppColors.recovery : isInZone ? AppColors.movement : AppColors.heartRate)

                    Text(isBelow ? "Your heart is working very efficiently. This is a sign of great cardiovascular health." :
                         isInZone ? "Your RHR is stable and within expected bounds. Keep up your healthy habits." :
                         "Consider factors like stress, caffeine, or sleep quality that may be elevating your RHR.")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)
                        .lineSpacing(3)
                }
            }
            .padding(12)
            .background((isBelow ? AppColors.recovery : isInZone ? AppColors.movement : AppColors.heartRate).opacity(0.1))
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
                    question: "What is Resting Heart Rate?",
                    answer: "Resting Heart Rate (RHR) is the number of times your heart beats per minute when you're at complete rest. It's a key indicator of cardiovascular fitness and overall heart health."
                )
                FAQItem(
                    question: "What's a healthy RHR range?",
                    answer: "For most adults, a normal RHR ranges from 60-100 bpm. Athletes often have lower RHRs (40-60 bpm) due to their heart's increased efficiency."
                )
                FAQItem(
                    question: "How can I lower my RHR?",
                    answer: "Regular aerobic exercise, stress management, adequate sleep, staying hydrated, and avoiding excessive caffeine and alcohol can help lower your RHR over time."
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
                    .foregroundColor(AppColors.heartRate)
                Text("Where You Stand")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
            }

            Text("See how your RHR compares to the general population.")
                .font(.system(size: 13))
                .foregroundColor(AppColors.mutedForeground)

            // Bell curve placeholder
            BellCurveChart(currentValue: currentRHR, minValue: 40, maxValue: 100)
                .frame(height: 120)

            // Percentile card
            HStack {
                Text("Your percentile")
                    .font(.system(size: 13))
                    .foregroundColor(AppColors.mutedForeground)
                Spacer()
                Text("Top 35%")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppColors.recovery)
            }
            .padding(12)
            .background(AppColors.background)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Text("Your RHR of \(currentRHR) bpm is better than 65% of people in your age group.")
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
            Text("Your Factors Affecting RHR")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppColors.foreground)

            HStack(alignment: .top, spacing: 12) {
                // Positive factors
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.down.right")
                            .font(.system(size: 12))
                        Text("Lowering RHR")
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundColor(AppColors.recovery)

                    FactorCard(factor: "Morning walk", impact: "+3 bpm lower", isPositive: true)
                    FactorCard(factor: "Good sleep last night", impact: "Optimal recovery", isPositive: true)
                    FactorCard(factor: "Low caffeine intake", impact: "Stable rhythm", isPositive: true)
                }

                // Negative factors
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 12))
                        Text("Raising RHR")
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundColor(AppColors.heartRate)

                    FactorCard(factor: "Mild dehydration", impact: "+2 bpm higher", isPositive: false)
                    FactorCard(factor: "Elevated stress", impact: "Slightly elevated", isPositive: false)
                    FactorCard(factor: "Late dinner", impact: "Delayed recovery", isPositive: false)
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
                        title: "RHR and Cardiovascular Health",
                        source: "New England Journal of Medicine, 2005",
                        finding: "Higher resting heart rates are associated with increased cardiovascular mortality risk."
                    )
                    StudyCard(
                        title: "RHR and Fitness Level",
                        source: "Mayo Clinic Proceedings, 2015",
                        finding: "Lower RHR correlates with better cardiovascular fitness and longevity outcomes."
                    )
                    StudyCard(
                        title: "RHR and All-Cause Mortality",
                        source: "Heart Journal, 2018",
                        finding: "Each 10 bpm increase in RHR is linked to a 16% higher risk of all-cause mortality."
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

struct TimeRangePicker: View {
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
                        .background(selected == option ? AppColors.heartRate : Color.clear)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(4)
        .background(AppColors.border.opacity(0.3))
        .clipShape(Capsule())
    }
}

struct RHRTrendChart: View {
    let timeRange: String

    private var data: [(String, Int)] {
        switch timeRange {
        case "day":
            return [("Sat", 54), ("Sun", 52), ("Mon", 56), ("Tue", 55), ("Wed", 58), ("Thu", 57), ("Fri", 58)]
        case "week":
            return [("W1", 54), ("W2", 55), ("W3", 53), ("W4", 56), ("W5", 55), ("W6", 54), ("W7", 57), ("W8", 58)]
        default:
            return [("Jul", 56), ("Aug", 55), ("Sep", 54), ("Oct", 55), ("Nov", 56), ("Dec", 58)]
        }
    }

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let barWidth = width / CGFloat(data.count) - 8
            let minVal = (data.map { $0.1 }.min() ?? 50) - 5
            let maxVal = (data.map { $0.1 }.max() ?? 60) + 5

            HStack(alignment: .bottom, spacing: 8) {
                ForEach(data, id: \.0) { label, value in
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppColors.heartRate.opacity(0.7))
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

struct RHRRangeVisualization: View {
    let currentRHR: Int
    let typicalMin: Int
    let typicalMax: Int

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let minBpm = 40
            let maxBpm = 100
            let range = maxBpm - minBpm

            let typicalMinPos = CGFloat(typicalMin - minBpm) / CGFloat(range) * width
            let typicalMaxPos = CGFloat(typicalMax - minBpm) / CGFloat(range) * width
            let currentPos = CGFloat(currentRHR - minBpm) / CGFloat(range) * width

            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColors.border.opacity(0.3))

                // Below zone (green)
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.recovery.opacity(0.4), AppColors.movement.opacity(0.2)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: typicalMinPos)

                // Normal zone (blue)
                Rectangle()
                    .fill(AppColors.movement.opacity(0.4))
                    .frame(width: typicalMaxPos - typicalMinPos)
                    .offset(x: typicalMinPos)

                // Above zone (red)
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.heartRate.opacity(0.2), AppColors.heartRate.opacity(0.4)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: width - typicalMaxPos)
                    .offset(x: typicalMaxPos)

                // Current position marker
                Circle()
                    .fill(currentRHR < typicalMin ? AppColors.recovery :
                          currentRHR <= typicalMax ? AppColors.movement : AppColors.heartRate)
                    .frame(width: 16, height: 16)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .offset(x: currentPos - 8)
                    .shadow(radius: 2)
            }
            .frame(height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            // Labels
            HStack {
                Text("\(minBpm)")
                Spacer()
                Text("\(typicalMin)-\(typicalMax)")
                    .foregroundColor(AppColors.movement)
                    .fontWeight(.medium)
                Spacer()
                Text("\(maxBpm)")
            }
            .font(.system(size: 9))
            .foregroundColor(AppColors.mutedForeground)
            .offset(y: 44)
        }
    }
}

struct FAQItem: View {
    let question: String
    let answer: String
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack {
                    Text(question)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.foreground)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
            }

            if isExpanded {
                Text(answer)
                    .font(.system(size: 13))
                    .foregroundColor(AppColors.mutedForeground)
                    .lineSpacing(3)
            }
        }
        .padding(12)
        .background(AppColors.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct BellCurveChart: View {
    let currentValue: Int
    let minValue: Int
    let maxValue: Int

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
                        colors: [AppColors.heartRate.opacity(0.5), AppColors.heartRate.opacity(0.1)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

                // Current position marker
                let currentPos = CGFloat(currentValue - minValue) / CGFloat(maxValue - minValue) * width
                VStack(spacing: 2) {
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.heartRate)
                    Text("You")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(AppColors.heartRate)
                }
                .position(x: currentPos, y: 20)
            }
        }
    }
}

struct FactorCard: View {
    let factor: String
    let impact: String
    let isPositive: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(factor)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(AppColors.foreground)
            Text(impact)
                .font(.system(size: 10))
                .foregroundColor(isPositive ? AppColors.recovery : AppColors.heartRate)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background((isPositive ? AppColors.recovery : AppColors.heartRate).opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct StudyCard: View {
    let title: String
    let source: String
    let finding: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.blue)
            Text(source)
                .font(.system(size: 10))
                .foregroundColor(AppColors.mutedForeground)
            Text(finding)
                .font(.system(size: 13))
                .foregroundColor(AppColors.foreground)
                .lineSpacing(3)
        }
        .padding(12)
        .background(AppColors.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack {
        RHRDetailsView()
    }
}
