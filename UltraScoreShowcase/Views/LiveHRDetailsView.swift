import SwiftUI

struct LiveHRDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var liveHR: Int = 82
    @State private var hrHistory: [Double] = Array(repeating: 82, count: 60)
    @State private var isAnimating = false

    private let timer = Timer.publish(every: 0.8, on: .main, in: .common).autoconnect()

    // HR Zone configuration
    private func getZoneInfo(hr: Int) -> (zone: String, color: Color, bgColor: Color) {
        if hr < 60 { return ("Rest", Color.blue, Color.blue.opacity(0.2)) }
        if hr < 100 { return ("Fat Burn", AppColors.recovery, AppColors.recovery.opacity(0.2)) }
        if hr < 140 { return ("Cardio", Color.orange, Color.orange.opacity(0.2)) }
        if hr < 170 { return ("Peak", AppColors.heartRate, AppColors.heartRate.opacity(0.2)) }
        return ("Max", Color.pink, Color.pink.opacity(0.2))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Live HR Camera View
                liveHRCameraSection

                // HR Trend Chart
                hrTrendSection

                // Stats Grid
                statsGridSection

                // Zone Legend
                zoneLegendSection
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
                HStack(spacing: 6) {
                    Text("Live Heart Rate")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.foreground)

                    Circle()
                        .fill(AppColors.heartRate)
                        .frame(width: 8, height: 8)
                        .scaleEffect(isAnimating ? 1.3 : 1.0)
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isAnimating)

                    Text("LIVE")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(AppColors.heartRate)
                }
            }
        }
        .onAppear {
            isAnimating = true
        }
        .onReceive(timer) { _ in
            simulateHRChange()
        }
    }

    // MARK: - Live HR Camera Section
    private var liveHRCameraSection: some View {
        let zoneInfo = getZoneInfo(hr: liveHR)

        return ZStack {
            // Simulated camera view background
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#1a1a1a"), Color(hex: "#2a2a2a")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 400)

            // Camera viewfinder corners
            VStack {
                HStack {
                    ViewfinderCorner(rotation: 0)
                    Spacer()
                    ViewfinderCorner(rotation: 90)
                }
                Spacer()
                HStack {
                    ViewfinderCorner(rotation: 270)
                    Spacer()
                    ViewfinderCorner(rotation: 180)
                }
            }
            .padding(16)
            .frame(height: 400)

            // User silhouette placeholder
            Circle()
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                .frame(width: 100, height: 100)

            // Top center - Big Live HR
            VStack(spacing: 8) {
                // Pulsing rings
                ZStack {
                    ForEach(0..<3, id: \.self) { i in
                        Circle()
                            .stroke(AppColors.heartRate.opacity(0.3 - Double(i) * 0.1), lineWidth: 1)
                            .frame(width: 120 + CGFloat(i) * 20, height: 120 + CGFloat(i) * 20)
                            .scaleEffect(isAnimating ? 1.3 : 1.0)
                            .opacity(isAnimating ? 0 : 0.5)
                            .animation(
                                .easeOut(duration: 1.5)
                                .repeatForever(autoreverses: false)
                                .delay(Double(i) * 0.4),
                                value: isAnimating
                            )
                    }

                    // HR Display
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Image(systemName: "bolt.heart.fill")
                            .font(.system(size: 28))
                            .foregroundColor(AppColors.heartRate)
                            .scaleEffect(isAnimating ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.4).repeatForever(autoreverses: true), value: isAnimating)

                        Text("\(liveHR)")
                            .font(.system(size: 56, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .contentTransition(.numericText())

                        Text("bpm")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }

                // Zone Tag
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 12))
                    Text("\(zoneInfo.zone) Zone")
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundColor(zoneInfo.color)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.6))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(zoneInfo.color.opacity(0.4), lineWidth: 1)
                )

                Spacer()

                // Mini HR Graph
                HRMiniGraph(data: hrHistory)
                    .frame(height: 60)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
            }
            .padding(.top, 20)
            .frame(height: 400)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
    }

    // MARK: - HR Trend Section
    private var hrTrendSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "heart.fill")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.heartRate)
                Text("HR Trend")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
                Spacer()
                Text("Last 12 hours")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mutedForeground)
            }

            // Trend chart placeholder
            HRTrendChart()
                .frame(height: 160)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Stats Grid
    private var statsGridSection: some View {
        HStack(spacing: 12) {
            HRStatCard(value: "58", label: "Min Today", icon: "arrow.down", color: AppColors.recovery)
            HRStatCard(value: "76", label: "Avg Today", icon: "equal", color: AppColors.movement)
            HRStatCard(value: "142", label: "Max Today", icon: "arrow.up", color: AppColors.heartRate)
        }
    }

    // MARK: - Zone Legend
    private var zoneLegendSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("HR Zones")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppColors.foreground)

            VStack(spacing: 8) {
                ZoneRow(zone: "Rest", range: "< 60 bpm", color: .blue)
                ZoneRow(zone: "Fat Burn", range: "60-100 bpm", color: AppColors.recovery)
                ZoneRow(zone: "Cardio", range: "100-140 bpm", color: .orange)
                ZoneRow(zone: "Peak", range: "140-170 bpm", color: AppColors.heartRate)
                ZoneRow(zone: "Max", range: "> 170 bpm", color: .pink)
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: - Simulate HR Change
    private func simulateHRChange() {
        let delta = Int.random(in: -3...3)
        liveHR = max(60, min(120, liveHR + delta))
        hrHistory.removeFirst()
        hrHistory.append(Double(liveHR))
    }
}

