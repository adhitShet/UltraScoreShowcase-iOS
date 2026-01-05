import SwiftUI

struct SideMenuView: View {
    @Binding var isPresented: Bool
    var onNavigate: ((SideMenuDestination) -> Void)? = nil
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var showProfileSwitcher = false
    @State private var activeProfileId = "1"

    private let profiles = [
        ("1", "Apurva"),
        ("2", "Work Profile"),
        ("3", "Guest")
    ]

    enum SideMenuDestination {
        case myRing
        case allRings
        case devices
        case integrations
    }

    var body: some View {
        ZStack {
            // Backdrop
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.3)) {
                        isPresented = false
                    }
                }

            // Menu Panel
            HStack {
                VStack(spacing: 0) {
                    // Header
                    menuHeader

                    // Menu Items
                    ScrollView {
                        VStack(spacing: 16) {
                            // Ring Section
                            ringSection

                            // General Section
                            generalSection

                            // Logout
                            logoutButton
                        }
                        .padding(16)
                    }
                }
                .frame(width: 300)
                .background(AppColors.cardBackground)

                Spacer()
            }
            .transition(.move(edge: .leading))
        }
        .sheet(isPresented: $showProfileSwitcher) {
            ProfileSwitcherSheet(
                profiles: profiles,
                activeProfileId: $activeProfileId,
                isPresented: $showProfileSwitcher
            )
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Header
    private var menuHeader: some View {
        VStack(spacing: 0) {
            // Profile section
            HStack(spacing: 16) {
                // Avatar with golden rim
                ZStack {
                    // Glow effect
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "#FFD700"), Color(hex: "#B8860B")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .blur(radius: 8)
                        .opacity(0.5)

                    // Golden border
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [Color(hex: "#FFD700"), Color(hex: "#B8860B"), Color(hex: "#FFD700")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 56, height: 56)

                    // Avatar placeholder
                    Circle()
                        .fill(AppColors.primary.opacity(0.3))
                        .frame(width: 52, height: 52)

                    Text("A")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(AppColors.primary)
                }

                // Name and info
                VStack(alignment: .leading, spacing: 2) {
                    Button(action: { showProfileSwitcher = true }) {
                        HStack(spacing: 4) {
                            Text(profiles.first { $0.0 == activeProfileId }?.1 ?? "Apurva")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(AppColors.foreground)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.mutedForeground)
                        }
                    }

                    Text("Cyborg Since Jan 2021 • Invited by Mohit")
                        .font(.system(size: 11))
                        .foregroundColor(AppColors.mutedForeground)
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 60)
            .padding(.bottom, 16)

            // Ultra Age section
            VStack(alignment: .leading, spacing: 4) {
                Text("ULTRA AGE")
                    .font(.system(size: 9, weight: .semibold))
                    .tracking(1.5)
                    .foregroundColor(AppColors.mutedForeground)

                Text("28")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(AppColors.recovery)

                Text("Aging 2 yrs slower")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.recovery)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)

            // Stats row
            HStack(spacing: 0) {
                StatItem(value: "23,456", label: "STEPS")
                Spacer()
                Text("•")
                    .foregroundColor(AppColors.border)
                Spacer()
                StatItem(value: "69", label: "MS HRV")
                Spacer()
                Text("•")
                    .foregroundColor(AppColors.border)
                Spacer()
                StatItem(value: "38", label: "BPM RHR")
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(AppColors.border.opacity(0.1))
        }
    }

    // MARK: - Ring Section
    private var ringSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("RING AIR ASTER BLACK")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.foreground)

                Button(action: {
                    isPresented = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        onNavigate?(.allRings)
                    }
                }) {
                    Text("Change")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.primary)
                }
            }

            HStack(spacing: 4) {
                Image(systemName: "checkmark")
                    .font(.system(size: 10))
                    .foregroundColor(AppColors.recovery)
                Text("Connected")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.recovery)
            }

            // Battery row
            Button(action: {
                isPresented = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onNavigate?(.myRing)
                }
            }) {
                MenuItemRow(
                    icon: "battery.50",
                    title: "Battery",
                    subtitle: "96%",
                    badge: "Chill mode",
                    badgeColor: Color(hex: "#0EA5E9"),
                    hasChevron: true
                )
            }
            .buttonStyle(PlainButtonStyle())

            // Firmware row
            MenuItemRow(
                icon: "circle.fill",
                title: "Firmware",
                subtitle: "V2.123 • Update available",
                hasAlert: true,
                hasChevron: true
            )

            // Device Settings
            Button(action: {
                isPresented = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onNavigate?(.devices)
                }
            }) {
                MenuItemRow(
                    icon: "gearshape.fill",
                    title: "Device Settings",
                    subtitle: "Manage ring settings",
                    hasChevron: true
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(12)
        .background(AppColors.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - General Section
    private var generalSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("GENERAL")
                .font(.system(size: 10, weight: .semibold))
                .tracking(0.5)
                .foregroundColor(AppColors.mutedForeground)
                .padding(.leading, 8)

            VStack(spacing: 4) {
                // Dark Mode Toggle
                darkModeToggle

                MenuItemRow(icon: "shippingbox", title: "Order Status", subtitle: "2 items", hasChevron: true)

                Button(action: {
                    isPresented = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        onNavigate?(.integrations)
                    }
                }) {
                    MenuItemRow(icon: "link", title: "Integrations", subtitle: "2 active", hasChevron: true)
                }
                .buttonStyle(PlainButtonStyle())

                MenuItemRow(icon: "chevron.left.forwardslash.chevron.right", title: "Developer Mode")

                MenuItemRow(icon: "briefcase", title: "Join Ultrahuman")

                MenuItemRow(icon: "square.and.arrow.up", title: "Invite a Friend")

                MenuItemRow(icon: "brain.head.profile", title: "Train Ultrahuman")

                MenuItemRow(icon: "ellipsis", title: "More", hasChevron: true)
            }
        }
    }

    // MARK: - Dark Mode Toggle
    private var darkModeToggle: some View {
        HStack(spacing: 16) {
            Image(systemName: themeManager.isDarkMode ? "moon.fill" : "sun.max.fill")
                .font(.system(size: 16))
                .foregroundColor(themeManager.isDarkMode ? Color(hex: "#1EC9A0") : Color(hex: "#F59E0B"))
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text("Dark Mode")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.foreground)
                Text(themeManager.isDarkMode ? "On" : "Off")
                    .font(.system(size: 11))
                    .foregroundColor(AppColors.mutedForeground)
            }

            Spacer()

            Toggle("", isOn: $themeManager.isDarkMode)
                .labelsHidden()
                .tint(AppColors.primary)
        }
        .padding(12)
        .background(AppColors.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Logout Button
    private var logoutButton: some View {
        Button(action: {
            isPresented = false
        }) {
            HStack(spacing: 16) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.heartRate)

                Text("Logout")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(AppColors.heartRate)

                Spacer()
            }
            .padding(12)
            .background(AppColors.heartRate.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - Stat Item
struct StatItem: View {
    let value: String
    let label: String

    var body: some View {
        HStack(spacing: 2) {
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColors.foreground)
            Text(label)
                .font(.system(size: 9))
                .foregroundColor(AppColors.mutedForeground)
        }
    }
}

// MARK: - Menu Item Row
struct MenuItemRow: View {
    let icon: String
    let title: String
    var subtitle: String? = nil
    var badge: String? = nil
    var badgeColor: Color = AppColors.primary
    var hasAlert: Bool = false
    var hasChevron: Bool = false

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(AppColors.foreground)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 8) {
                    Text(title)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(AppColors.foreground)

                    if let badge = badge {
                        HStack(spacing: 4) {
                            Image(systemName: "snowflake")
                                .font(.system(size: 10))
                            Text(badge)
                                .font(.system(size: 10, weight: .medium))
                        }
                        .foregroundColor(badgeColor)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(badgeColor.opacity(0.15))
                        .clipShape(Capsule())
                    }

                    if hasAlert {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 8, height: 8)
                    }
                }

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.mutedForeground)
                }
            }

            Spacer()

            if hasChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mutedForeground)
            }
        }
        .padding(12)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Profile Switcher Sheet
