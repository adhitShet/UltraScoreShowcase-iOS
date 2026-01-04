import SwiftUI

struct MyRingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var airplaneMode = false
    @State private var backgroundSync = true
    @State private var batteryLevel: Double = 0.87

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Status Bar
                statusBar

                // Ring Visualization
                ringVisualization

                // Protect Banner
                protectBanner

                // Ring Warranty
                warrantyCard

                // Battery Mode
                batteryModeCard

                // Airplane Mode
                airplaneModeCard

                // Background Sync
                backgroundSyncCard

                // Firmware Version
                firmwareCard
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
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.mutedForeground)
                        .frame(width: 40, height: 40)
                        .background(AppColors.cardBackground)
                        .clipShape(Circle())
                }
            }

            ToolbarItem(placement: .principal) {
                Text("My Ring")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                batteryLevel = 0.87
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
                HStack(spacing: 6) {
                    Text("Connected")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.foreground)
                    Circle()
                        .fill(Color(hex: "#22C55E"))
                        .frame(width: 8, height: 8)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("LAST SYNC")
                    .font(.system(size: 10, weight: .medium))
                    .tracking(1)
                    .foregroundColor(AppColors.mutedForeground)
                HStack(spacing: 6) {
                    Text("5:11 PM")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.foreground)
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(hex: "#22C55E"))
                }
            }
        }
        .padding(.horizontal, 8)
    }

    // MARK: - Ring Visualization
    private var ringVisualization: some View {
        VStack(spacing: 16) {
            ZStack {
                // Outer glow ring
                Circle()
                    .stroke(AppColors.border.opacity(0.3), lineWidth: 2)
                    .frame(width: 192, height: 192)

                // Battery arc indicator
                Circle()
                    .trim(from: 0, to: batteryLevel)
                    .stroke(AppColors.foreground, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 180, height: 180)
                    .rotationEffect(.degrees(-90))

                // Background arc
                Circle()
                    .trim(from: batteryLevel, to: 1)
                    .stroke(AppColors.border.opacity(0.2), lineWidth: 4)
                    .frame(width: 180, height: 180)
                    .rotationEffect(.degrees(-90))

                // Center ring visual
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppColors.border.opacity(0.4), AppColors.border.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 128, height: 128)
                        .overlay(Circle().stroke(AppColors.border.opacity(0.5), lineWidth: 1))

                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppColors.background, AppColors.border.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 96, height: 96)
                        .overlay(Circle().stroke(AppColors.border.opacity(0.3), lineWidth: 1))

                    Image(systemName: "flame.fill")
                        .font(.system(size: 28))
                        .foregroundColor(AppColors.mutedForeground)
                }
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
            }
            .padding(.vertical, 16)

            // Mode & Battery
            VStack(spacing: 4) {
                Text("Turbo Mode Active")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
                Text("Battery \(Int(batteryLevel * 100))%")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.mutedForeground)
            }
        }
    }

    // MARK: - Protect Banner
    private var protectBanner: some View {
        Button(action: {}) {
            HStack {
                HStack(spacing: 12) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)
                    Text("Protect your ring with UltrahumanX")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.primary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.mutedForeground)
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 2)
        }
    }

    // MARK: - Warranty Card
    private var warrantyCard: some View {
        HStack {
            Text("Ring Warranty")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.foreground)
            Spacer()
            Text("Valid till 5 Jun, 2026")
                .font(.system(size: 14))
                .foregroundColor(AppColors.mutedForeground)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 2)
    }

    // MARK: - Battery Mode Card
    private var batteryModeCard: some View {
        Button(action: {}) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Choose a battery usage mode")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.foreground)
                    Text("CURRENT: TURBO MODE")
                        .font(.system(size: 10, weight: .medium))
                        .tracking(1)
                        .foregroundColor(AppColors.primary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.mutedForeground)
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 2)
        }
    }

    // MARK: - Airplane Mode Card
    private var airplaneModeCard: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Airplane Mode")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.foreground)
                Text("Turns off all radio communications with the Ring. The Ring will still keep recording data on its own.")
                    .font(.system(size: 13))
                    .foregroundColor(AppColors.mutedForeground)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Toggle("", isOn: $airplaneMode)
                .labelsHidden()
                .tint(AppColors.primary)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 2)
    }

    // MARK: - Background Sync Card
    private var backgroundSyncCard: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Background Sync")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.foreground)
                Text("Allows the app to sync data with your ring in the background for up-to-date metrics.")
                    .font(.system(size: 13))
                    .foregroundColor(AppColors.mutedForeground)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Toggle("", isOn: $backgroundSync)
                .labelsHidden()
                .tint(AppColors.primary)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 2)
    }

    // MARK: - Firmware Card
    private var firmwareCard: some View {
        HStack {
            Text("Firmware Version")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.foreground)
            Spacer()
            Text("v2.4.1")
                .font(.system(size: 14))
                .foregroundColor(AppColors.mutedForeground)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    NavigationStack {
        MyRingView()
    }
}
