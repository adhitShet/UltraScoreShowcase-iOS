import SwiftUI

struct HealthIntelligenceCard: View {
    @ObservedObject private var themeManager = ThemeManager.shared

    @State private var isExpanded = false
    @State private var currentInsightIndex = 0
    @State private var showVoiceAI = false

    private let insights = [
        InsightData(
            type: "Real-time",
            icon: "bolt.fill",
            iconColor: AppColors.primary,
            title: "Take a 20-min walk",
            points: "+8",
            description: "You've been inactive for 3hrs since waking. Given your \"Move More\" goal and the current 18°C weather, a brisk outdoor walk would maximize your movement score before your afternoon meetings."
        ),
        InsightData(
            type: "Deep Analysis",
            icon: "brain.head.profile",
            iconColor: AppColors.recovery,
            title: "Low ferritin pattern",
            points: nil,
            description: "Your last panel showed borderline ferritin (38 ng/mL). Cross-referencing 6 weeks of wearable data reveals 11% lower HRV and elevated resting HR on high-strain days—consistent with suboptimal iron stores."
        )
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Header - Always visible
            Button(action: {
                withAnimation(.spring(response: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        HStack(spacing: 6) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.primary)

                            Text("BIO INTELLIGENCE")
                                .font(.system(size: 11, weight: .semibold))
                                .tracking(1)
                                .foregroundColor(AppColors.foreground)
                        }

                        Spacer()

                        HStack(spacing: 8) {
                            // Model badge
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(AppColors.primary)
                                    .frame(width: 6, height: 6)

                                Text("Jade 1.0")
                                    .font(.system(size: 10))
                                    .foregroundColor(AppColors.mutedForeground)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(AppColors.background)
                            .clipShape(Capsule())

                            Image(systemName: "chevron.down")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.mutedForeground)
                                .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        }
                    }

                    // Collapsed summary items
                    if !isExpanded {
                        VStack(spacing: 8) {
                            InsightSummaryRow(
                                icon: "bolt.fill",
                                iconColor: AppColors.primary,
                                text: "Take a 20-min walk"
                            )

                            InsightSummaryRow(
                                icon: "target",
                                iconColor: AppColors.recovery,
                                text: "Low ferritin pattern",
                                suffix: "trend detected",
                                suffixColor: AppColors.recovery
                            )
                        }
                    }
                }
            }
            .buttonStyle(.plain)

            // Expanded content
            if isExpanded {
                VStack(spacing: 16) {
                    // Insight card
                    InsightDetailCard(insight: insights[currentInsightIndex])

                    // Pagination
                    if insights.count > 1 {
                        HStack {
                            Text("\(currentInsightIndex + 1)/\(insights.count) insights")
                                .font(.system(size: 10))
                                .foregroundColor(AppColors.mutedForeground)

                            Spacer()

                            if currentInsightIndex < insights.count - 1 {
                                Button(action: {
                                    withAnimation(.spring(response: 0.3)) {
                                        currentInsightIndex += 1
                                    }
                                }) {
                                    HStack(spacing: 4) {
                                        Text("Next")
                                            .font(.system(size: 12, weight: .medium))
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 10))
                                    }
                                    .foregroundColor(AppColors.foreground)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(AppColors.background)
                                    .clipShape(Capsule())
                                }
                            } else {
                                Button(action: {
                                    withAnimation(.spring(response: 0.3)) {
                                        currentInsightIndex = 0
                                    }
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "chevron.left")
                                            .font(.system(size: 10))
                                        Text("Previous")
                                            .font(.system(size: 12, weight: .medium))
                                    }
                                    .foregroundColor(AppColors.foreground)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(AppColors.background)
                                    .clipShape(Capsule())
                                }
                            }
                        }
                    }

                    // Action buttons
                    HStack(spacing: 8) {
                        Button(action: { showVoiceAI = true }) {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 8, height: 8)
                                Text("Ask Jade anything")
                                    .font(.system(size: 12, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(AppColors.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        Button(action: {}) {
                            Image(systemName: "bookmark")
                                .font(.system(size: 16))
                                .foregroundColor(AppColors.mutedForeground)
                                .frame(width: 40, height: 40)
                                .background(AppColors.background)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                .padding(.top, 16)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(ThemeManager.shared.isDarkMode ? 0.3 : 0.04), radius: 12, x: 0, y: 4)
        .fullScreenCover(isPresented: $showVoiceAI) {
            VoiceAIView()
        }
    }
}

struct InsightData {
    let type: String
    let icon: String
    let iconColor: Color
    let title: String
    let points: String?
    let description: String
}

struct InsightSummaryRow: View {
    let icon: String
    let iconColor: Color
    let text: String
    var suffix: String? = nil
    var suffixColor: Color = AppColors.mutedForeground

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)
                .background(iconColor.opacity(0.15))
                .clipShape(Circle())

            Text(text)
                .font(.system(size: 14))
                .foregroundColor(AppColors.foreground)

            if let suffix = suffix {
                Text("· \(suffix)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(suffixColor)
            }

            Spacer()
        }
    }
}

struct InsightDetailCard: View {
    let insight: InsightData

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: insight.icon)
                        .font(.system(size: 10))
                        .foregroundColor(insight.iconColor)

                    Text(insight.type.uppercased())
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(insight.iconColor)
                        .tracking(0.5)
                }

                Spacer()

                if let points = insight.points {
                    HStack(spacing: 2) {
                        Text(points)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(AppColors.primary)
                        Text("pts")
                            .font(.system(size: 10))
                            .foregroundColor(AppColors.primary.opacity(0.8))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppColors.primary.opacity(0.15))
                    .clipShape(Capsule())
                }
            }

            HStack(spacing: 10) {
                Image(systemName: insight.icon)
                    .font(.system(size: 16))
                    .foregroundColor(insight.iconColor)
                    .frame(width: 32, height: 32)
                    .background(insight.iconColor.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                Text(insight.title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.foreground)
            }

            Text(insight.description)
                .font(.system(size: 13))
                .foregroundColor(AppColors.mutedForeground)
                .lineSpacing(4)

            // Action buttons
            HStack {
                Spacer()

                Button(action: {}) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)
                        .frame(width: 28, height: 28)
                        .background(AppColors.background)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                Button(action: {}) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.recovery)
                        .frame(width: 28, height: 28)
                        .background(AppColors.recovery.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding()
        .background(AppColors.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ZStack {
        AppColors.background.ignoresSafeArea()
        HealthIntelligenceCard()
            .padding()
    }
    .preferredColorScheme(.light)
}