struct ProfileSwitcherSheet: View {
    let profiles: [(String, String)]
    @Binding var activeProfileId: String
    @Binding var isPresented: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                ForEach(profiles, id: \.0) { id, name in
                    Button(action: {
                        activeProfileId = id
                        isPresented = false
                    }) {
                        HStack(spacing: 16) {
                            // Avatar
                            Circle()
                                .fill(AppColors.primary.opacity(0.3))
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Text(String(name.prefix(1)))
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(AppColors.primary)
                                )

                            Text(name)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.foreground)

                            Spacer()

                            if activeProfileId == id {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(AppColors.recovery)
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(activeProfileId == id ? AppColors.primary.opacity(0.1) : AppColors.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(activeProfileId == id ? AppColors.primary.opacity(0.3) : Color.clear, lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(16)
            .navigationTitle("Switch Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - All Rings View
struct AllRingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedRing = "ring1"

    private let rings = [
        RingDevice(id: "ring1", name: "Ring Air", color: "Aster Black", battery: 50, isConnected: true, firmware: "V2.123"),
        RingDevice(id: "ring2", name: "Ring Air", color: "Lunar Silver", battery: 85, isConnected: false, firmware: "V2.120"),
        RingDevice(id: "ring3", name: "Ring Rare", color: "Bionic Gold", battery: 0, isConnected: false, firmware: "V2.118")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(rings) { ring in
                    RingCard(ring: ring, isSelected: selectedRing == ring.id) {
                        selectedRing = ring.id
                    }
                }

                // Add new ring button
                Button(action: {}) {
                    HStack(spacing: 12) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(AppColors.primary)

                        Text("Pair New Ring")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(AppColors.foreground)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.mutedForeground)
                    }
                    .padding(16)
                    .background(AppColors.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(16)
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.foreground)
                        .frame(width: 40, height: 40)
                        .background(AppColors.cardBackground)
                        .clipShape(Circle())
                }
            }
            ToolbarItem(placement: .principal) {
                Text("My Rings")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.foreground)
            }
        }
    }
}

