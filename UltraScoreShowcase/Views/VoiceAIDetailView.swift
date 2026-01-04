import SwiftUI

struct VoiceChatMessage: Identifiable {
    let id = UUID()
    let role: VoiceChatRole
    let text: String

    enum VoiceChatRole {
        case user
        case ai
    }
}

struct VoiceAIDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isListening = false
    @State private var visibleMessages: [VoiceChatMessage] = []
    @State private var pulseAnimation = false

    private let dummyConversation: [VoiceChatMessage] = [
        VoiceChatMessage(role: .user, text: "I got my blood panel back. Can you cross-reference it with my wearable data?"),
        VoiceChatMessage(role: .ai, text: "Interesting findings. Your homocysteine is elevated at 14.2 µmol/L. Cross-referencing with your genetics—you carry the MTHFR C677T variant which impairs folate metabolism. Your HRV dips of 15% on high-stress days correlate with this methylation inefficiency. Consider methylated B-vitamins."),
        VoiceChatMessage(role: .user, text: "What about my ApoB levels? My doctor mentioned it."),
        VoiceChatMessage(role: .ai, text: "Your ApoB is 98 mg/dL—borderline. However, your genetic profile shows PCSK9 loss-of-function variant, which is cardioprotective. Combined with your consistently low resting HR of 52 bpm and excellent VO2 max proxy from your wearable, your actual cardiovascular risk is lower than the number suggests."),
        VoiceChatMessage(role: .user, text: "How does my sleep affect my blood glucose?"),
        VoiceChatMessage(role: .ai, text: "Strong correlation detected. Nights with less than 1h 20m of deep sleep show a 12mg/dL higher fasting glucose the next morning. Your CGM data confirms this—your glucose variability index spikes 23% after poor sleep.")
    ]

    var body: some View {
        ZStack {
            // Animated Background
            backgroundGradients

            VStack(spacing: 0) {
                // Header
                header

                // Voice Animation
                voiceOrbSection

                // Conversation
                conversationSection

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            startMessageAnimation()
        }
    }

    // MARK: - Background
    private var backgroundGradients: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            // Gradient orbs
            Circle()
                .fill(AppColors.primary.opacity(0.2))
                .blur(radius: 80)
                .frame(width: 250, height: 250)
                .offset(x: -50, y: -100)
                .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 8).repeatForever(autoreverses: true), value: pulseAnimation)

            Circle()
                .fill(AppColors.recovery.opacity(0.2))
                .blur(radius: 60)
                .frame(width: 200, height: 200)
                .offset(x: 80, y: 200)
                .scaleEffect(pulseAnimation ? 1.0 : 1.3)
                .animation(.easeInOut(duration: 10).repeatForever(autoreverses: true), value: pulseAnimation)

            Circle()
                .fill(AppColors.movement.opacity(0.1))
                .blur(radius: 100)
                .frame(width: 300, height: 300)
                .scaleEffect(pulseAnimation ? 1.3 : 1.0)
                .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: pulseAnimation)
        }
        .onAppear {
            pulseAnimation = true
        }
    }

    // MARK: - Header
    private var header: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.foreground)
                    .frame(width: 40, height: 40)
                    .background(AppColors.cardBackground.opacity(0.5))
                    .clipShape(Circle())
            }

            Spacer()

            HStack(spacing: 6) {
                Circle()
                    .fill(AppColors.recovery)
                    .frame(width: 8, height: 8)
                Text("Jade 1.5 Active")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mutedForeground)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    // MARK: - Voice Orb Section
    private var voiceOrbSection: some View {
        VStack(spacing: 20) {
            ZStack {
                // Outer pulsing rings
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .stroke(AppColors.primary.opacity(0.3 - Double(i) * 0.08), lineWidth: 2 - Double(i) * 0.5)
                        .frame(width: 140 + CGFloat(i) * 50, height: 140 + CGFloat(i) * 50)
                        .scaleEffect(isListening ? 1.8 + CGFloat(i) * 0.3 : 1.3 + CGFloat(i) * 0.15)
                        .opacity(isListening ? 0.5 - Double(i) * 0.12 : 0.3 - Double(i) * 0.08)
                        .animation(
                            .easeInOut(duration: isListening ? 1.5 + Double(i) * 0.3 : 3.0 + Double(i) * 0.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.2),
                            value: isListening
                        )
                }

                // Core orb button
                Button(action: { isListening.toggle() }) {
                    ZStack {
                        // Outer glow
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [AppColors.primary.opacity(0.8), AppColors.primary.opacity(0)],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 60
                                )
                            )
                            .frame(width: 120, height: 120)
                            .scaleEffect(isListening ? 1.1 : 0.95)
                            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isListening)

                        // Inner bright core
                        Circle()
                            .fill(AppColors.primary)
                            .frame(width: isListening ? 50 : 45, height: isListening ? 50 : 45)
                            .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isListening)

                        // Frequency bars when listening
                        if isListening {
                            HStack(spacing: 3) {
                                ForEach(0..<5, id: \.self) { i in
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color.white)
                                        .frame(width: 3, height: CGFloat.random(in: 8...20))
                                        .animation(
                                            .easeInOut(duration: 0.3 + Double(i) * 0.05)
                                            .repeatForever(autoreverses: true)
                                            .delay(Double(i) * 0.08),
                                            value: isListening
                                        )
                                }
                            }
                        }
                    }
                }
                .frame(width: 130, height: 130)
            }

            Text(isListening ? "Listening..." : "Tap to speak")
                .font(.system(size: 14))
                .foregroundColor(AppColors.mutedForeground)
        }
        .padding(.vertical, 24)
    }

    // MARK: - Conversation Section
    private var conversationSection: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(visibleMessages) { message in
                    VoiceMessageBubble(message: message)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .bottom)),
                            removal: .opacity
                        ))
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
        }
        .frame(maxHeight: UIScreen.main.bounds.height * 0.45)
    }

    private func startMessageAnimation() {
        for (index, message) in dummyConversation.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 1.2) {
                withAnimation(.spring(response: 0.4)) {
                    visibleMessages.append(message)
                }
            }
        }
    }
}

// MARK: - Message Bubble
struct VoiceMessageBubble: View {
    let message: VoiceChatMessage

    var body: some View {
        HStack {
            if message.role == .user {
                Spacer(minLength: 40)
            }

            VStack(alignment: .leading, spacing: 6) {
                if message.role == .ai {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(AppColors.primary)
                            .frame(width: 6, height: 6)
                        Text("Jade")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(AppColors.primary)
                    }
                }

                Text(message.text)
                    .font(.system(size: 14))
                    .foregroundColor(message.role == .user ? .white : AppColors.foreground.opacity(0.9))
                    .lineSpacing(4)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(message.role == .user ? AppColors.primary : AppColors.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(message.role == .ai ? AppColors.border.opacity(0.3) : Color.clear, lineWidth: 1)
            )

            if message.role == .ai {
                Spacer(minLength: 40)
            }
        }
    }
}

#Preview {
    NavigationStack {
        VoiceAIDetailView()
    }
}
