import SwiftUI

struct CompeteView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var selectedSort: SortOption = .effort
    @State private var showSortMenu = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        // Header with Sort
                        headerSection

                        // Your Stats Card
                        yourStatsCard

                        // Global Rankings
                        LeaderboardSection(
                            title: "Global Rankings",
                            icon: "globe",
                            entries: globalLeaderboard
                        )

                        // Friends Circle
                        LeaderboardSection(
                            title: "Friends Circle",
                            icon: "person.2.fill",
                            entries: friendsLeaderboard
                        )
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.primary)

                Text("Leaderboards")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
            }

            Spacer()

            // Sort Dropdown
            Menu {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Button(action: {
                        selectedSort = option
                    }) {
                        Label(option.label, systemImage: option.icon)
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: selectedSort.icon)
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)

                    Text(selectedSort.label)
                        .font(.system(size: 13))
                        .foregroundColor(AppColors.foreground)

                    Image(systemName: "chevron.down")
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.mutedForeground)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(AppColors.cardBackground)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(AppColors.border.opacity(0.5), lineWidth: 1)
                )
            }
        }
    }

    // MARK: - Your Stats Card
    private var yourStatsCard: some View {
        VStack(spacing: 0) {
            HStack {
                // Avatar and Info
                HStack(spacing: 12) {
                    // Avatar
                    Text("YO")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 48, height: 48)
                        .background(AppColors.primary)
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your Ranking")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppColors.foreground)

                        HStack(spacing: 12) {
                            HStack(spacing: 4) {
                                Image(systemName: "globe")
                                    .font(.system(size: 10))
                                Text("#5 Global")
                                    .font(.system(size: 11))
                            }
                            .foregroundColor(AppColors.mutedForeground)

                            HStack(spacing: 4) {
                                Image(systemName: "person.2.fill")
                                    .font(.system(size: 10))
                                Text("#2 Friends")
                                    .font(.system(size: 11))
                            }
                            .foregroundColor(AppColors.mutedForeground)
                        }
                    }
                }

                Spacer()

                // Score
                VStack(alignment: .trailing, spacing: 2) {
                    Text("89")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(AppColors.primary)

                    Text("Effort Score")
                        .font(.system(size: 11))
                        .foregroundColor(AppColors.mutedForeground)
                }
            }

            // Streak and Progress
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.movement)

                    Text("21 day streak")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)
                }

                Spacer()

                Text("↑ 3 ranks this week")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.recovery)
            }
            .padding(.top, 12)
            .padding(.top, 12)
            .overlay(
                Rectangle()
                    .fill(AppColors.border.opacity(0.3))
                    .frame(height: 1),
                alignment: .top
            )
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(ThemeManager.shared.isDarkMode ? 0.3 : 0.04), radius: 12, x: 0, y: 4)
    }
}

// MARK: - Sort Options
enum SortOption: CaseIterable {
    case effort, streak, sleep, heart

    var label: String {
        switch self {
        case .effort: return "Effort Score"
        case .streak: return "Streak Days"
        case .sleep: return "Sleep Score"
        case .heart: return "Heart Health"
        }
    }

    var icon: String {
        switch self {
        case .effort: return "bolt.fill"
        case .streak: return "flame.fill"
        case .sleep: return "moon.fill"
        case .heart: return "heart.fill"
        }
    }
}

// MARK: - Leaderboard Data
struct LeaderboardUser: Identifiable {
    let id = UUID()
    let name: String
    let avatar: String
    let score: Int
    let rank: Int
    let streak: Int
    let isCurrentUser: Bool
}

let globalLeaderboard: [LeaderboardUser] = [
    LeaderboardUser(name: "Alex Chen", avatar: "AC", score: 98, rank: 1, streak: 45, isCurrentUser: false),
    LeaderboardUser(name: "Maria Santos", avatar: "MS", score: 96, rank: 2, streak: 38, isCurrentUser: false),
    LeaderboardUser(name: "James Wilson", avatar: "JW", score: 94, rank: 3, streak: 32, isCurrentUser: false),
    LeaderboardUser(name: "Emma Thompson", avatar: "ET", score: 91, rank: 4, streak: 28, isCurrentUser: false),
    LeaderboardUser(name: "You", avatar: "YO", score: 89, rank: 5, streak: 21, isCurrentUser: true),
    LeaderboardUser(name: "David Kim", avatar: "DK", score: 87, rank: 6, streak: 19, isCurrentUser: false),
    LeaderboardUser(name: "Sophie Brown", avatar: "SB", score: 85, rank: 7, streak: 15, isCurrentUser: false),
    LeaderboardUser(name: "Michael Lee", avatar: "ML", score: 82, rank: 8, streak: 12, isCurrentUser: false)
]