struct RingDevice: Identifiable {
    let id: String
    let name: String
    let color: String
    let battery: Int
    let isConnected: Bool
    let firmware: String
}

struct RingCard: View {
    let ring: RingDevice
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Ring icon
                ZStack {
                    Circle()
                        .fill(AppColors.primary.opacity(0.2))
                        .frame(width: 56, height: 56)
                    Image(systemName: "circle.circle")
                        .font(.system(size: 28))
                        .foregroundColor(AppColors.primary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("\(ring.name) \(ring.color)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(AppColors.foreground)

                    HStack(spacing: 8) {
                        if ring.isConnected {
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(AppColors.recovery)
                                    .frame(width: 6, height: 6)
                                Text("Connected")
                                    .foregroundColor(AppColors.recovery)
                            }
                        } else {
                            Text("Not connected")
                                .foregroundColor(AppColors.mutedForeground)
                        }

                        if ring.battery > 0 {
                            Text("•")
                                .foregroundColor(AppColors.border)
                            HStack(spacing: 2) {
                                Image(systemName: ring.battery > 50 ? "battery.75" : "battery.25")
                                Text("\(ring.battery)%")
                            }
                            .foregroundColor(ring.battery < 20 ? AppColors.heartRate : AppColors.mutedForeground)
                        }
                    }
                    .font(.system(size: 12))
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.primary)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? AppColors.primary : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Integrations View
struct IntegrationsView: View {
    @Environment(\.dismiss) private var dismiss

    private let connectedIntegrations = [
        IntegrationItem(id: "apple", name: "Apple Health", description: "Sync workouts, steps, and health data", icon: "apple.logo", iconBg: Color.red, status: .active, lastSync: "2 min ago"),
        IntegrationItem(id: "strava", name: "Strava", description: "Import runs, rides and activities", icon: "figure.outdoor.cycle", iconBg: Color.orange, status: .active, lastSync: "1 hour ago")
    ]

    private let availableIntegrations = [
        IntegrationItem(id: "garmin", name: "Garmin Connect", description: "Sync from Garmin devices", icon: "applewatch", iconBg: Color.gray, status: .inactive),
        IntegrationItem(id: "peloton", name: "Peloton", description: "Import Peloton workout data", icon: "bicycle", iconBg: Color.red.opacity(0.8), status: .pending),
        IntegrationItem(id: "oura", name: "Oura Ring", description: "Sleep and readiness scores", icon: "moon.fill", iconBg: Color.gray, status: .disabled),
        IntegrationItem(id: "whoop", name: "WHOOP", description: "Strain and recovery metrics", icon: "bolt.fill", iconBg: Color.gray, status: .inactive),
        IntegrationItem(id: "fitbit", name: "Fitbit", description: "Steps, sleep and heart rate", icon: "heart.fill", iconBg: Color.pink, status: .inactive),
        IntegrationItem(id: "samsung", name: "Samsung Health", description: "Galaxy Watch and phone data", icon: "smartphone", iconBg: Color.blue, status: .inactive)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Connected section
                VStack(alignment: .leading, spacing: 12) {
                    Text("CONNECTED")
                        .font(.system(size: 10, weight: .semibold))
                        .tracking(0.5)
                        .foregroundColor(AppColors.mutedForeground)
                        .padding(.leading, 4)

                    VStack(spacing: 8) {
                        ForEach(connectedIntegrations) { integration in
                            IntegrationCard(integration: integration)
                        }
                    }
                }

                // Available section
                VStack(alignment: .leading, spacing: 12) {
                    Text("AVAILABLE")
                        .font(.system(size: 10, weight: .semibold))
                        .tracking(0.5)
                        .foregroundColor(AppColors.mutedForeground)
                        .padding(.leading, 4)

                    VStack(spacing: 8) {
                        ForEach(availableIntegrations) { integration in
                            IntegrationCard(integration: integration)
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.foreground)
                        .frame(width: 40, height: 40)
                        .background(AppColors.cardBackground)
                        .clipShape(Circle())
                }
            }
            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    Text("Integrations")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.foreground)
                    Text("\(connectedIntegrations.filter { $0.status == .active }.count) active connections")
                        .font(.system(size: 11))
                        .foregroundColor(AppColors.mutedForeground)
                }
            }
        }
    }
}

