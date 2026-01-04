import SwiftUI

struct WorkoutTrackerView: View {
    @Binding var isPresented: Bool
    @State private var isRunning = true
    @State private var seconds = 0
    @State private var heartRate = 124
    @State private var timer: Timer?

    var body: some View {
        if isPresented {
            VStack {
                Spacer()

                HStack(spacing: 12) {
                    // Workout Info
                    HStack(spacing: 12) {
                        // Activity Icon
                        Image(systemName: "figure.run")
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.heartRate)
                            .frame(width: 44, height: 44)
                            .background(AppColors.heartRate.opacity(0.15))
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Running")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(AppColors.foreground)
                            HStack(spacing: 4) {
                                Text("Zone 2")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppColors.mutedForeground)
                                Text("·")
                                    .foregroundColor(AppColors.mutedForeground)
                                Text("\(heartRate) bpm")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(AppColors.heartRate)
                            }
                        }
                    }

                    Spacer()

                    // Timer & Controls
                    HStack(spacing: 12) {
                        Text(formatTime(seconds))
                            .font(.system(size: 24, weight: .semibold, design: .monospaced))
                            .foregroundColor(AppColors.foreground.opacity(0.7))
                            .frame(minWidth: 70)

                        Button(action: {
                            isRunning.toggle()
                            if isRunning {
                                startTimer()
                            } else {
                                stopTimer()
                            }
                        }) {
                            Image(systemName: isRunning ? "pause.fill" : "play.fill")
                                .font(.system(size: 16))
                                .foregroundColor(AppColors.foreground.opacity(0.7))
                                .frame(width: 40, height: 40)
                                .background(AppColors.border.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        Button(action: {
                            stopTimer()
                            withAnimation(.spring(response: 0.3)) {
                                isPresented = false
                            }
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16))
                                .foregroundColor(AppColors.foreground.opacity(0.7))
                                .frame(width: 40, height: 40)
                                .background(AppColors.border.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColors.cardBackground.opacity(0.7))
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }
            .transition(.asymmetric(
                insertion: .opacity.combined(with: .move(edge: .bottom)).combined(with: .scale(scale: 0.95)),
                removal: .opacity.combined(with: .move(edge: .bottom)).combined(with: .scale(scale: 0.95))
            ))
            .onAppear {
                startTimer()
                startHeartRateSimulation()
            }
            .onDisappear {
                stopTimer()
            }
        }
    }

    private func formatTime(_ totalSeconds: Int) -> String {
        let mins = totalSeconds / 60
        let secs = totalSeconds % 60
        return String(format: "%d:%02d", mins, secs)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            seconds += 1
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func startHeartRateSimulation() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let change = Int.random(in: -2...2)
            heartRate = max(90, min(180, heartRate + change))
        }
    }
}

#Preview {
    ZStack {
        AppColors.background.ignoresSafeArea()
        WorkoutTrackerView(isPresented: .constant(true))
    }
}
