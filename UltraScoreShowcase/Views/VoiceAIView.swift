import SwiftUI

struct VoiceAIView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isListening = false
    @State private var inputText = ""
    @State private var messages: [OrbChatMessage] = []
    @State private var visibleMessageCount = 0

    // Background orb animations
    @State private var orb1Scale: CGFloat = 1.0
    @State private var orb1Offset: CGSize = .zero
    @State private var orb2Scale: CGFloat = 1.2
    @State private var orb2Offset: CGSize = .zero
    @State private var orb3Scale: CGFloat = 1.0
    @State private var orb3Opacity: Double = 0.3

    let dummyConversation: [OrbChatMessage] = [
        OrbChatMessage(isUser: true, text: "I got my blood panel back. Can you cross-reference it with my wearable data?"),
        OrbChatMessage(isUser: false, text: "Interesting findings. Your homocysteine is elevated at 14.2 µmol/L. Cross-referencing with your genetics—you carry the MTHFR C677T variant which impairs folate metabolism. Your HRV dips of 15% on high-stress days correlate with this methylation inefficiency. Consider methylated B-vitamins."),
        OrbChatMessage(isUser: true, text: "What about my ApoB levels? My doctor mentioned it."),
        OrbChatMessage(isUser: false, text: "Your ApoB is 98 mg/dL—borderline. However, your genetic profile shows PCSK9 loss-of-function variant, which is cardioprotective. Combined with your consistently low resting HR of 52 bpm and excellent VO2 max proxy from your wearable, your actual cardiovascular risk is lower than the number suggests."),
        OrbChatMessage(isUser: true, text: "How does my sleep affect my blood glucose?"),
        OrbChatMessage(isUser: false, text: "Strong correlation detected. Nights with less than 1h 20m of deep sleep show a 12mg/dL higher fasting glucose the next morning. Your CGM data confirms this—your glucose variability index spikes 23% after poor sleep.")
    ]

    var body: some View {
        ZStack {
            // Animated Background
            animatedBackground

            VStack(spacing: 0) {
                // Header
                headerSection

                // Voice Orb
                voiceOrbSection

                // Conversation
                conversationSection

                Spacer()
            }

            // Bottom gradient fade
            VStack {
                Spacer()
                LinearGradient(
                    colors: [Color.clear, AppColors.background],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 100)
            }
            .ignoresSafeArea()
        }
        .background(AppColors.background)
        .onAppear {
            startBackgroundAnimations()
            animateMessages()
        }
    }

    // MARK: - Animated Background
    private var animatedBackground: some View {
        GeometryReader { geometry in
            ZStack {
                // Orb 1 - Primary color
                Circle()
                    .fill(AppColors.primary.opacity(0.2))
                    .frame(width: 300, height: 300)
                    .blur(radius: 80)
                    .scaleEffect(orb1Scale)
                    .offset(orb1Offset)
                    .position(x: geometry.size.width * 0.3, y: geometry.size.height * 0.25)

                // Orb 2 - Recovery color
                Circle()
                    .fill(AppColors.recovery.opacity(0.2))
                    .frame(width: 250, height: 250)
                    .blur(radius: 60)
                    .scaleEffect(orb2Scale)
                    .offset(orb2Offset)
                    .position(x: geometry.size.width * 0.7, y: geometry.size.height * 0.6)

                // Orb 3 - Movement color
                Circle()
                    .fill(AppColors.movement.opacity(orb3Opacity * 0.5))
                    .frame(width: 400, height: 400)
                    .blur(radius: 100)
                    .scaleEffect(orb3Scale)
                    .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5)
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.foreground)
                    .frame(width: 40, height: 40)
                    .background(AppColors.cardBackground.opacity(0.8))
                    .clipShape(Circle())
            }

            Spacer()

            HStack(spacing: 8) {
                Circle()
                    .fill(AppColors.recovery)
                    .frame(width: 8, height: 8)
                    .overlay(
                        Circle()
                            .fill(AppColors.recovery)
                            .frame(width: 8, height: 8)
                            .scaleEffect(isListening ? 1.5 : 1.0)
                            .opacity(isListening ? 0 : 1)
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: false), value: isListening)
                    )

                Text("Jade 1.5 Active")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mutedForeground)
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    // MARK: - Voice Orb Section
    private var voiceOrbSection: some View {
        VStack(spacing: 24) {
            ZStack {
                // Outer pulsing rings
                ForEach(0..<3, id: \.self) { i in
                    PulsingRing(index: i, isListening: isListening)
                }

                // Main orb button
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        isListening.toggle()
                    }
                    if isListening {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            isListening = false
                        }
                    }
                }) {
                    ZStack {
                        // Outer glow
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [AppColors.primary.opacity(0.8), AppColors.primary.opacity(0.3), AppColors.primary.opacity(0)],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 66
                                )
                            )
                            .frame(width: 132, height: 132)
                            .scaleEffect(isListening ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isListening)

                        // Core orb
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [AppColors.primary, AppColors.recovery],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: isListening ? 70 : 60, height: isListening ? 70 : 60)
                            .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isListening)
                            .shadow(color: AppColors.primary.opacity(0.5), radius: 20, x: 0, y: 0)

                        // Inner bright core
                        Circle()
                            .fill(AppColors.primary)
                            .frame(width: isListening ? 35 : 30, height: isListening ? 35 : 30)
                            .animation(.easeInOut(duration: 0.3).repeatForever(autoreverses: true), value: isListening)

                        // Frequency bars when listening
                        if isListening {
                            FrequencyBars()
                        }
                    }
                }
            }
            .frame(width: 200, height: 200)

            Text(isListening ? "Listening..." : "Tap to speak")
                .font(.system(size: 14))
                .foregroundColor(AppColors.mutedForeground)
        }
        .padding(.vertical, 20)
    }

    // MARK: - Conversation Section
    private var conversationSection: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(Array(messages.prefix(visibleMessageCount).enumerated()), id: \.element.id) { index, message in
                    OrbMessageBubble(message: message)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .bottom)),
                            removal: .opacity
                        ))
                }
            }
            .padding(.horizontal)
        }
        .frame(maxHeight: UIScreen.main.bounds.height * 0.4)
    }

    // MARK: - Animations
    private func startBackgroundAnimations() {
        // Orb 1 animation
        withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
            orb1Scale = 1.2
            orb1Offset = CGSize(width: 30, height: -20)
        }

        // Orb 2 animation
        withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true).delay(1)) {
            orb2Scale = 1.0
            orb2Offset = CGSize(width: -40, height: 30)
        }

        // Orb 3 animation
        withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true).delay(2)) {
            orb3Scale = 1.3
            orb3Opacity = 0.5
        }
    }

    private func animateMessages() {
        messages = dummyConversation
        for i in 0..<dummyConversation.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 1.2) {
                withAnimation(.spring(response: 0.4)) {
                    visibleMessageCount = i + 1
                }
            }
        }
    }
}

