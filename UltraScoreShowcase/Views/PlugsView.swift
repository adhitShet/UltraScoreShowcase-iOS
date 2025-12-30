import SwiftUI

struct PlugsView: View {
    private let integrations = [
        Integration(name: "Apple Health", icon: "heart.fill", color: AppColors.heartRate, isConnected: true),
        Integration(name: "Strava", icon: "figure.run", color: AppColors.movement, isConnected: true),
        Integration(name: "MyFitnessPal", icon: "fork.knife", color: AppColors.zone, isConnected: false),
        Integration(name: "Oura Ring", icon: "circle.hexagongrid.fill", color: AppColors.stress, isConnected: false),
        Integration(name: "Whoop", icon: "waveform.path.ecg", color: AppColors.recovery, isConnected: false),
        Integration(name: "Garmin", icon: "applewatch", color: AppColors.zone, isConnected: true)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Connected section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Connected")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(AppColors.foreground)

                            ForEach(integrations.filter { $0.isConnected }) { integration in
                                IntegrationRow(integration: integration)
                            }
                        }

                        // Available section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Available")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(AppColors.foreground)

                            ForEach(integrations.filter { !$0.isConnected }) { integration in
                                IntegrationRow(integration: integration)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Plugs")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct Integration: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let isConnected: Bool
}

struct IntegrationRow: View {
    let integration: Integration

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: integration.icon)
                .font(.system(size: 20))
                .foregroundColor(integration.color)
                .frame(width: 48, height: 48)
                .background(integration.color.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(integration.name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.foreground)

                Text(integration.isConnected ? "Connected" : "Tap to connect")
                    .font(.system(size: 12))
                    .foregroundColor(integration.isConnected ? AppColors.recovery : AppColors.mutedForeground)
            }

            Spacer()

            if integration.isConnected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(AppColors.recovery)
            } else {
                Image(systemName: "plus.circle")
                    .foregroundColor(AppColors.primary)
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    PlugsView()
        .preferredColorScheme(.light)
}
