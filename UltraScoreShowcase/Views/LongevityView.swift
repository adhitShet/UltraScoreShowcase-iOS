import SwiftUI

struct LongevityView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Biological Age Card
                        BiologicalAgeCard()

                        // Longevity Score
                        LongevityScoreCard()

                        // Key Markers
                        KeyMarkersCard()
                    }
                    .padding()
                }
            }
            .navigationTitle("Longevity")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct BiologicalAgeCard: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("BIOLOGICAL AGE")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(AppColors.mutedForeground)
                        .tracking(1)

                    HStack(alignment: .lastTextBaseline, spacing: 4) {
                        Text("28")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(AppColors.foreground)

                        Text("years")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.mutedForeground)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("Chronological")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)

                    Text("32 years")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(AppColors.foreground)
                }
            }

            HStack(spacing: 8) {
                Image(systemName: "arrow.down.circle.fill")
                    .foregroundColor(AppColors.recovery)

                Text("4 years younger")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.recovery)

                Spacer()
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
    }
}

struct LongevityScoreCard: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Longevity Score")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.foreground)

                Spacer()

                Text("85/100")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(AppColors.recovery)
            }

            // Progress segments
            GeometryReader { geometry in
                HStack(spacing: 4) {
                    ForEach(0..<10, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(index < 8 ? AppColors.recovery : AppColors.border)
                            .frame(height: 8)
                    }
                }
            }
            .frame(height: 8)

            HStack {
                Label("Excellent", systemImage: "checkmark.circle.fill")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.recovery)

                Spacer()

                Text("Top 15% for your age")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mutedForeground)
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
    }
}

struct KeyMarkersCard: View {
    private let markers = [
        ("Sleep Quality", "92%", AppColors.stress),
        ("Activity Index", "88%", AppColors.recovery),
        ("Recovery Score", "76%", AppColors.zone),
        ("Stress Management", "81%", AppColors.movement)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Key Markers")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppColors.foreground)

            ForEach(markers, id: \.0) { marker in
                HStack {
                    Text(marker.0)
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.foreground)

                    Spacer()

                    Text(marker.1)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(marker.2)
                }
                .padding()
                .background(marker.2.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
    }
}

#Preview {
    LongevityView()
        .preferredColorScheme(.light)
}
