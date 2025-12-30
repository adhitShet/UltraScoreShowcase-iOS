import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)

            LongevityView()
                .tabItem {
                    Image(systemName: "waveform.path.ecg")
                    Text("Longevity")
                }
                .tag(1)

            PlugsView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "power.circle.fill" : "power.circle")
                    Text("Plugs")
                }
                .tag(2)

            CompeteView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "trophy.fill" : "trophy")
                    Text("Compete")
                }
                .tag(3)
        }
        .tint(AppColors.primary)
        .onAppear {
            // Configure tab bar appearance for light theme
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.white
            appearance.shadowColor = UIColor.black.withAlphaComponent(0.05)

            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.light)
}
