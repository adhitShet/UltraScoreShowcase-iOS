import SwiftUI

struct CycleHealthCard: View {
    @ObservedObject private var themeManager = ThemeManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cycle Health")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppColors.foreground)

            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Peak Fertility")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppColors.foreground)

                        Text("Ovulation \u{2022} Day 14")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.mutedForeground)
                    }

                    Spacer()

                    Text("Next period \u{2022} 21 Dec")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)
                }

                HStack(spacing: 8) {
                    CycleTag(
                        text: "36.8°C ↑",
                        color: AppColors.movement
                    )

                    CycleTag(
                        text: "1 Cycle Flag",
                        color: AppColors.error
                    )
                }
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.black.opacity(ThemeManager.shared.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
        }
    }
}

struct CycleTag: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(color)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(color.opacity(0.12))
            .clipShape(Capsule())
    }
}

#Preview {
    ZStack {
        AppColors.background.ignoresSafeArea()
        CycleHealthCard()
            .padding()
    }
    .preferredColorScheme(.light)
}
