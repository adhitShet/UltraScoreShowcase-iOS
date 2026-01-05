import SwiftUI

struct MyRingView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var airplaneMode = false
    @State private var backgroundSync = true
    @State private var batteryLevel: Double = 0.96
    @State private var ringScale: CGFloat = 0.9
    @State private var ringOpacity: Double = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Status Bar
                statusBar

                // Ring Visualization
                ringVisualization

                // Cards
                VStack(spacing: 12) {
                    protectBanner
                    warrantyCard
                    batteryModeCard
                    airplaneModeCard
                    backgroundSyncCard
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 40)
        }
        .background(
            LinearGradient(
                colors: themeManager.isDarkMode
                    ? [Color(hex: "#0F1419"), Color(hex: "#131A24")]
                    : [Color(hex: "#F1F5F9"), Color(hex: "#E2E8F0")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.mutedForeground)
                        .frame(width: 40, height: 40)
                }
            }

            ToolbarItem(placement: .principal) {
                Text("My Ring")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                ringScale = 1
                ringOpacity = 1
            }
        }
    }

    // MARK: - Status Bar
    private var statusBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("STATUS")
                    .font(.system(size: 10, weight: .medium))
                    .tracking(1)
                    .foregroundColor(AppColors.mutedForeground)
                HStack(spacing: 8) {
                    Text("Connected")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.foreground)
                    Circle()
                        .fill(AppColors.recovery)
                        .frame(width: 10, height: 10)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("LAST SYNC")
                    .font(.system(size: 10, weight: .medium))
                    .tracking(1)
                    .foregroundColor(AppColors.mutedForeground)
                HStack(spacing: 6) {
                    Text("11:32 AM")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.foreground)
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.primary)
                }
            }
        }
        .padding(.top, 8)
    }

    // MARK: - Ring Visualization
    private var ringVisualization: some View {
        VStack(spacing: 16) {
            ZStack {
                // Outer ring with shadow
                Circle()
                    .fill(AppColors.cardBackground)
                    .frame(width: 192, height: 192)
                    .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.4 : 0.15), radius: 20, x: 0, y: 8)

                // Battery progress arc
                Circle()
                    .trim(from: 0, to: batteryLevel)
                    .stroke(AppColors.mutedForeground.opacity(0.5), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .frame(width: 184, height: 184)
                    .rotationEffect(.degrees(-90))

                // Background arc
                Circle()
                    .trim(from: batteryLevel, to: 1)
                    .stroke(AppColors.mutedForeground.opacity(0.3), lineWidth: 3)
                    .frame(width: 184, height: 184)
                    .rotationEffect(.degrees(-90))

                // Inner dark ring (stays dark in both modes for contrast)
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#1E293B"), Color(hex: "#0F172A")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 144, height: 144)
                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)

                // Snowflake icon
                Image(systemName: "snowflake")
                    .font(.system(size: 40))
                    .foregroundColor(Color(hex: "#64748B"))
            }
            .scaleEffect(ringScale)
            .opacity(ringOpacity)
            .padding(.vertical, 24)

            // Mode & Battery
            VStack(spacing: 4) {
                Text("Chill Mode Active")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
                Text("Battery \(Int(batteryLevel * 100))%")
                    .font(.system(size: 15))
                    .foregroundColor(AppColors.mutedForeground)
            }
            .opacity(ringOpacity)
        }
    }

    // MARK: - Protect Banner
    private var protectBanner: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: "shield.fill")
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.primary)

                Text("Protect your ring with UltrahumanX")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(AppColors.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.mutedForeground)
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.05), radius: 4, x: 0, y: 2)
        }
    }

    // MARK: - Warranty Card
    private var warrantyCard: some View {
        HStack {
            Text("Ring Warranty")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(AppColors.foreground)
            Spacer()
            Text("Valid till 18 Jun, 2026")
                .font(.system(size: 15))
                .foregroundColor(AppColors.mutedForeground)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.05), radius: 4, x: 0, y: 2)
    }

    // MARK: - Battery Mode Card
    private var batteryModeCard: some View {
        Button(action: {}) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Choose a battery usage mode")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(AppColors.foreground)
                    Text("CURRENT: CHILL MODE")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(AppColors.primary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.mutedForeground)
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.05), radius: 4, x: 0, y: 2)
        }
    }

    // MARK: - Airplane Mode Card
    private var airplaneModeCard: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Airplane Mode")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
                Text("Turns off all radio communications with the Ring. The Ring will still keep recording data on its own.")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.mutedForeground)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Toggle("", isOn: $airplaneMode)
                .labelsHidden()
                .tint(AppColors.primary)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.05), radius: 4, x: 0, y: 2)
    }

    // MARK: - Background Sync Card
    private var backgroundSyncCard: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Background Sync")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
                Text("Ring syncs with the app automatically in the background. Turning this off can help conserve battery life.")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.mutedForeground)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Toggle("", isOn: $backgroundSync)
                .labelsHidden()
                .tint(AppColors.primary)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    NavigationStack {
        MyRingView()
    }
}
