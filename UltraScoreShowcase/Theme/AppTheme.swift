import SwiftUI

// MARK: - Theme Manager
class ThemeManager: ObservableObject {
    static let shared = ThemeManager()

    @AppStorage("isDarkMode") var isDarkMode: Bool = false {
        didSet {
            objectWillChange.send()
        }
    }

    func toggleTheme() {
        isDarkMode.toggle()
    }
}

// MARK: - App Colors (Dynamic Light/Dark Mode)
struct AppColors {
    // Reference to theme manager
    private static var isDark: Bool {
        ThemeManager.shared.isDarkMode
    }

    // Background colors
    static var background: Color {
        isDark ? Color(hex: "#0F1419") : Color(hex: "#FAFAFA")
    }

    static var cardBackground: Color {
        isDark ? Color(hex: "#131A24") : Color.white
    }

    // Text colors
    static var foreground: Color {
        isDark ? Color(hex: "#EEF1F6") : Color(hex: "#14203A")
    }

    static var mutedForeground: Color {
        isDark ? Color(hex: "#7A8FA3") : Color(hex: "#5C6A7E")
    }

    static var secondaryForeground: Color {
        isDark ? Color(hex: "#D9E0E8") : Color(hex: "#8B95A5")
    }

    // Primary (Teal in dark, Purple in light)
    static var primary: Color {
        isDark ? Color(hex: "#1EC9A0") : Color(hex: "#7C3AED")
    }

    static var primaryLight: Color {
        primary.opacity(0.15)
    }

    // Health metric colors (optimized for each mode)
    static var movement: Color {
        isDark ? Color(hex: "#FFB71D") : Color(hex: "#F97316")
    }

    static var stress: Color {
        isDark ? Color(hex: "#FF6B6B") : Color(hex: "#8B5CF6")
    }

    static var recovery: Color {
        isDark ? Color(hex: "#32D4A3") : Color(hex: "#10B981")
    }

    static var workout: Color {
        isDark ? Color(hex: "#8B5CF6") : Color(hex: "#EC4899")
    }

    static var heartRate: Color {
        isDark ? Color(hex: "#FF7777") : Color(hex: "#EF4444")
    }

    static var zone: Color {
        isDark ? Color(hex: "#1EC9A0") : Color(hex: "#0EA5E9")
    }

    // Border and dividers
    static var border: Color {
        isDark ? Color(hex: "#1E2A3F") : Color(hex: "#E2E8F0")
    }

    static var divider: Color {
        isDark ? Color(hex: "#1E2A3F") : Color(hex: "#E2E8F0")
    }

    // Glass effect
    static var glassBg: Color {
        isDark ? Color(hex: "#131A24").opacity(0.8) : Color.white.opacity(0.6)
    }

    static var glassBorder: Color {
        isDark ? Color(hex: "#1E2A3F") : Color(hex: "#14203A").opacity(0.08)
    }

    // Status colors
    static var success: Color {
        isDark ? Color(hex: "#32D4A3") : Color(hex: "#10B981")
    }

    static var warning: Color {
        isDark ? Color(hex: "#FFC72C") : Color(hex: "#F59E0B")
    }

    static var error: Color {
        isDark ? Color(hex: "#FF5555") : Color(hex: "#EF4444")
    }

    // Secondary surface (for dark mode cards within cards)
    static var secondaryBackground: Color {
        isDark ? Color(hex: "#1A2538") : Color(hex: "#F1F5F9")
    }
}

// MARK: - Color Extension for Hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Card Style Modifier
struct CardStyle: ViewModifier {
    @ObservedObject private var themeManager = ThemeManager.shared
    var padding: CGFloat = 16
    var cornerRadius: CGFloat = 20

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 2)
    }
}

extension View {
    func cardStyle(padding: CGFloat = 16, cornerRadius: CGFloat = 20) -> some View {
        modifier(CardStyle(padding: padding, cornerRadius: cornerRadius))
    }
}

// MARK: - Glass Card Style
struct GlassCardStyle: ViewModifier {
    @ObservedObject private var themeManager = ThemeManager.shared
    var padding: CGFloat = 16
    var cornerRadius: CGFloat = 24

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(AppColors.glassBg)
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(AppColors.cardBackground)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(AppColors.glassBorder, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.4 : 0.04), radius: 8, x: 0, y: 4)
    }
}

extension View {
    func glassCardStyle(padding: CGFloat = 16, cornerRadius: CGFloat = 24) -> some View {
        modifier(GlassCardStyle(padding: padding, cornerRadius: cornerRadius))
    }
}

// MARK: - Theme-Aware View Modifier
struct ThemeAware: ViewModifier {
    @ObservedObject private var themeManager = ThemeManager.shared

    func body(content: Content) -> some View {
        content
            .id(themeManager.isDarkMode) // Force view refresh on theme change
    }
}

extension View {
    func themeAware() -> some View {
        modifier(ThemeAware())
    }
}
