import SwiftUI

@main
struct UltraScoreShowcaseApp: App {
    init() {
        // Configure navigation bar appearance
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = UIColor(AppColors.background)
        navAppearance.shadowColor = .clear
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor(AppColors.foreground)]

        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
    }
}