enum IntegrationStatus {
    case active, inactive, pending, disabled
}

struct IntegrationItem: Identifiable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let iconBg: Color
    let status: IntegrationStatus
    var lastSync: String? = nil
}

struct IntegrationCard: View {
    let integration: IntegrationItem

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: integration.icon)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 48, height: 48)
                .background(integration.iconBg)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(integration.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(AppColors.foreground)

                    StatusBadge(status: integration.status)
                }

                Text(integration.description)
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mutedForeground)

                if let lastSync = integration.lastSync {
                    Text("Last sync: \(lastSync)")
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.mutedForeground.opacity(0.7))
                }
            }

            Spacer()
        }
        .padding(12)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct StatusBadge: View {
    let status: IntegrationStatus

    private var config: (text: String, color: Color, icon: String?) {
        switch status {
        case .active:
            return ("Active", AppColors.recovery, "checkmark")
        case .inactive:
            return ("Inactive", AppColors.mutedForeground, nil)
        case .pending:
            return ("Pending", Color.orange, "exclamationmark.circle")
        case .disabled:
            return ("Disabled", AppColors.heartRate, "xmark")
        }
    }

    var body: some View {
        HStack(spacing: 4) {
            if let icon = config.icon {
                Image(systemName: icon)
                    .font(.system(size: 8))
            }
            Text(config.text)
                .font(.system(size: 10, weight: .medium))
        }
        .foregroundColor(config.color)
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(config.color.opacity(0.15))
        .clipShape(Capsule())
    }
}

#Preview {
    SideMenuView(isPresented: .constant(true))
}
