import SwiftUI

struct WorkoutTrackerCard: View {
    @Binding var isPresented: Bool
    @State private var isRunning = true
    @State private var elapsedSeconds = 0
    @State private var heartRate = 142
    @State private var zone = "Zone 4"

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let hrTimer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    private var formattedTime: String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        HStack(spacing: 12) {
            // Activity icon
            Circle()
                .fill(AppColors.workout.opacity(0.15))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: "figure.run")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.workout)
                )

            // Activity Info
            VStack(alignment: .leading, spacing: 2) {
                Text("Running")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    Text(zone)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(AppColors.workout)
                        .lineLimit(1)

                    HStack(spacing: 2) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 9))
                            .foregroundColor(AppColors.heartRate)
                        Text("\(heartRate)")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(AppColors.heartRate)
                            .contentTransition(.numericText())
                            .lineLimit(1)
                    }
                }
            }
            .fixedSize(horizontal: true, vertical: false)

            Spacer(minLength: 8)

            // Timer
            Text(formattedTime)
                .font(.system(size: 22, weight: .bold, design: .monospaced))
                .foregroundColor(AppColors.foreground)
                .fixedSize()

            // Controls
            HStack(spacing: 6) {
                // Play/Pause
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        isRunning.toggle()
                    }
                }) {
                    Image(systemName: isRunning ? "pause.fill" : "play.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(AppColors.primary)
                        .clipShape(Circle())
                }

                // Close
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        isPresented = false
                    }
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(AppColors.mutedForeground)
                        .frame(width: 32, height: 32)
                        .background(AppColors.border.opacity(0.5))
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 14)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: 4)
        .padding(.horizontal, 16)
        .onReceive(timer) { _ in
            if isRunning {
                elapsedSeconds += 1
            }
        }
        .onReceive(hrTimer) { _ in
            if isRunning {
                withAnimation(.easeInOut(duration: 0.3)) {
                    heartRate = Int.random(in: 135...155)
                    // Update zone based on HR
                    if heartRate >= 150 {
                        zone = "Zone 5"
                    } else if heartRate >= 140 {
                        zone = "Zone 4"
                    } else {
                        zone = "Zone 3"
                    }
                }
            }
        }
    }
}

#Preview {
    ZStack {
        AppColors.background.ignoresSafeArea()
        VStack {
            Spacer()
            WorkoutTrackerCard(isPresented: .constant(true))
            Spacer().frame(height: 100)
        }
    }
}
