import SwiftUI

struct SleepScreenerCard: View {
    @ObservedObject private var themeManager = ThemeManager.shared

    var body: some View {
        NavigationLink(destination: SleepScreenerDetailsView()) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Sleep Screener")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.foreground)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)
                }

                HStack(spacing: 8) {
                    // AFib Detection
                    ScreenerMetric(
                        icon: "heart.fill",
                        iconColor: AppColors.recovery,
                        label: "AFib",
                        status: "No AFib",
                        statusDetail: "All good",
                        statusColor: AppColors.recovery,
                        statusIcon: "checkmark.circle.fill"
                    )

                    // Respiratory
                    ScreenerMetric(
                        icon: "wind",
                        iconColor: AppColors.zone,
                        label: "Resp",
                        status: "7 events",
                        statusDetail: "detected",
                        statusColor: AppColors.zone,
                        statusIcon: "exclamationmark.triangle.fill"
                    )

                    // Immune/Fever
                    ScreenerMetric(
                        icon: "thermometer.medium",
                        iconColor: AppColors.heartRate,
                        label: "Immune",
                        status: "Fever",
                        statusDetail: "High load",
                        statusColor: AppColors.heartRate,
                        statusIcon: "exclamationmark.triangle.fill"
                    )
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ScreenerMetric: View {
    let icon: String
    let iconColor: Color
    let label: String
    let status: String
    let statusDetail: String
    let statusColor: Color
    let statusIcon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundColor(iconColor)
                    .frame(width: 28, height: 28)
                    .background(iconColor.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                Text(label)
                    .font(.system(size: 10))
                    .foregroundColor(AppColors.mutedForeground)
            }

            HStack(spacing: 4) {
                Image(systemName: statusIcon)
                    .font(.system(size: 10))
                    .foregroundColor(statusColor)

                VStack(alignment: .leading, spacing: 1) {
                    Text(status)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(AppColors.foreground)
                        .lineLimit(1)

                    Text(statusDetail)
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(statusColor)
                        .lineLimit(1)
                }
                .fixedSize(horizontal: true, vertical: false)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(ThemeManager.shared.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    ZStack {
        AppColors.background.ignoresSafeArea()
        SleepScreenerCard()
            .padding()
    }
    .preferredColorScheme(.light)
}
