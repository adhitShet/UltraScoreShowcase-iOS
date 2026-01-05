import SwiftUI

@main
struct UltraScoreShowcaseApp: App {
    @ObservedObject private var themeManager = ThemeManager.shared

    init() {
        configureAppearance()
    }

    private func configureAppearance() {
        // Configure navigation bar appearance
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = UIColor(AppColors.background)
        navAppearance.shadowColor = .clear
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor(AppColors.foreground)]

        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance

        // Configure tab bar appearance
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = UIColor(AppColors.cardBackground)

        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
                .id(themeManager.isDarkMode) // Force view recreation on theme change
                .onChange(of: themeManager.isDarkMode) {
                    // Update navigation bar colors when theme changes
                    let navAppearance = UINavigationBarAppearance()
                    navAppearance.configureWithOpaqueBackground()
                    navAppearance.backgroundColor = UIColor(AppColors.background)
                    navAppearance.shadowColor = .clear
                    navAppearance.titleTextAttributes = [.foregroundColor: UIColor(AppColors.foreground)]

                    UINavigationBar.appearance().standardAppearance = navAppearance
                    UINavigationBar.appearance().scrollEdgeAppearance = navAppearance

                    // Update tab bar colors
                    let tabAppearance = UITabBarAppearance()
                    tabAppearance.configureWithOpaqueBackground()
                    tabAppearance.backgroundColor = UIColor(AppColors.cardBackground)

                    UITabBar.appearance().standardAppearance = tabAppearance
                    UITabBar.appearance().scrollEdgeAppearance = tabAppearance
                }
        }
    }
}