// MARK: - Viewfinder Corner
struct ViewfinderCorner: View {
    let rotation: Double

    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 20))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 20, y: 0))
        }
        .stroke(Color.white.opacity(0.3), lineWidth: 2)
        .frame(width: 20, height: 20)
        .rotationEffect(.degrees(rotation))
    }
}

// MARK: - HR Mini Graph
struct HRMiniGraph: View {
    let data: [Double]

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let minVal = (data.min() ?? 60) - 10
            let maxVal = (data.max() ?? 100) + 10
            let range = maxVal - minVal

            ZStack {
                // Gradient fill
                Path { path in
                    path.move(to: CGPoint(x: 0, y: height))
                    for (index, value) in data.enumerated() {
                        let x = CGFloat(index) / CGFloat(data.count - 1) * width
                        let y = height - ((value - minVal) / range) * height
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                    path.addLine(to: CGPoint(x: width, y: height))
                    path.closeSubpath()
                }
                .fill(
                    LinearGradient(
                        colors: [AppColors.heartRate.opacity(0.4), AppColors.heartRate.opacity(0)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

                // Line
                Path { path in
                    for (index, value) in data.enumerated() {
                        let x = CGFloat(index) / CGFloat(data.count - 1) * width
                        let y = height - ((value - minVal) / range) * height
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(AppColors.heartRate, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .shadow(color: AppColors.heartRate.opacity(0.5), radius: 4)

                // Current point
                if let lastValue = data.last {
                    let y = height - ((lastValue - minVal) / range) * height
                    Circle()
                        .fill(AppColors.heartRate)
                        .frame(width: 10, height: 10)
                        .position(x: width, y: y)
                        .shadow(color: AppColors.heartRate, radius: 4)
                }
            }
        }
    }
}

// MARK: - HR Trend Chart
struct HRTrendChart: View {
    private let data: [(String, Int)] = [
        ("6 AM", 58), ("8 AM", 72), ("10 AM", 85), ("12 PM", 78),
        ("2 PM", 92), ("4 PM", 88), ("6 PM", 95), ("8 PM", 75)
    ]

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let barWidth = width / CGFloat(data.count) - 8

            HStack(alignment: .bottom, spacing: 8) {
                ForEach(data, id: \.0) { time, value in
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [AppColors.heartRate, AppColors.heartRate.opacity(0.6)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: barWidth, height: CGFloat(value - 50) / 50 * (height - 20))

                        Text(time)
                            .font(.system(size: 9))
                            .foregroundColor(AppColors.mutedForeground)
                    }
                }
            }
        }
    }
}

// MARK: - HR Stat Card
struct HRStatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(color)

            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(AppColors.foreground)

            Text(label)
                .font(.system(size: 11))
                .foregroundColor(AppColors.mutedForeground)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(ThemeManager.shared.isDarkMode ? 0.3 : 0.04), radius: 6, x: 0, y: 2)
    }
}

// MARK: - Zone Row
struct ZoneRow: View {
    let zone: String
    let range: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)

            Text(zone)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.foreground)

            Spacer()

            Text(range)
                .font(.system(size: 12))
                .foregroundColor(AppColors.mutedForeground)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    NavigationStack {
        LiveHRDetailsView()
    }
}
