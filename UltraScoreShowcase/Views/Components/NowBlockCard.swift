import SwiftUI

struct TimeWindow: Identifiable {
    let id = UUID()
    let label: String
    let icon: String
    let startHour: Int
    let endHour: Int
    let color: Color
}

struct NowBlockCard: View {
    @ObservedObject private var themeManager = ThemeManager.shared

    let heartRate: Int
    let stressLevel: String
    let steps: Int

    @State private var liveHeartRate: Int
    @State private var liveSteps: Int

    private let currentHour = 18 // 6pm for demo

    private let timeWindows: [TimeWindow] = [
        TimeWindow(label: "No Caffeine", icon: "cup.and.saucer.fill", startHour: 14, endHour: 22, color: AppColors.error),
        TimeWindow(label: "Golden Hour", icon: "sun.max.fill", startHour: 17, endHour: 19, color: AppColors.warning),
        TimeWindow(label: "Last Meal", icon: "fork.knife", startHour: 18, endHour: 20, color: AppColors.movement),
        TimeWindow(label: "Wind Down", icon: "moon.fill", startHour: 21, endHour: 23, color: AppColors.stress)
    ]

    private var activeWindows: [TimeWindow] {
        timeWindows.filter { currentHour >= $0.startHour && currentHour < $0.endHour }
    }

    init(heartRate: Int, stressLevel: String, steps: Int) {
        self.heartRate = heartRate
        self.stressLevel = stressLevel
        self.steps = steps
        self._liveHeartRate = State(initialValue: heartRate)
        self._liveSteps = State(initialValue: steps)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text("Now")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.foreground)

                Spacer()

                HStack(spacing: 4) {
                    Circle()
                        .fill(AppColors.recovery)
                        .frame(width: 8, height: 8)
                    Text("Live")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.recovery)
                }
            }

            // Metrics Grid
            HStack(spacing: 12) {
                // Heart Rate
                NavigationLink(destination: LiveHRDetailsView()) {
                    NowMetricCard(
                        icon: "heart.fill",
                        iconColor: AppColors.heartRate,
                        value: "\(liveHeartRate)",
                        unit: "bpm",
                        subtitle: "Zone 2",
                        subtitleColor: AppColors.zone
                    )
                }
                .buttonStyle(PlainButtonStyle())

                // Stress
                NowMetricCard(
                    icon: "brain.head.profile",
                    iconColor: AppColors.stress,
                    value: stressLevel,
                    unit: nil,
                    subtitle: "Stress",
                    subtitleColor: AppColors.mutedForeground
                )

                // Steps
                NavigationLink(destination: StepsDetailsView()) {
                    StepsNowMetricCard(steps: liveSteps)
                }
                .buttonStyle(PlainButtonStyle())
            }

            // Active Windows
            VStack(spacing: 12) {
                HStack {
                    Text("ACTIVE WINDOWS")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(AppColors.mutedForeground)
                        .tracking(0.5)

                    Spacer()

                    HStack(spacing: 4) {
                        Circle()
                            .fill(AppColors.recovery)
                            .frame(width: 6, height: 6)
                        Text("\(activeWindows.count) active")
                            .font(.system(size: 10))
                            .foregroundColor(AppColors.mutedForeground)
                    }
                }

                // Window pills
                FlowLayout(spacing: 8) {
                    ForEach(activeWindows) { window in
                        WindowPill(window: window, currentHour: currentHour)
                    }
                }

                // Timeline
                TimelineView(currentHour: currentHour, windows: timeWindows)
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(ThemeManager.shared.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
        }
        .onAppear {
            startLiveUpdates()
        }
    }

    private func startLiveUpdates() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                liveHeartRate = heartRate + Int.random(in: -2...2)
                if Double.random(in: 0...1) > 0.7 {
                    liveSteps += Int.random(in: 1...5)
                }
            }
        }
    }
}

struct NowMetricCard: View {
    let icon: String
    let iconColor: Color
    let value: String
    let unit: String?
    let subtitle: String
    let subtitleColor: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(iconColor)
                .frame(width: 40, height: 40)
                .background(iconColor.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(AppColors.foreground)
                    .contentTransition(.numericText())

                if let unit = unit {
                    Text(unit)
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.mutedForeground)
                }
            }

            Text(subtitle)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(subtitleColor)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(ThemeManager.shared.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }
}

