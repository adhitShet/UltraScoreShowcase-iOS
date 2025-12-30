import SwiftUI

// MARK: - App Colors (matching Lovable theme)
struct AppColors {
    // Background colors
    static let background = Color(hex: "#FAFAFA")
    static let cardBackground = Color.white

    // Text colors
    static let foreground = Color(hex: "#14203A")
    static let mutedForeground = Color(hex: "#5C6A7E")
    static let secondaryForeground = Color(hex: "#8B95A5")

    // Primary (Purple)
    static let primary = Color(hex: "#7C3AED")
    static let primaryLight = Color(hex: "#7C3AED").opacity(0.15)

    // Health metric colors
    static let movement = Color(hex: "#F97316")      // Orange
    static let stress = Color(hex: "#8B5CF6")        // Purple
    static let recovery = Color(hex: "#10B981")      // Green/Teal
    static let workout = Color(hex: "#EC4899")       // Pink
    static let heartRate = Color(hex: "#EF4444")     // Red
    static let zone = Color(hex: "#0EA5E9")          // Cyan/Blue

    // Border and dividers
    static let border = Color(hex: "#E2E8F0")
    static let divider = Color(hex: "#E2E8F0")

    // Glass effect
    static let glassBg = Color.white.opacity(0.6)
    static let glassBorder = Color(hex: "#14203A").opacity(0.08)

    // Status colors
    static let success = Color(hex: "#10B981")
    static let warning = Color(hex: "#F59E0B")
    static let error = Color(hex: "#EF4444")
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
    var padding: CGFloat = 16
    var cornerRadius: CGFloat = 20

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}

extension View {
    func cardStyle(padding: CGFloat = 16, cornerRadius: CGFloat = 20) -> some View {
        modifier(CardStyle(padding: padding, cornerRadius: cornerRadius))
    }
}

// MARK: - Glass Card Style
struct GlassCardStyle: ViewModifier {
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
                            .fill(.white)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(AppColors.glassBorder, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}

extension View {
    func glassCardStyle(padding: CGFloat = 16, cornerRadius: CGFloat = 24) -> some View {
        modifier(GlassCardStyle(padding: padding, cornerRadius: cornerRadius))
    }
}
