import SwiftUI

struct SleepScoreRevealView: View {
    let sleepScore: Int
    let sleepDuration: String
    let deepSleep: String
    let remSleep: String
    let onDismiss: () -> Void

    @State private var stage = 0
    @State private var displayScore = 0
    @State private var ringProgress: CGFloat = 0
    @State private var glowScale: CGFloat = 0.8
    @State private var glowOpacity: Double = 0.3
    @State private var isDismissing = false
    @State private var dismissScale: CGFloat = 1.0
    @State private var dismissOffset: CGFloat = 0
    @State private var backdropOpacity: Double = 0

    private let ringSize: CGFloat = 260
    private let strokeWidth: CGFloat = 14

    private var scoreMessage: String {
        if sleepScore >= 85 { return "Excellent recovery!" }
        if sleepScore >= 70 { return "Good sleep" }
        return "Room to improve"
    }

    var body: some View {
        ZStack {
            // Backdrop
            Color.black.opacity(0.02)
                .background(.ultraThinMaterial)
                .opacity(backdropOpacity)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Ring Container
                ZStack {
                    // Glow
                    Circle()
                        .fill(AppColors.recovery.opacity(0.4))
                        .frame(width: ringSize + 60, height: ringSize + 60)
                        .blur(radius: 40)
                        .scaleEffect(glowScale)
                        .opacity(glowOpacity)

                    // Background ring
                    Circle()
                        .stroke(AppColors.recovery.opacity(0.15), lineWidth: strokeWidth)
                        .frame(width: ringSize, height: ringSize)

                    // Progress ring
                    Circle()
                        .trim(from: 0, to: ringProgress)
                        .stroke(AppColors.recovery, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                        .frame(width: ringSize, height: ringSize)
                        .rotationEffect(.degrees(-90))
                        .shadow(color: AppColors.recovery.opacity(0.5), radius: 12)

                    // Center content
                    VStack(spacing: 4) {
                        // Moon icon
                        Image(systemName: "moon.fill")
                            .font(.system(size: 20))
                            .foregroundColor(AppColors.recovery.opacity(0.6))
                            .opacity(stage >= 1 ? 1 : 0)
                            .scaleEffect(stage >= 1 ? 1 : 0.5)

                        // Score
                        Text("\(displayScore)")
                            .font(.system(size: 56, weight: .bold, design: .rounded))
                            .foregroundColor(AppColors.recovery)
                            .contentTransition(.numericText())
                            .opacity(stage >= 2 ? 1 : 0)
                            .scaleEffect(stage >= 2 ? 1 : 0.5)

                        // Label
                        Text("Sleep & Recovery")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppColors.recovery.opacity(0.7))
                            .opacity(stage >= 2 ? 1 : 0)
                    }
                }
                .scaleEffect(dismissScale)
                .offset(y: dismissOffset)
                .opacity(isDismissing ? 0 : 1)

                // Stats
                HStack(spacing: 20) {
                    StatColumn(value: sleepDuration, label: "Total", color: AppColors.foreground)

                    Divider()
                        .frame(height: 24)
                        .background(AppColors.mutedForeground.opacity(0.3))

                    StatColumn(value: deepSleep, label: "Deep", color: AppColors.primary)

                    Divider()
                        .frame(height: 24)
                        .background(AppColors.mutedForeground.opacity(0.3))

                    StatColumn(value: remSleep, label: "REM", color: AppColors.workout)
                }
                .padding(.top, 24)
                .opacity(stage >= 3 && !isDismissing ? 1 : 0)
                .offset(y: stage >= 3 ? 0 : 20)

                // Message
                Text(scoreMessage)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.foreground)
                    .padding(.top, 20)
                    .opacity(stage >= 4 && !isDismissing ? 1 : 0)

                // AFib Detection Card
                AFibDetectionCard()
                    .padding(.top, 20)
                    .padding(.horizontal, 32)
                    .opacity(stage >= 4 && !isDismissing ? 1 : 0)
                    .offset(y: stage >= 4 ? 0 : 10)

                Spacer()

                // Tap to continue
                Text("Tap to continue")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.mutedForeground.opacity(0.5))
                    .padding(.bottom, 48)
                    .opacity(stage >= 4 && !isDismissing ? 1 : 0)
            }
        }
        .onTapGesture {
            handleDismiss()
        }
        .onAppear {
            startAnimations()
        }
    }

    private func startAnimations() {
        // Fade in backdrop
        withAnimation(.easeOut(duration: 0.3)) {
            backdropOpacity = 1
        }

        // Stage 1: Moon icon
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.4)) {
                stage = 1
            }
        }

        // Stage 2: Score and ring
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.spring(response: 0.4)) {
                stage = 2
            }
            withAnimation(.easeOut(duration: 1.5)) {
                ringProgress = CGFloat(sleepScore) / 100
            }
            animateScore()
        }

        // Stage 3: Stats
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            withAnimation(.spring(response: 0.4)) {
                stage = 3
            }
        }

        // Stage 4: Message and AFib
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            withAnimation(.spring(response: 0.4)) {
                stage = 4
            }
        }

        // Glow animation
        withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
            glowScale = 1.1
            glowOpacity = 0.5
        }
    }

    private func animateScore() {
        let duration: Double = 1.0
        let steps = 50
        let increment = sleepScore / steps
        var current = 0

        Timer.scheduledTimer(withTimeInterval: duration / Double(steps), repeats: true) { timer in
            current += increment
            if current >= sleepScore {
                displayScore = sleepScore
                timer.invalidate()
            } else {
                displayScore = current
            }
        }
    }

    private func handleDismiss() {
        guard !isDismissing else { return }
        isDismissing = true

        withAnimation(.easeInOut(duration: 0.5)) {
            dismissScale = 0.25
            dismissOffset = -150
            backdropOpacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            onDismiss()
        }
    }
}

// MARK: - Stat Column
private struct StatColumn: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(AppColors.mutedForeground)
        }
    }
}

// MARK: - AFib Detection Card
private struct AFibDetectionCard: View {
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(AppColors.heartRate.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "heart.fill")
                        .font(.system(size: 18))
                        .foregroundColor(AppColors.heartRate)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text("AFib Detected")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.heartRate)

                Text("Irregular heart rhythm detected. Consult your doctor.")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mutedForeground)
                    .lineLimit(2)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColors.heartRate.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.heartRate.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    SleepScoreRevealView(
        sleepScore: 82,
        sleepDuration: "7h 42m",
        deepSleep: "1h 23m",
        remSleep: "1h 48m",
        onDismiss: {}
    )
}
