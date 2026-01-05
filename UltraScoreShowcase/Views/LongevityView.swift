import SwiftUI

struct LongevityView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    let ultraAge = 28
    let chronologicalAge = 32

    var ageDifference: Int { ultraAge - chronologicalAge }
    var isYounger: Bool { ageDifference < 0 }

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Ultra Age Ring Section
                        ultraAgeSection

                        // Areas of Improvement
                        improvementSection

                        // Lab Tests CTA
                        LabTestsCTAView()
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: - Ultra Age Section (Fullscreen Ring)
    private var ultraAgeSection: some View {
        VStack(spacing: 24) {
            // Ultra Age Ring - Fullscreen Width
            UltraAgeRing(ultraAge: ultraAge, chronologicalAge: chronologicalAge)
                .frame(maxWidth: .infinity)
                .padding(.top, 20)

            // Age comparison badge
            HStack(spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: isYounger ? "arrow.down.right" : "arrow.up.right")
                        .font(.system(size: 14))

                    Text("\(abs(ageDifference)) years \(isYounger ? "younger" : "older")")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(isYounger ? AppColors.recovery : Color.red)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background((isYounger ? AppColors.recovery : Color.red).opacity(0.15))
                .clipShape(Capsule())

                Text("vs \(chronologicalAge) actual")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.mutedForeground)
            }

            // Age Contributors Card
            ageContributorsSection
                .padding(20)
                .background(AppColors.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 12, x: 0, y: 4)
        }
    }

    // MARK: - Age Contributors
    private var ageContributorsSection: some View {
        HStack(spacing: 24) {
            AgeContributorView(title: "Pulse Age", age: 27, icon: "heart.fill", color: AppColors.heartRate)
            AgeContributorView(title: "Blood Age", age: 29, icon: "drop.fill", color: AppColors.recovery)
            AgeContributorView(title: "Brain Age", age: 28, icon: "brain.head.profile", color: AppColors.stress)
        }
        .padding(.top, 12)
    }

    // MARK: - Improvement Section
    private var improvementSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.primary)

                Text("Slow Your Aging")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.foreground)
            }
            .padding(.horizontal, 4)

            VStack(spacing: 8) {
                ImprovementCard(
                    title: "Sleep Quality",
                    impact: "-0.8 years",
                    description: "Improve deep sleep by 15% to reduce biological age",
                    icon: "moon.fill",
                    color: AppColors.recovery
                )
                ImprovementCard(
                    title: "Stress Management",
                    impact: "-0.5 years",
                    description: "Lower HRV variability through meditation",
                    icon: "brain.head.profile",
                    color: AppColors.stress
                )
                ImprovementCard(
                    title: "Movement Index",
                    impact: "-0.3 years",
                    description: "Add 2,000 daily steps to optimize metabolism",
                    icon: "figure.walk",
                    color: AppColors.workout
                )
                ImprovementCard(
                    title: "Metabolic Health",
                    impact: "-0.4 years",
                    description: "Reduce glucose spikes with meal timing",
                    icon: "fork.knife",
                    color: AppColors.movement
                )
                ImprovementCard(
                    title: "Cardiovascular",
                    impact: "-0.2 years",
                    description: "Increase Zone 2 cardio to 150 min/week",
                    icon: "heart.fill",
                    color: AppColors.heartRate
                )
            }
        }
    }
}

// MARK: - Ultra Age Ring (Fullscreen Width)
struct UltraAgeRing: View {
    let ultraAge: Int
    let chronologicalAge: Int

    @State private var outerRingRotation: Double = 0
    @State private var secondaryRingRotation: Double = 0
    @State private var glowOpacity: Double = 0.3
    @State private var glowScale: CGFloat = 0.95
    @State private var progressAnimation: CGFloat = 0
    @State private var particleOpacities: [Double] = Array(repeating: 0, count: 8)
    @State private var showContent = false

    var isYounger: Bool { ultraAge < chronologicalAge }

    // Larger ring sizes for fullscreen effect
    private let ringSize: CGFloat = 280
    private let progressRingSize: CGFloat = 220
    private let glowRingSize: CGFloat = 250

    var body: some View {
        ZStack {
            // Outer glow effect
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            (isYounger ? AppColors.recovery : Color.red).opacity(0.2),
                            AppColors.primary.opacity(0.1),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: progressRingSize / 2,
                        endRadius: ringSize
                    )
                )
                .frame(width: ringSize + 80, height: ringSize + 80)
                .scaleEffect(glowScale)
                .opacity(glowOpacity)

