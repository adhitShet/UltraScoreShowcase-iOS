import SwiftUI

struct DevicesView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var airplaneMode = false
    @State private var backgroundSync = true
    @State private var showContent = false
    @State private var batteryProgress: CGFloat = 0

    let batteryPercentage = 87
    let firmwareVersion = "v2.4.1"
    let warrantyDate = "5 Jun, 2026"

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Status Bar
                statusSection

                // Ring Visualization
                ringVisualizationSection

                // Protect Banner
                protectBannerSection

                // Ring Warranty
                warrantySection

                // Battery Mode
                batteryModeSection

                // Airplane Mode
                airplaneModeSection

                // Background Sync
                backgroundSyncSection

                // Firmware Version
                firmwareSection
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 40)
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.foreground)
                        .frame(width: 40, height: 40)
                        .background(AppColors.cardBackground)
                        .clipShape(Circle())
                }
            }

            ToolbarItem(placement: .principal) {
                Text("My Ring")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                batteryProgress = CGFloat(batteryPercentage) / 100
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.6)) {
                    showContent = true
                }
            }
        }
    }

    // MARK: - Status Section
    private var statusSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("STATUS")
                    .font(.system(size: 10, weight: .medium))
                    .tracking(0.5)
                    .foregroundColor(AppColors.mutedForeground)

                HStack(spacing: 8) {
                    Text("Connected")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(AppColors.foreground)

                    Circle()
                        .fill(AppColors.recovery)
                        .frame(width: 8, height: 8)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("LAST SYNC")
                    .font(.system(size: 10, weight: .medium))
                    .tracking(0.5)
                    .foregroundColor(AppColors.mutedForeground)

                HStack(spacing: 8) {
                    Text("5:11 PM")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(AppColors.foreground)

                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.recovery)
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
    }

    // MARK: - Ring Visualization Section
    private var ringVisualizationSection: some View {
        VStack(spacing: 16) {
            ZStack {
                // Background circle
                Circle()
                    .stroke(AppColors.border.opacity(0.3), lineWidth: 4)
                    .frame(width: 180, height: 180)

                // Battery arc indicator
                Circle()
                    .trim(from: 0, to: batteryProgress)
                    .stroke(
                        AppColors.foreground,
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 180, height: 180)
                    .rotationEffect(.degrees(-90))

                // Ring visual
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppColors.cardBackground, AppColors.border.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 128, height: 128)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 4)

                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppColors.background, AppColors.cardBackground],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 96, height: 96)

                    Image(systemName: "flame.fill")
                        .font(.system(size: 32))
                        .foregroundColor(Color(hex: "#F59E0B"))
                }
            }

            // Mode & Battery
            VStack(spacing: 4) {
                Text("Turbo Mode Active")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.foreground)

                Text("Battery \(batteryPercentage)%")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.mutedForeground)
            }
        }
        .padding(.vertical, 24)
    }

    // MARK: - Protect Banner
    private var protectBannerSection: some View {
        Button(action: {}) {
            HStack {
                HStack(spacing: 12) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.mutedForeground)

                    Text("Protect your ring with UltrahumanX")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "#8B5CF6"))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.mutedForeground)
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .opacity(showContent ? 1 : 0)
        .offset(y: showContent ? 0 : 10)
    }

    // MARK: - Warranty Section
    private var warrantySection: some View {
        HStack {
            Text("Ring Warranty")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(AppColors.foreground)

            Spacer()

            Text("Valid till \(warrantyDate)")
                .font(.system(size: 14))
                .foregroundColor(AppColors.mutedForeground)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .opacity(showContent ? 1 : 0)
        .offset(y: showContent ? 0 : 10)
    }

    // MARK: - Battery Mode Section
    private var batteryModeSection: some View {
        Button(action: {}) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Choose a battery usage mode")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(AppColors.foreground)

                    Text("CURRENT: TURBO MODE")
                        .font(.system(size: 10, weight: .semibold))
                        .tracking(0.5)
                        .foregroundColor(Color(hex: "#8B5CF6"))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.mutedForeground)
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .opacity(showContent ? 1 : 0)
        .offset(y: showContent ? 0 : 10)
    }

    // MARK: - Airplane Mode Section
    private var airplaneModeSection: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Airplane Mode")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(AppColors.foreground)

                Text("Turns off all radio communications with the Ring. The Ring will still keep recording data on its own.")
                    .font(.system(size: 13))
                    .foregroundColor(AppColors.mutedForeground)
                    .lineSpacing(2)
            }

            Toggle("", isOn: $airplaneMode)
                .labelsHidden()
                .tint(Color(hex: "#8B5CF6"))
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .opacity(showContent ? 1 : 0)
        .offset(y: showContent ? 0 : 10)
    }

    // MARK: - Background Sync Section
    private var backgroundSyncSection: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Background Sync")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(AppColors.foreground)

                Text("Allows the app to sync data with your ring in the background for up-to-date metrics.")
                    .font(.system(size: 13))
                    .foregroundColor(AppColors.mutedForeground)
                    .lineSpacing(2)
            }

            Toggle("", isOn: $backgroundSync)
                .labelsHidden()
                .tint(Color(hex: "#8B5CF6"))
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .opacity(showContent ? 1 : 0)
        .offset(y: showContent ? 0 : 10)
    }

    // MARK: - Firmware Section
    private var firmwareSection: some View {
        HStack {
            Text("Firmware Version")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(AppColors.foreground)

            Spacer()

            Text(firmwareVersion)
                .font(.system(size: 14))
                .foregroundColor(AppColors.mutedForeground)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .opacity(showContent ? 1 : 0)
        .offset(y: showContent ? 0 : 10)
    }
}

#Preview {
    NavigationStack {
        DevicesView()
    }
}