let friendsLeaderboard: [LeaderboardUser] = [
    LeaderboardUser(name: "Sarah Miller", avatar: "SM", score: 92, rank: 1, streak: 28, isCurrentUser: false),
    LeaderboardUser(name: "You", avatar: "YO", score: 89, rank: 2, streak: 21, isCurrentUser: true),
    LeaderboardUser(name: "Tom Anderson", avatar: "TA", score: 86, rank: 3, streak: 18, isCurrentUser: false),
    LeaderboardUser(name: "Lisa Park", avatar: "LP", score: 83, rank: 4, streak: 14, isCurrentUser: false),
    LeaderboardUser(name: "Chris Davis", avatar: "CD", score: 79, rank: 5, streak: 9, isCurrentUser: false)
]

// MARK: - Leaderboard Section
struct LeaderboardSection: View {
    let title: String
    let icon: String
    let entries: [LeaderboardUser]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.primary)
                    .frame(width: 32, height: 32)
                    .background(AppColors.primary.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.foreground)
            }

            // Entries
            VStack(spacing: 4) {
                ForEach(entries) { entry in
                    LeaderboardRow(entry: entry)
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(ThemeManager.shared.isDarkMode ? 0.3 : 0.04), radius: 12, x: 0, y: 4)
    }
}

// MARK: - Leaderboard Row
struct LeaderboardRow: View {
    let entry: LeaderboardUser

    var body: some View {
        HStack(spacing: 12) {
            // Rank Badge
            RankBadge(rank: entry.rank)

            // Avatar
            Text(entry.avatar)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(entry.isCurrentUser ? .white : AppColors.mutedForeground)
                .frame(width: 36, height: 36)
                .background(entry.isCurrentUser ? AppColors.primary : AppColors.border.opacity(0.5))
                .clipShape(Circle())

            // Name and Streak
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(entry.name)
                        .font(.system(size: 14, weight: entry.isCurrentUser ? .semibold : .regular))
                        .foregroundColor(entry.isCurrentUser ? AppColors.primary : AppColors.foreground)
                        .lineLimit(1)

                    if entry.streak >= 20 {
                        HStack(spacing: 2) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 10))
                            Text("\(entry.streak)")
                                .font(.system(size: 10, weight: .medium))
                        }
                        .foregroundColor(AppColors.movement)
                    }
                }
            }

            Spacer()

            // Score
            HStack(spacing: 2) {
                Text("\(entry.score)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.foreground)

                Text("pts")
                    .font(.system(size: 11))
                    .foregroundColor(AppColors.mutedForeground)
            }
        }
        .padding(12)
        .background(entry.isCurrentUser ? AppColors.primary.opacity(0.1) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(entry.isCurrentUser ? AppColors.primary.opacity(0.2) : Color.clear, lineWidth: 1)
        )
    }
}

// MARK: - Rank Badge
struct RankBadge: View {
    let rank: Int

    var body: some View {
        Group {
            if rank == 1 {
                // Gold Trophy
                Image(systemName: "trophy.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                    .frame(width: 28, height: 28)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "#F59E0B"), Color(hex: "#D97706")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .shadow(color: Color(hex: "#F59E0B").opacity(0.4), radius: 4, x: 0, y: 2)
            } else if rank == 2 {
                // Silver
                Text("2")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 28, height: 28)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "#9CA3AF"), Color(hex: "#6B7280")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .shadow(color: Color.gray.opacity(0.3), radius: 3, x: 0, y: 2)
            } else if rank == 3 {
                // Bronze
                Text("3")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 28, height: 28)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "#D97706"), Color(hex: "#B45309")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .shadow(color: Color(hex: "#D97706").opacity(0.3), radius: 3, x: 0, y: 2)
            } else {
                // Other ranks
                Text("\(rank)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.mutedForeground)
                    .frame(width: 28, height: 28)
                    .background(AppColors.border.opacity(0.3))
                    .clipShape(Circle())
            }
        }
    }
}

#Preview {
    CompeteView()
        .preferredColorScheme(.light)
}
