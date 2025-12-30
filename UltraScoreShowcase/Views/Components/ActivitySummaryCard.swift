import SwiftUI

struct Activity: Identifiable {
    let id = UUID()
    let label: String
    let icon: String
    let time: String
    var duration: String?
    var calories: Int?
    var effortPoints: Int?
    var confirmed: Bool
}

struct ActivitySummaryCard: View {
    @State private var activities: [Activity] = [
        Activity(label: "Evening Walk", icon: "figure.walk", time: "5:45pm", duration: "25min", calories: 95, effortPoints: 3, confirmed: false),
        Activity(label: "Walk", icon: "figure.walk", time: "6:30 - 7:00 AM", duration: "25 mins", calories: 65, effortPoints: 5, confirmed: true),
        Activity(label: "Caesar Salad", icon: "leaf.fill", time: "12:30pm", calories: 380, confirmed: true),
        Activity(label: "Paddle", icon: "sportscourt.fill", time: "7:30am", duration: "45min", calories: 320, effortPoints: 12, confirmed: true),
        Activity(label: "Sleep", icon: "moon.fill", time: "11:30 PM - 7:12 AM", duration: "7h 42m", effortPoints: 45, confirmed: true)
    ]
    @State private var isExpanded = false

    private var totalEffortPoints: Int {
        activities.filter { $0.confirmed }.reduce(0) { $0 + ($1.effortPoints ?? 0) }
    }

    private var displayedActivities: [Activity] {
        isExpanded ? activities : Array(activities.prefix(2))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text("Today's Activities")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.foreground)

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 10))
                    Text("+\(totalEffortPoints) pts")
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundColor(AppColors.primary)
            }

            // Activities List
            VStack(spacing: 6) {
                ForEach(displayedActivities) { activity in
                    ActivityRow(
                        activity: activity,
                        onConfirm: { confirmActivity(activity.id) },
                        onDismiss: { dismissActivity(activity.id) }
                    )
                }

                // Show More/Less button
                if activities.count > 2 {
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            isExpanded.toggle()
                        }
                    }) {
                        HStack(spacing: 4) {
                            Text(isExpanded ? "Show less" : "\(activities.count - 2) more")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(AppColors.mutedForeground)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10))
                                .foregroundColor(AppColors.mutedForeground)
                                .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }
                }

                // Action Buttons
                HStack(spacing: 8) {
                    Button(action: {}) {
                        HStack(spacing: 6) {
                            Image(systemName: "plus")
                                .font(.system(size: 12))
                            Text("Start workout")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundColor(AppColors.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                .foregroundColor(AppColors.primary.opacity(0.3))
                        )
                    }

                    Button(action: {}) {
                        HStack(spacing: 6) {
                            Image(systemName: "plus")
                                .font(.system(size: 12))
                            Text("Start breathwork")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundColor(AppColors.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                .foregroundColor(AppColors.primary.opacity(0.3))
                        )
                    }
                }
            }
            .padding(12)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
        }
    }

    private func confirmActivity(_ id: UUID) {
        if let index = activities.firstIndex(where: { $0.id == id }) {
            withAnimation(.spring(response: 0.3)) {
                activities[index].confirmed = true
            }
        }
    }

    private func dismissActivity(_ id: UUID) {
        withAnimation(.spring(response: 0.3)) {
            activities.removeAll { $0.id == id }
        }
    }
}

struct ActivityRow: View {
    let activity: Activity
    let onConfirm: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            // Icon
            Image(systemName: activity.icon)
                .font(.system(size: 14))
                .foregroundColor(activity.confirmed ? AppColors.mutedForeground : AppColors.warning)
                .frame(width: 28, height: 28)
                .background(activity.confirmed ? AppColors.background : AppColors.warning.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 6))

            // Info
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(activity.label)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(AppColors.foreground)

                    Text(activity.time)
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.mutedForeground)
                }

                HStack(spacing: 8) {
                    if let duration = activity.duration {
                        Text(duration)
                            .font(.system(size: 10))
                            .foregroundColor(AppColors.mutedForeground)
                    }

                    if let calories = activity.calories {
                        HStack(spacing: 2) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 8))
                            Text("\(calories)")
                                .font(.system(size: 10))
                        }
                        .foregroundColor(AppColors.movement)
                    }

                    if let points = activity.effortPoints {
                        HStack(spacing: 2) {
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 8))
                            Text("+\(points)")
                                .font(.system(size: 10, weight: .semibold))
                        }
                        .foregroundColor(AppColors.primary)
                    }
                }
            }

            Spacer()

            // Actions
            HStack(spacing: 4) {
                if !activity.confirmed {
                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .font(.system(size: 10))
                            .foregroundColor(AppColors.error.opacity(0.7))
                            .frame(width: 24, height: 24)
                            .background(AppColors.error.opacity(0.1))
                            .clipShape(Circle())
                    }
                }

                if activity.confirmed {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.recovery)
                        .frame(width: 24, height: 24)
                        .background(AppColors.recovery.opacity(0.15))
                        .clipShape(Circle())
                } else {
                    Button(action: onConfirm) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 10))
                            .foregroundColor(AppColors.primary)
                            .frame(width: 24, height: 24)
                            .background(AppColors.primary.opacity(0.15))
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(activity.confirmed ? AppColors.background.opacity(0.5) : AppColors.warning.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(activity.confirmed ? AppColors.border : AppColors.warning.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    ZStack {
        AppColors.background.ignoresSafeArea()
        ActivitySummaryCard()
            .padding()
    }
    .preferredColorScheme(.light)
}