// MARK: - Pulsing Ring
struct PulsingRing: View {
    let index: Int
    let isListening: Bool

    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.3

    var body: some View {
        Circle()
            .stroke(
                LinearGradient(
                    colors: [AppColors.primary.opacity(0.6), AppColors.recovery.opacity(0.4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 2 - CGFloat(index) * 0.5
            )
            .frame(width: 140 + CGFloat(index) * 40, height: 140 + CGFloat(index) * 40)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: isListening ? 1.5 + Double(index) * 0.3 : 3.0 + Double(index) * 0.5)
                    .repeatForever(autoreverses: true)
                    .delay(Double(index) * 0.2)
                ) {
                    scale = isListening ? 1.3 + CGFloat(index) * 0.15 : 1.15 + CGFloat(index) * 0.1
                    opacity = isListening ? 0.1 : 0.15
                }
            }
            .onChange(of: isListening) { _, newValue in
                withAnimation(
                    .easeInOut(duration: newValue ? 1.5 + Double(index) * 0.3 : 3.0 + Double(index) * 0.5)
                    .repeatForever(autoreverses: true)
                ) {
                    scale = newValue ? 1.5 + CGFloat(index) * 0.2 : 1.15 + CGFloat(index) * 0.1
                    opacity = newValue ? 0.05 : 0.15
                }
            }
    }
}

// MARK: - Frequency Bars
struct FrequencyBars: View {
    @State private var heights: [CGFloat] = [6, 6, 6, 6, 6]

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<5, id: \.self) { i in
                RoundedRectangle(cornerRadius: 1.5)
                    .fill(Color.white)
                    .frame(width: 3, height: heights[i])
            }
        }
        .onAppear {
            for i in 0..<5 {
                withAnimation(
                    .easeInOut(duration: 0.3 + Double(i) * 0.05)
                    .repeatForever(autoreverses: true)
                    .delay(Double(i) * 0.08)
                ) {
                    heights[i] = CGFloat.random(in: 8...18)
                }
            }
        }
    }
}

// MARK: - Orb Chat Message
struct OrbChatMessage: Identifiable {
    let id = UUID()
    let isUser: Bool
    let text: String
}

// MARK: - Orb Message Bubble
struct OrbMessageBubble: View {
    let message: OrbChatMessage

    var body: some View {
        HStack {
            if message.isUser {
                Spacer(minLength: 60)
            }

            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                if !message.isUser {
                    HStack(spacing: 6) {
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
                    .lineSpacing(4)
                    .foregroundColor(message.isUser ? .white : AppColors.foreground.opacity(0.9))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        message.isUser
                            ? AnyShapeStyle(AppColors.primary)
                            : AnyShapeStyle(AppColors.cardBackground.opacity(0.8))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(message.isUser ? Color.clear : AppColors.border.opacity(0.3), lineWidth: 1)
                    )
            }

            if !message.isUser {
                Spacer(minLength: 60)
            }
        }
    }
}

#Preview {
    VoiceAIView()
        .preferredColorScheme(.light)
}