struct StepsNowMetricCard: View {
    let steps: Int

    private let weekData = [
        (day: "M", achieved: true),
        (day: "T", achieved: true),
        (day: "W", achieved: false),
        (day: "T", achieved: true),
        (day: "F", achieved: true)
    ]

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "figure.walk")
                .font(.system(size: 20))
                .foregroundColor(AppColors.recovery)
                .frame(width: 40, height: 40)
                .background(AppColors.recovery.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text(steps.formatted())
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(AppColors.foreground)
                    .contentTransition(.numericText())

                Text("/ 10k")
                    .font(.system(size: 10))
                    .foregroundColor(AppColors.mutedForeground)
            }

            // Weekly tracker
            HStack(spacing: 2) {
                ForEach(Array(weekData.enumerated()), id: \.offset) { _, item in
                    Circle()
                        .fill(item.achieved ? AppColors.recovery : AppColors.border)
                        .frame(width: 14, height: 14)
                        .overlay {
                            if item.achieved {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 8, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(ThemeManager.shared.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }
}

struct WindowPill: View {
    let window: TimeWindow
    let currentHour: Int

    private var timeRemaining: String {
        let remaining = window.endHour - currentHour
        return remaining == 1 ? "1h left" : "\(remaining)h left"
    }

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: window.icon)
                .font(.system(size: 10))
            Text(window.label)
                .font(.system(size: 11, weight: .semibold))
            Text(timeRemaining)
                .font(.system(size: 10))
                .foregroundColor(AppColors.mutedForeground)
        }
        .foregroundColor(window.color)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(window.color.opacity(0.12))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(window.color.opacity(0.25), lineWidth: 2)
        )
        .clipShape(Capsule())
    }
}

struct TimelineView: View {
    let currentHour: Int
    let windows: [TimeWindow]

    var body: some View {
        VStack(spacing: 4) {
            // Time labels
            HStack {
                Text("6am")
                Spacer()
                Text("12pm")
                Spacer()
                Text("6pm")
                Spacer()
                Text("12am")
            }
            .font(.system(size: 9))
            .foregroundColor(AppColors.mutedForeground)

            // Timeline track
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 6)
                        .fill(AppColors.border)

                    // Window segments
                    ForEach(windows) { window in
                        let startOffset = CGFloat(max(0, window.startHour - 6)) / 18.0
                        let endOffset = CGFloat(min(24, window.endHour) - 6) / 18.0
                        let width = (endOffset - startOffset) * geometry.size.width
                        let isActive = currentHour >= window.startHour && currentHour < window.endHour

                        RoundedRectangle(cornerRadius: 4)
                            .fill(window.color.opacity(isActive ? 0.6 : 0.2))
                            .frame(width: max(0, width - 2))
                            .offset(x: startOffset * geometry.size.width)
                    }

                    // Current time indicator
                    let currentOffset = CGFloat(currentHour - 6) / 18.0
                    Circle()
                        .fill(AppColors.recovery)
                        .frame(width: 10, height: 10)
                        .shadow(color: AppColors.recovery.opacity(0.5), radius: 4)
                        .offset(x: currentOffset * geometry.size.width - 5)
                }
            }
            .frame(height: 12)

            // Current time label
            Text("\(currentHour):00 now")
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(AppColors.recovery)
        }
        .padding(.top, 8)
    }
}

// Simple flow layout for pills
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var maxY: CGFloat = 0
        let maxWidth = proposal.width ?? .infinity

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth {
                x = 0
                y = maxY + spacing
            }
            positions.append(CGPoint(x: x, y: y))
            x += size.width + spacing
            maxY = max(maxY, y + size.height)
        }

        return (CGSize(width: maxWidth, height: maxY), positions)
    }
}

#Preview {
    ZStack {
        AppColors.background.ignoresSafeArea()
        NowBlockCard(heartRate: 72, stressLevel: "Low", steps: 8432)
            .padding()
    }
    .preferredColorScheme(.light)
}