            // Animated rings
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)

                // Outermost cryptic ring
                let outerPath = Path { path in
                    path.addArc(center: center, radius: ringSize / 2, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
                }
                context.stroke(outerPath, with: .color(AppColors.primary.opacity(0.3)), style: StrokeStyle(lineWidth: 1, dash: [8, 12, 4, 8]))

                // Secondary ring
                let secondaryPath = Path { path in
                    path.addArc(center: center, radius: (ringSize / 2) - 10, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
                }
                context.stroke(secondaryPath, with: .color(AppColors.mutedForeground.opacity(0.2)), style: StrokeStyle(lineWidth: 0.5, dash: [3, 8]))
            }
            .frame(width: ringSize, height: ringSize)
            .rotationEffect(.degrees(outerRingRotation))

            // Pulsing glow ring
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [isYounger ? AppColors.recovery : Color.red, AppColors.primary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 3
                )
                .frame(width: glowRingSize, height: glowRingSize)
                .opacity(glowOpacity)
                .blur(radius: 1)

            // Background ring
            Circle()
                .stroke(AppColors.border.opacity(0.15), lineWidth: 8)
                .frame(width: progressRingSize, height: progressRingSize)

            // Progress ring
            Circle()
                .trim(from: 0, to: progressAnimation * CGFloat(ultraAge) / 100)
                .stroke(
                    LinearGradient(
                        colors: [AppColors.primary, isYounger ? AppColors.recovery : Color.red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: progressRingSize, height: progressRingSize)
                .rotationEffect(.degrees(-90))
                .shadow(color: (isYounger ? AppColors.recovery : Color.red).opacity(0.4), radius: 8)

            // Floating particles
            ForEach(0..<8, id: \.self) { i in
                Circle()
                    .fill(AppColors.primary.opacity(0.7))
                    .frame(width: 4, height: 4)
                    .offset(
                        x: cos(CGFloat(i) * .pi * 2 / 8) * (glowRingSize / 2 + 8),
                        y: sin(CGFloat(i) * .pi * 2 / 8) * (glowRingSize / 2 + 8)
                    )
                    .opacity(particleOpacities[i])
            }

            // Center content
            VStack(spacing: 6) {
                Text("ULTRA AGE")
                    .font(.system(size: 12, weight: .semibold))
                    .tracking(3)
                    .foregroundColor(AppColors.mutedForeground)

                Text("\(ultraAge)")
                    .font(.system(size: 72, weight: .ultraLight))
                    .foregroundColor(AppColors.foreground)

                Text("years")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.mutedForeground)
            }
            .opacity(showContent ? 1 : 0)
            .scaleEffect(showContent ? 1 : 0.8)
        }
        .frame(height: ringSize + 60)
        .onAppear {
            startAnimations()
        }
    }

    private func startAnimations() {
        // Rotate outer ring
        withAnimation(.linear(duration: 120).repeatForever(autoreverses: false)) {
            outerRingRotation = 360
        }

        // Pulsing glow
        withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
            glowOpacity = 0.6
            glowScale = 1.05
        }

        // Progress animation
        withAnimation(.easeOut(duration: 2).delay(0.5)) {
            progressAnimation = 1
        }

        // Show content
        withAnimation(.spring(response: 0.6).delay(0.8)) {
            showContent = true
        }

        // Particle animations
        for i in 0..<8 {
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true).delay(Double(i) * 0.3)) {
                particleOpacities[i] = 1
            }
        }
    }
}

// MARK: - Age Contributor View
struct AgeContributorView: View {
    let title: String
    let age: Int
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .frame(width: 56, height: 56)
                .background(color.opacity(0.15))
                .clipShape(Circle())

            Text("\(age)")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(AppColors.foreground)

            Text(title)
                .font(.system(size: 10))
                .foregroundColor(AppColors.mutedForeground)
        }
    }
}

// MARK: - Improvement Card
struct ImprovementCard: View {
    let title: String
    let impact: String
    let description: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.foreground)

                    Spacer()

                    Text(impact)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.recovery)
                }

                Text(description)
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mutedForeground)
                    .lineLimit(1)
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(ThemeManager.shared.isDarkMode ? 0.25 : 0.02), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Lab Tests CTA View
struct LabTestsCTAView: View {
    @State private var isExpanded = false

    let labTests = [
        LabTest(title: "Blood Test", description: "CBC, metabolic panel, lipids", icon: "testtube.2", color: AppColors.recovery, hasSchedule: true),
        LabTest(title: "Telomere Test", description: "Cellular aging markers", icon: "dna", color: AppColors.stress, hasSchedule: false),
        LabTest(title: "Lab VO2 Max", description: "Cardiorespiratory fitness", icon: "wind", color: AppColors.workout, hasSchedule: false)
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button(action: {
                withAnimation(.spring(response: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.up.doc.fill")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.primary)

                        Text("Improve Age Accuracy")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppColors.foreground)
                    }

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(20)
            }

            // Expandable content
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Upload lab reports to refine your Ultra Age calculation with clinical biomarkers.")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)

                    ForEach(labTests, id: \.title) { test in
                        LabTestRow(test: test)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(ThemeManager.shared.isDarkMode ? 0.3 : 0.04), radius: 12, x: 0, y: 4)
    }
}

struct LabTest {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let hasSchedule: Bool
}

struct LabTestRow: View {
    let test: LabTest

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: test.icon)
                .font(.system(size: 18))
                .foregroundColor(test.color)
                .frame(width: 40, height: 40)
                .background(test.color.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 2) {
                Text(test.title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.foreground)

                Text(test.description)
                    .font(.system(size: 11))
                    .foregroundColor(AppColors.mutedForeground)
            }

            Spacer()

            HStack(spacing: 8) {
                if test.hasSchedule {
                    Button(action: {}) {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.system(size: 10))
                            Text("Book")
                                .font(.system(size: 11, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(AppColors.primary)
                        .clipShape(Capsule())
                    }
                }

                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.doc")
                            .font(.system(size: 10))
                        Text("Upload")
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundColor(AppColors.primary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(AppColors.primary.opacity(0.1))
                    .clipShape(Capsule())
                }
            }
        }
        .padding(12)
        .background(AppColors.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    LongevityView()
        .preferredColorScheme(.light)
}
