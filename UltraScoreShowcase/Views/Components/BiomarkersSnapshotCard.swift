import SwiftUI

struct Biomarker: Identifiable {
    let id = UUID()
    let icon: String
    let label: String
    let value: String
    let unit: String
    let bgColor: Color
    let iconColor: Color
}

struct BiomarkersSnapshotCard: View {
    private let biomarkers: [Biomarker] = [
        Biomarker(icon: "moon.fill", label: "Sleep Duration", value: "7h 23m", unit: "", bgColor: AppColors.stress.opacity(0.15), iconColor: AppColors.stress),
        Biomarker(icon: "waveform.path.ecg", label: "HRV", value: "48", unit: "ms", bgColor: AppColors.recovery.opacity(0.15), iconColor: AppColors.recovery),
        Biomarker(icon: "heart.fill", label: "RHR", value: "58", unit: "bpm", bgColor: AppColors.workout.opacity(0.15), iconColor: AppColors.workout),
        Biomarker(icon: "timer", label: "Active Time", value: "2h 15m", unit: "", bgColor: AppColors.heartRate.opacity(0.15), iconColor: AppColors.heartRate),
        Biomarker(icon: "wind", label: "VO2 Max", value: "42", unit: "ml/kg", bgColor: AppColors.zone.opacity(0.15), iconColor: AppColors.zone),
        Biomarker(icon: "bed.double.fill", label: "Deep Sleep", value: "22", unit: "%", bgColor: AppColors.movement.opacity(0.15), iconColor: AppColors.movement)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Biomarkers Snapshot")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppColors.foreground)

            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("6 markers need attention")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.foreground)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)
                }
                .padding(.bottom, 16)

                // Grid
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 12) {
                    ForEach(biomarkers) { marker in
                        BiomarkerRow(biomarker: marker)
                    }
                }
            }
            .padding(20)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
        }
    }
}

struct BiomarkerRow: View {
    let biomarker: Biomarker

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: biomarker.icon)
                .font(.system(size: 18))
                .foregroundColor(biomarker.iconColor)
                .frame(width: 40, height: 40)
                .background(biomarker.bgColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Text(biomarker.value)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(AppColors.foreground)

                    if !biomarker.unit.isEmpty {
                        Text(biomarker.unit)
                            .font(.system(size: 10))
                            .foregroundColor(AppColors.mutedForeground)
                    }
                }

                Text(biomarker.label)
                    .font(.system(size: 10))
                    .foregroundColor(AppColors.mutedForeground)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 10))
                .foregroundColor(AppColors.mutedForeground)
        }
        .padding(10)
        .background(AppColors.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ZStack {
        AppColors.background.ignoresSafeArea()
        BiomarkersSnapshotCard()
            .padding()
    }
    .preferredColorScheme(.light)
}
