import SwiftUI

struct VoiceAIView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isListening = false
    @State private var inputText = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(
            isUser: false,
            text: "Hi! I'm Jade, your health AI assistant. I can help you understand your health data, provide personalized recommendations, and answer questions about your wellness journey. What would you like to know?"
        )
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Chat messages
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(messages) { message in
                                ChatBubble(message: message)
                            }
                        }
                        .padding()
                    }

                    // Suggestion chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            SuggestionChip(text: "How's my sleep?", action: { sendMessage("How's my sleep quality?") })
                            SuggestionChip(text: "Workout tips", action: { sendMessage("Give me workout tips based on my data") })
                            SuggestionChip(text: "Recovery status", action: { sendMessage("What's my recovery status?") })
                            SuggestionChip(text: "Stress levels", action: { sendMessage("How are my stress levels?") })
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }

                    // Input area
                    HStack(spacing: 12) {
                        // Text input
                        HStack {
                            TextField("Ask Jade anything...", text: $inputText)
                                .font(.system(size: 14))
                                .foregroundColor(AppColors.foreground)

                            if !inputText.isEmpty {
                                Button(action: { sendMessage(inputText) }) {
                                    Image(systemName: "arrow.up.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(AppColors.primary)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(AppColors.cardBackground)
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)

                        // Microphone button
                        Button(action: { toggleListening() }) {
                            ZStack {
                                Circle()
                                    .fill(isListening ? AppColors.primary : AppColors.cardBackground)
                                    .frame(width: 48, height: 48)
                                    .shadow(color: isListening ? AppColors.primary.opacity(0.4) : Color.black.opacity(0.04), radius: isListening ? 12 : 8)

                                Image(systemName: "mic.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(isListening ? .white : AppColors.primary)
                            }
                        }
                    }
                    .padding()
                    .background(AppColors.background)
                }
            }
            .navigationTitle("Jade AI")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppColors.foreground)
                            .frame(width: 32, height: 32)
                            .background(AppColors.cardBackground)
                            .clipShape(Circle())
                    }
                }

                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.primary)

                        Text("Jade AI")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppColors.foreground)

                        HStack(spacing: 4) {
                            Circle()
                                .fill(AppColors.recovery)
                                .frame(width: 6, height: 6)
                            Text("Online")
                                .font(.system(size: 10))
                                .foregroundColor(AppColors.recovery)
                        }
                    }
                }
            }
        }
    }

    private func toggleListening() {
        withAnimation(.spring(response: 0.3)) {
            isListening.toggle()
        }

        if isListening {
            // Simulate voice input after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isListening = false
                sendMessage("What can I do to improve my sleep?")
            }
        }
    }

    private func sendMessage(_ text: String) {
        let userMessage = ChatMessage(isUser: true, text: text)
        messages.append(userMessage)
        inputText = ""

        // Simulate AI response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let responses = [
                "Based on your recent data, I can see your sleep quality has been improving! Your deep sleep increased by 12% this week. To continue this trend, try maintaining a consistent bedtime and avoiding screens 1 hour before sleep.",
                "Your HRV data shows good recovery. I'd recommend a moderate intensity workout today. A 30-minute Zone 2 cardio session would be optimal.",
                "Looking at your stress patterns, I notice elevated levels in the afternoon. Consider taking short breathing breaks between 2-4 PM to help manage this.",
                "Your movement score is excellent! You've been consistently hitting your step goals. Keep it up!"
            ]
            let aiMessage = ChatMessage(isUser: false, text: responses.randomElement() ?? responses[0])
            messages.append(aiMessage)
        }
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let isUser: Bool
    let text: String
}

struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isUser {
                Spacer(minLength: 60)
            }

            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                if !message.isUser {
                    HStack(spacing: 6) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 10))
                            .foregroundColor(AppColors.primary)
                        Text("Jade")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(AppColors.mutedForeground)
                    }
                }

                Text(message.text)
                    .font(.system(size: 14))
                    .foregroundColor(message.isUser ? .white : AppColors.foreground)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(message.isUser ? AppColors.primary : AppColors.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
            }

            if !message.isUser {
                Spacer(minLength: 60)
            }
        }
    }
}

struct SuggestionChip: View {
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(AppColors.primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(AppColors.primary.opacity(0.1))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(AppColors.primary.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

#Preview {
    VoiceAIView()
        .preferredColorScheme(.light)
}
