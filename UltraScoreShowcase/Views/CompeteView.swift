import SwiftUI

struct CompeteView: View {
    private let leaderboard = [
        LeaderboardEntry(rank: 1, name: "Sarah M.", score: 94, avatar: "person.circle.fill", isCurrentUser: false),
        LeaderboardEntry(rank: 2, name: "Mike T.", score: 91, avatar: "person.circle.fill", isCurrentUser: false),
        LeaderboardEntry(rank: 3, name: "You", score: 88, avatar: "person.circle.fill", isCurrentUser: true),
        LeaderboardEntry(rank: 4, name: "Alex K.", score: 85, avatar: "person.circle.fill", isCurrentUser: false),
        LeaderboardEntry(rank: 5, name: "Chris L.", score: 82, avatar: "person.circle.fill", isCurrentUser: false)
    ]

    private let challenges = [
        Challenge(title: "10K Steps Daily", progress: 0.75, daysLeft: 3, participants: 24),
        Challenge(title: "Sleep 8 Hours", progress: 0.6, daysLeft: 5, participants: 18),
        Challenge(title: "Morning Workout", progress: 0.9, daysLeft: 1, participants: 12)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Weekly Leaderboard
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Weekly Leaderboard")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(AppColors.foreground)

                                Spacer()

                                Text("This Week")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppColors.mutedForeground)
                            }

                            VStack(spacing: 8) {
                                ForEach(leaderboard) { entry in
                                    LeaderboardRow(entry: entry)
                                }
                            }
                        }
                        .padding(20)
                        .background(AppColors.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)

                        // Active Challenges
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Active Challenges")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(AppColors.foreground)

                                Spacer()

                                Button(action: {}) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "plus")
                                            .font(.system(size: 10))
                                        Text("Join")
                                            .font(.system(size: 12, weight: .medium))
                                    }
                                    .foregroundColor(AppColors.primary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(AppColors.primary.opacity(0.15))
                                    .clipShape(Capsule())
                                }
                            }

                            ForEach(challenges) { challenge in
                                ChallengeCard(challenge: challenge)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Compete")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct LeaderboardEntry: Identifiable {
    let id = UUID()
    let rank: Int
    let name: String
    let score: Int
    let avatar: String
    let isCurrentUser: Bool
}

struct LeaderboardRow: View {
    let entry: LeaderboardEntry

    private var rankColor: Color {
        switch entry.rank {
        case 1: return AppColors.warning
        case 2: return AppColors.mutedForeground
        case 3: return AppColors.movement
        default: return AppColors.mutedForeground
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            Text("\(entry.rank)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(rankColor)
                .frame(width: 24)

            Image(systemName: entry.avatar)
                .font(.system(size: 24))
                .foregroundColor(entry.isCurrentUser ? AppColors.primary : AppColors.mutedForeground)

            Text(entry.name)
                .font(.system(size: 14))
                .fontWeight(entry.isCurrentUser ? .semibold : .regular)
                .foregroundColor(AppColors.foreground)

            Spacer()

            Text("\(entry.score)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(entry.isCurrentUser ? AppColors.primary : AppColors.foreground)
        }
        .padding(12)
        .background(entry.isCurrentUser ? AppColors.primary.opacity(0.1) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct Challenge: Identifiable {
    let id = UUID()
    let title: String
    let progress: Double
    let daysLeft: Int
    let participants: Int
}

struct ChallengeCard: View {
    let challenge: Challenge

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(challenge.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.foreground)

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 10))
                    Text("\(challenge.participants)")
                        .font(.system(size: 12))
                }
                .foregroundColor(AppColors.mutedForeground)
            }

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.border)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: [AppColors.primary, AppColors.workout],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * challenge.progress)
                }
            }
            .frame(height: 8)

            HStack {
                Text("\(Int(challenge.progress * 100))% complete")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mutedForeground)

                Spacer()

                Text("\(challenge.daysLeft) days left")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.primary)
            }
        }
        .padding(16)
        .background(AppColors.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    CompeteView()
        .preferredColorScheme(.light)
}
