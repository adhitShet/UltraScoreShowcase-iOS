import SwiftUI

struct WorkoutDetectionSheet: View {
    @Binding var isPresented: Bool
    let onQuickStart: () -> Void
    let onChooseActivity: () -> Void

    @State private var heartRate = 128
    @State private var steps = 847
    @State private var offset: CGFloat = 0

    private let timer = Timer.publish(every: 0.8, on: .main, in: .common).autoconnect()
    private let stepsTimer = Timer.publish(every: 0.6, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack(alignment: .bottom) {
            // Backdrop
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }

            // Sheet
            VStack(spacing: 0) {
                // Drag indicator
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(AppColors.mutedForeground.opacity(0.3))
                    .frame(width: 36, height: 5)
                    .padding(.top, 12)
                    .padding(.bottom, 20)

                // Title
                Text("Are you working out?")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
                    .padding(.bottom, 16)

                // Heart Rate Display
                VStack(spacing: 8) {
                    Circle()
                        .fill(AppColors.heartRate.opacity(0.15))
                        .frame(width: 64, height: 64)
                        .overlay(
                            Image(systemName: "heart.fill")
                                .font(.system(size: 28))
                                .foregroundColor(AppColors.heartRate)
                        )

                    Text("Live Heart Rate")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)

                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(heartRate)")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(AppColors.heartRate)
                            .contentTransition(.numericText())

                        Text("bpm")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.mutedForeground)
                    }

                    Text("↑ Elevated")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.heartRate)
                }
                .padding(.bottom, 16)

                // Steps
                HStack(spacing: 8) {
                    Image(systemName: "shoeprints.fill")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.movement)

                    Text("\(steps.formatted()) steps • +127 in 2min")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)
                }
                .padding(.bottom, 12)

                // Log as stress
                Button(action: { dismiss() }) {
                    Text("Log as stress instead")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(AppColors.primary)
                }
                .padding(.bottom, 20)

                // Buttons
                VStack(spacing: 12) {
                    Button(action: {
                        onQuickStart()
                        dismiss()
                    }) {
                        Text("Quick Start")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(AppColors.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Button(action: {
                        onChooseActivity()
                        dismiss()
                    }) {
                        Text("Choose Activity")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(AppColors.primary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
            .frame(maxWidth: .infinity)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .offset(y: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.height > 0 {
                            offset = value.translation.height
                        }
                    }
                    .onEnded { value in
                        if value.translation.height > 100 {
                            dismiss()
                        } else {
                            withAnimation(.spring(response: 0.3)) {
                                offset = 0
                            }
                        }
                    }
            )
            .transition(.move(edge: .bottom))
        }
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 0.2)) {
                heartRate = max(120, min(145, heartRate + Int.random(in: -1...2)))
            }
        }
        .onReceive(stepsTimer) { _ in
            withAnimation(.easeInOut(duration: 0.2)) {
                steps += Int.random(in: 1...3)
            }
        }
    }

    private func dismiss() {
        withAnimation(.spring(response: 0.3)) {
            isPresented = false
        }
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.3).ignoresSafeArea()
        WorkoutDetectionSheet(
            isPresented: .constant(true),
            onQuickStart: {},
            onChooseActivity: {}
        )
    }
}
